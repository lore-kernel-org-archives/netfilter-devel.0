From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables-save: Exit with error if unable to open proc
 file
Date: Wed, 18 Jan 2017 15:07:17 +0100
Message-ID: <20170118140717.GF12001@breakpoint.cc>
References: <CA+kHd+db15eUCFb+_-T1zJVPSkogyLUTp2Fe-2u9z8B0E3a-_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: thomas@habets.se
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60792 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751761AbdAROHf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 09:07:35 -0500
Content-Disposition: inline
In-Reply-To: <CA+kHd+db15eUCFb+_-T1zJVPSkogyLUTp2Fe-2u9z8B0E3a-_A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

thomas@habets.se <thomas@habets.se> wrote:
> diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
> index f35e921..053413a 100644
> --- a/iptables/ip6tables-save.c
> +++ b/iptables/ip6tables-save.c
> @@ -35,10 +35,16 @@ static int for_each_table(int (*func)(const char
> *tablename))

Still a linewrap here, rest was fine so I fixed this up and applied
the patch, thanks!

I did not notce on 1st review but a 'Signed-off-by' line would be
good for future submissions.
