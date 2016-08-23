From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables-restore: add missing arguments to
 usage message
Date: Tue, 23 Aug 2016 14:10:31 +0200
Message-ID: <20160823121031.GA27842@salvia>
References: <7d2cbd95-2442-a2c2-4faa-e2da7f2f0507@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Brian Haley <brian.haley@hpe.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41950 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752443AbcHWMLv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 08:11:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 73311B6C7E
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 14:10:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61D92114D61
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 14:10:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8BFA29663F
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 14:10:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <7d2cbd95-2442-a2c2-4faa-e2da7f2f0507@hpe.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 02:47:15PM -0400, Brian Haley wrote:
> 
> iptables-restore was missing -n, -T and -M from the
> usage message, added them to match the man page.
> 
> Signed-off-by: Brian Haley <brian.haley@hpe.com>
> 
> diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
> index 9393924..dc0acb0 100644
> --- a/iptables/ip6tables-restore.c
> +++ b/iptables/ip6tables-restore.c
> @@ -43,13 +43,14 @@ static void print_usage(const char *name, const char *version) __attribute__((no
>  
>  static void print_usage(const char *name, const char *version)
>  {
> -	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h]\n"
> +	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h] [-n] [-T table] [-M command]\n"

Could you also propagate these changes to iptables/xtables-restore.c?

Thanks!

>  			"	   [ --counters ]\n"
>  			"	   [ --verbose ]\n"
>  			"	   [ --test ]\n"
>  			"	   [ --help ]\n"
>  			"	   [ --noflush ]\n"
> -			"          [ --modprobe=<command>]\n", name);
> +			"	   [ --table=<TABLE> ]\n"
> +			"          [ --modprobe=<command> ]\n", name);
>  
>  	exit(1);
>  }
> diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
> index 638b171..2f1522d 100644
> --- a/iptables/iptables-restore.c
> +++ b/iptables/iptables-restore.c
> @@ -42,14 +42,14 @@ static void print_usage(const char *name, const char *version) __attribute__((no
>  
>  static void print_usage(const char *name, const char *version)
>  {
> -	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h]\n"
> +	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h] [-n] [-T table] [-M command]\n"
>  			"	   [ --counters ]\n"
>  			"	   [ --verbose ]\n"
>  			"	   [ --test ]\n"
>  			"	   [ --help ]\n"
>  			"	   [ --noflush ]\n"
>  			"	   [ --table=<TABLE> ]\n"
> -			"          [ --modprobe=<command>]\n", name);
> +			"          [ --modprobe=<command> ]\n", name);
>  
>  	exit(1);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
