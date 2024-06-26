# Prepare input data for alfam2()/ALFAM2mod()

prepDat <- function(dat, 
                    app.mthd.name = 'app.mthd', 
                    incorp.name = 'incorp', 
                    source.name = 'man.source',
                    app.mthd.levels = list(ts = c('trailing shoe', 'ts', 'sl\u00E6besko'), 
                                           bc = c('broadcast', 'bc', 'broadspread', 'bredspredning', 'bredspredt'),
                                           os = c('open slot injection', 'os', 'open-slot injection', 'shallow injection', 'nedf\u00E6ldning i gr\u00E6s'), 
                                           cs = c('closed slot injection', 'cs', 'closed-slot injection', 'deep injection', 'nedf\u00E6ldning p\u00E5 sort jord')),
                    incorp.levels = list(shallow = c('shallow', 'harrow'), deep = c('deep', 'plough', 'plow', 'nedbringning')),
                    source.levels = list(pig = c('pig', 'swine', 'svin', 'svinegylle')),
                    warn = TRUE
                    ) {

  # Keep track of number of columns to use in returning data
  ncc <- ncol(dat)
  ndum <- 0

  # Application method
  if (app.mthd.name %in% names(dat)) {
    dat[, app.mthd.name] <- tolower(dat[, app.mthd.name])

    # Convert application method values to standards
    for (i in 1:length(app.mthd.levels)) {
      dat[dat[, app.mthd.name] %in% app.mthd.levels[[i]], app.mthd.name] <- names(app.mthd.levels)[i] 
    }

    # Application method dummy variables
    aml <- names(app.mthd.levels)
    for (i in aml) {
      nn <- paste(app.mthd.name, i, sep = '.')
      if (nn %in% names(dat)) {
        ncc <- ncc - 1
        if (warn) {
          warning(paste0('Overwriting column "', nn, '" with dummy variable values.\n   It is best to avoid this name in input data.'))
        }
      }
      dat[, nn] <- 1 * (dat[, app.mthd.name] == i)
      ndum <- ndum + 1
    }
   }

  # Incorporation
  if (incorp.name %in% names(dat)) {
    dat[, incorp.name] <- tolower(dat[, incorp.name])

    # Replace NA values with 'none'
    if (any(is.na(dat[, incorp.name]))) {
      dat[is.na(dat[, incorp.name]), incorp.name] <- 'none'
      if (warn) {
        warning(paste0('Some NA values in incorporation column ', incorp.name, '.\n   Replacing all of them with "none".'))
      }
    }

    # Convert incorporation values to standards
    for (i in 1:length(incorp.levels)) {
      dat[dat[, incorp.name] %in% incorp.levels[[i]], incorp.name] <- names(incorp.levels)[i] 
    }

    # Incorporation dummy variables
    il <- names(incorp.levels)

    for (i in il) {
      nn <- paste(incorp.name, i, sep = '.')
      if (nn %in% names(dat)) {
        ncc <- ncc - 1
        if (warn) {
          warning(paste0('Overwriting column "', nn, '" with dummy variable values.\n   It is best to avoid this name in input data.'))
        }
      }
      dat[, nn] <- 1 * (dat[, incorp.name] == i)
      ndum <- ndum + 1
    }
   }

  # Source
  if (source.name %in% names(dat)) {
    dat[, source.name] <- tolower(dat[, source.name])

    # Convert source values to standards
    for (i in 1:length(source.levels)) {
      dat[dat[, source.name] %in% source.levels[[i]], source.name] <- names(source.levels)[i] 
    }

    # Source dummy variables
    sl <- names(source.levels)
    for (i in sl) {
      nn <- paste(source.name, i, sep = '.')
      if (nn %in% names(dat)) {
        ncc <- ncc - 1
        if (warn) {
          warning(paste0('Overwriting column "', nn, '" with dummy variable values.\nIt is best to avoid this name in input data.'))
        }
      }
      dat[, nn] <- 1 * (dat[, source.name] == i)
      ndum <- ndum + 1
    }
  }

  if (ndum == 0) {
    if (warn) {
      warning('Argument prep.dum = TRUE but there are no variables to convert to dummy variables!\n  Ignoring prep.dum = TRUE.') 
    }
    return(NULL)
  }
  dum <- dat[, 1:ndum + ncc, drop = FALSE]

  return(dum)
}

