From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables-save: Exit with error if unable to open proc
 file
Date: Wed, 18 Jan 2017 14:32:30 +0100
Message-ID: <20170118133230.GE12001@breakpoint.cc>
References: <CA+kHd+fMWmomd0ZTWO3nj0iCSOTmXoW-J4S7XNrYq86JznBM0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Thomas Habets <thomas@habets.se>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60644 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751779AbdARNdP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 08:33:15 -0500
Content-Disposition: inline
In-Reply-To: <CA+kHd+fMWmomd0ZTWO3nj0iCSOTmXoW-J4S7XNrYq86JznBM0Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Habets <thomas@habets.se> wrote:
> I sent this before without being subscribed, but it doesn't seem to
> have reached the archives so now retrying while subscribed.

Weird, its an open list (no subscribe required).

> If you're not root, then iptables-save silently fails (both to stderr
> and exit code). This patch fixes that.

Thanks, patch looks good but

> --- a/iptables/ip6tables-save.c
> +++ b/iptables/ip6tables-save.c
> @@ -35,10 +35,16 @@ static int for_each_table(int (*func)(const char
> *tablename))
>         int ret = 1;
>         FILE *procfile = NULL;
>         char tablename[XT_TABLE_MAXNAMELEN+1];
> +       const char *filename = "/proc/net/ip6_tables_names";

static const char filename[] = "

> -       procfile = fopen("/proc/net/ip6_tables_names", "re");
> -       if (!procfile)
> -               return ret;
> +       procfile = fopen(filename, "re");
> +       if (!procfile) {
> +               if (errno == ENOENT) {
> +                       return ret;
> +               }

iptables uses kernel coding style, so

	if (errno == ENOENT)
		return ret;

(no { } )

> +               fprintf(stderr, "Failed to list table names in %s:
> %s\n", filename, strerror(errno));
> +               exit(1);

Looks like your mua mangled the patch and broke long lines.
Can you send with git-send-email?

Otherwise see Documentation/email-clients.txt
in the linux kernel sources.
