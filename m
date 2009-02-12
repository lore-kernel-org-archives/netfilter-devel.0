From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] fix source code corruption in ebtables Makefile
Date: Thu, 12 Feb 2009 21:22:29 +0100
Message-ID: <49948505.1000700@pandora.be>
References: <20090211163142.GA28401@tkeitel002.bln.innominate.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: bart.de.schuymer@pandora.be, ebtables-devel@lists.sourceforge.net,
	netfilter-devel@vger.kernel.org
To: Tino Keitel <tkeitel@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:35657 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZBLUWe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:22:34 -0500
In-Reply-To: <20090211163142.GA28401@tkeitel002.bln.innominate.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Thanks for the report. The problem was actually in the naming of the 
nflog init function, see the update in cvs.

cheers,
Bart

Tino Keitel schreef:
> Hi,
>
> the attached patch fixes source code corruption in the static: target
> of the ebtables userspace Makefile. The sed magic tries to clean up the
> modified source files, but fails. It ends up with this modifications:
>
> diff -ru ebtables-v2.0.8-2.orig/extensions/ebt_nflog.c
> ebtables-v2.0.8-2/extensions/ebt_nflog.c
> --- ebtables-v2.0.8-2.orig/extensions/ebt_nflog.c       2009-02-11
> 16:21:37.000000000 +0100
> +++ ebtables-v2.0.8-2/extensions/ebt_nflog.c    2009-02-11
> 17:22:58.000000000 +0100
> @@ -45,7 +45,7 @@
>                "in-kernel queue\n");
>  }
>  
> -static void nflog_init(struct ebt_entry_watcher *watcher)
> +static _init(struct ebt_entry_watcher *watcher)
>  {
>         struct ebt_nflog_info *info = (struct ebt_nflog_info
> *)watcher->data;
>  
> @@ -165,7 +165,7 @@
>         .name = "nflog",
>         .size = sizeof(struct ebt_nflog_info),
>         .help = nflog_help,
> -       .init = nflog_init,
> +       .init _init,
>         .parse = nflog_parse,
>         .final_check = nflog_final_check,
>         .print = nflog_print,
>
> With the patch, the Makefile makes a backup of the original files and
> restores it after compilation.
>
> Signed-off-by: Tino Keitel <tino.keitel@innominate.com>
>
>   

