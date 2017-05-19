From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 1/1] iptables: Fix crash on malformed iptables-restore
Date: Fri, 19 May 2017 12:04:10 +0200
Message-ID: <20170519100410.GB28091@breakpoint.cc>
References: <1495187664-7807-1-git-send-email-ojford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver Ford <ojford@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59446 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753053AbdESKEy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 06:04:54 -0400
Content-Disposition: inline
In-Reply-To: <1495187664-7807-1-git-send-email-ojford@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oliver Ford <ojford@gmail.com> wrote:
> Filter a beginning '--t'. Because the getopt_long function allows abbreviations,
> any parameter beginning with '--t' will be treated as '--table'.

No, thats not correct:
--t is treated as --table.
--tfoo is an invalid option.
--ttl is ttl.

So this:

> +				|| !strncmp(param_buffer, "--t", 3)) {
>  				xtables_error(PARAMETER_PROBLEM,
> +					"The -t option (seen in line %u) cannot be "
> +					"used in ip6tables-restore.\n", line);

.. rejects rules like

-A INPUT -m ttl --ttl 32
