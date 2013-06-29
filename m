From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] fix filenames typo in print_usage and file header
Date: Sat, 29 Jun 2013 12:30:33 +0200
Message-ID: <20130629103033.GB5687@localhost>
References: <1166283489.20130619142210@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: gapsf <gapsf@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45608 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab3F2Kai (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 06:30:38 -0400
Content-Disposition: inline
In-Reply-To: <1166283489.20130619142210@yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 19, 2013 at 02:22:10PM +0700, gapsf wrote:
> From ccb45b16c88959737670ef79e5aba47c406b2f70 Mon Sep 17 00:00:00 2001
> From: gapsf <gapsf@yandex.ru>
> Date: Thu, 13 Jun 2013 22:30:34 +0700
> Subject: [PATCH] fix filenames typo in print_usage and file header
> 
> ---
>  src/nf-table-add.c         | 2 +-
>  src/nf-table-delete.c      | 2 +-
>  src/nl-cls-delete.c        | 2 +-
>  src/nl-link-list.c         | 2 +-
>  src/nl-link-name2ifindex.c | 2 +-
>  src/nl-rule-list.c         | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/src/nf-table-add.c b/src/nf-table-add.c
> index 58ce30f..2989503 100644
> --- a/src/nf-table-add.c
> +++ b/src/nf-table-add.c
> @@ -17,7 +17,7 @@
>  static void print_usage(void)
>  {
>         printf(
> -       "Usage: nf-ct-add <family> <name>\n"
> +       "Usage: nf-table-add <family> <name>\n"
>         );
>         exit(1);
>  }
> diff --git a/src/nf-table-delete.c b/src/nf-table-delete.c
> index a15e772..7a49a01 100644
> --- a/src/nf-table-delete.c
> +++ b/src/nf-table-delete.c
> @@ -17,7 +17,7 @@
>  static void print_usage(void)
>  {
>         printf(
> -       "Usage: nf-ct-delete <family> <name>\n"
> +       "Usage: nf-table-delete <family> <name>\n"
>         );
>         exit(1);
>  }

Applied the two chunks above, thanks.

The remain ones belong to libnl.

> diff --git a/src/nl-cls-delete.c b/src/nl-cls-delete.c
> index cfdc170..95abd54 100644
> --- a/src/nl-cls-delete.c
> +++ b/src/nl-cls-delete.c
> @@ -18,7 +18,7 @@ static struct nl_sock *sock;
>  static void print_usage(void)
>  {
>         printf(
> -       "Usage: nl-cls-list [OPTION]... [CLASSIFIER]\n"
> +       "Usage: nl-cls-delete [OPTION]... [CLASSIFIER]\n"
>         "\n"
>         "Options\n"
>         " -i, --interactive     Run interactively\n"
> diff --git a/src/nl-link-list.c b/src/nl-link-list.c
> index 5e1e3f6..2f30aad 100644
> --- a/src/nl-link-list.c
> +++ b/src/nl-link-list.c
> @@ -1,5 +1,5 @@
>  /*
> - * src/nl-link-dump.c  Dump link attributes
> + * src/nl-link-list.c  Dump link attributes
>   *
>   *     This library is free software; you can redistribute it and/or
>   *     modify it under the terms of the GNU Lesser General Public
> diff --git a/src/nl-link-name2ifindex.c b/src/nl-link-name2ifindex.c
> index b04af04..6be58e8 100644
> --- a/src/nl-link-name2ifindex.c
> +++ b/src/nl-link-name2ifindex.c
> @@ -14,7 +14,7 @@
>  
>  static void print_usage(void)
>  {
> -       printf("Usage: nl-link-ifindex2name <ifindex>\n");
> +       printf("Usage: nl-link-name2ifindex <ifindex>\n");
>         exit(0);
>  }
>  
> diff --git a/src/nl-rule-list.c b/src/nl-rule-list.c
> index 8b474fa..d4f1d79 100644
> --- a/src/nl-rule-list.c
> +++ b/src/nl-rule-list.c
> @@ -1,5 +1,5 @@
>  /*
> - * src/nl-rule-dump.c     Dump rule attributes
> + * src/nl-rule-list.c     Dump rule attributes
>   *
>   *     This library is free software; you can redistribute it and/or
>   *     modify it under the terms of the GNU Lesser General Public
> -- 
> 1.8.3.msysgit.0
>  

> From ccb45b16c88959737670ef79e5aba47c406b2f70 Mon Sep 17 00:00:00 2001
> From: gapsf <gapsf@yandex.ru>
> Date: Thu, 13 Jun 2013 22:30:34 +0700
> Subject: [PATCH] fix filenames typo in print_usage and file header
> 
> ---
>  src/nf-table-add.c         | 2 +-
>  src/nf-table-delete.c      | 2 +-
>  src/nl-cls-delete.c        | 2 +-
>  src/nl-link-list.c         | 2 +-
>  src/nl-link-name2ifindex.c | 2 +-
>  src/nl-rule-list.c         | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/src/nf-table-add.c b/src/nf-table-add.c
> index 58ce30f..2989503 100644
> --- a/src/nf-table-add.c
> +++ b/src/nf-table-add.c
> @@ -17,7 +17,7 @@
>  static void print_usage(void)
>  {
>  	printf(
> -	"Usage: nf-ct-add <family> <name>\n"
> +	"Usage: nf-table-add <family> <name>\n"
>  	);
>  	exit(1);
>  }
> diff --git a/src/nf-table-delete.c b/src/nf-table-delete.c
> index a15e772..7a49a01 100644
> --- a/src/nf-table-delete.c
> +++ b/src/nf-table-delete.c
> @@ -17,7 +17,7 @@
>  static void print_usage(void)
>  {
>  	printf(
> -	"Usage: nf-ct-delete <family> <name>\n"
> +	"Usage: nf-table-delete <family> <name>\n"
>  	);
>  	exit(1);
>  }
> diff --git a/src/nl-cls-delete.c b/src/nl-cls-delete.c
> index cfdc170..95abd54 100644
> --- a/src/nl-cls-delete.c
> +++ b/src/nl-cls-delete.c
> @@ -18,7 +18,7 @@ static struct nl_sock *sock;
>  static void print_usage(void)
>  {
>  	printf(
> -	"Usage: nl-cls-list [OPTION]... [CLASSIFIER]\n"
> +	"Usage: nl-cls-delete [OPTION]... [CLASSIFIER]\n"
>  	"\n"
>  	"Options\n"
>  	" -i, --interactive     Run interactively\n"
> diff --git a/src/nl-link-list.c b/src/nl-link-list.c
> index 5e1e3f6..2f30aad 100644
> --- a/src/nl-link-list.c
> +++ b/src/nl-link-list.c
> @@ -1,5 +1,5 @@
>  /*
> - * src/nl-link-dump.c	Dump link attributes
> + * src/nl-link-list.c	Dump link attributes
>   *
>   *	This library is free software; you can redistribute it and/or
>   *	modify it under the terms of the GNU Lesser General Public
> diff --git a/src/nl-link-name2ifindex.c b/src/nl-link-name2ifindex.c
> index b04af04..6be58e8 100644
> --- a/src/nl-link-name2ifindex.c
> +++ b/src/nl-link-name2ifindex.c
> @@ -14,7 +14,7 @@
>  
>  static void print_usage(void)
>  {
> -	printf("Usage: nl-link-ifindex2name <ifindex>\n");
> +	printf("Usage: nl-link-name2ifindex <ifindex>\n");
>  	exit(0);
>  }
>  
> diff --git a/src/nl-rule-list.c b/src/nl-rule-list.c
> index 8b474fa..d4f1d79 100644
> --- a/src/nl-rule-list.c
> +++ b/src/nl-rule-list.c
> @@ -1,5 +1,5 @@
>  /*
> - * src/nl-rule-dump.c     Dump rule attributes
> + * src/nl-rule-list.c     Dump rule attributes
>   *
>   *	This library is free software; you can redistribute it and/or
>   *	modify it under the terms of the GNU Lesser General Public
> -- 
> 1.8.3.msysgit.0
> 

