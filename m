From: Elise Lennion <elise.lennion@gmail.com>
Subject: Re: [PATCH v2] erec: Make error messages in nft consistent
Date: Wed, 16 Nov 2016 19:51:02 -0200
Message-ID: <20161116215102.GA17545@lennorien.com>
References: <20161116214320.GA17326@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:33495 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936573AbcKPVvJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 16:51:09 -0500
Received: by mail-ua0-f195.google.com with SMTP id 20so12909132uak.0
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 13:51:09 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161116214320.GA17326@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 16, 2016 at 07:43:20PM -0200, Elise Lennion wrote:
> Error messages in nft from parser_bison should state "syntax error" to
> keep consistency. A new error type was defined to include this message.
> 
> Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
> ---
>  include/erec.h     | 5 ++++-
>  src/erec.c         | 3 ++-
>  src/parser_bison.y | 2 +-
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/erec.h b/include/erec.h
> index 36e0efa..8fee151 100644
> --- a/include/erec.h
> +++ b/include/erec.h
> @@ -15,6 +15,7 @@ enum error_record_types {
>  	EREC_INFORMATIONAL,
>  	EREC_WARNING,
>  	EREC_ERROR,
> +	EREC_SYNTAX_ERROR,
>  };
>  
>  #define EREC_MSGBUFSIZE		1024
> @@ -47,8 +48,10 @@ extern struct error_record *erec_create(enum error_record_types type,
>  extern void erec_add_location(struct error_record *erec,
>  			      const struct location *loc);
>  
> -#define error(loc, fmt, args...) \
> +#define __error(loc, fmt, args...) \
>  	erec_create(EREC_ERROR, (loc), (fmt), ## args)
> +#define error(loc, fmt, args...) \
> +	erec_create(EREC_SYNTAX_ERROR, (loc), (fmt), ## args)
>  #define warning(loc, fmt, args...) \
>  	erec_create(EREC_WARNING, (loc), (fmt), ## args)
>  
> diff --git a/src/erec.c b/src/erec.c
> index 3603216..9f01238 100644
> --- a/src/erec.c
> +++ b/src/erec.c
> @@ -30,7 +30,8 @@ const struct location internal_location = {
>  static const char *error_record_names[] = {
>  	[EREC_INFORMATIONAL]	= NULL,
>  	[EREC_WARNING]		= "Warning",
> -	[EREC_ERROR]		= "Error"
> +	[EREC_ERROR]		= "Error",
> +	[EREC_SYNTAX_ERROR]     = "Error: syntax error"
>  };
>  
>  void erec_add_location(struct error_record *erec, const struct location *loc)
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 91955c1..58385fa 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -47,7 +47,7 @@ void parser_init(struct parser_state *state, struct list_head *msgs)
>  static void yyerror(struct location *loc, void *scanner,
>  		    struct parser_state *state, const char *s)
>  {
> -	erec_queue(error(loc, "%s", s), state->msgs);
> +	erec_queue(__error(loc, "%s", s), state->msgs);
>  }
>  
>  static struct scope *current_scope(const struct parser_state *state)
> -- 
> 2.7.4
> 

Please ignore this patch, I'll send a v3 where the changes in different
files are separated.

elise
