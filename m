From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] netfilter: nf_tables: enforce NLA_NUL_STRING in
 strings
Date: Mon, 31 Mar 2014 14:15:51 +0200
Message-ID: <20140331121551.GC4682@breakpoint.cc>
References: <1396266691-3538-1-git-send-email-pablo@netfilter.org>
 <1396266691-3538-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, kaber@trash.net,
	tgraf@suug.ch
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51930 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982AbaCaMPx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:15:53 -0400
Content-Disposition: inline
In-Reply-To: <1396266691-3538-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:

[cc'd Thomas ]

> nla_strcmp compares the string length plus one, so it's implicitly
> including the nul-termination in the comparison.
> 
>  int nla_strcmp(const struct nlattr *nla, const char *str)
>  {
>         int len = strlen(str) + 1;
>         ...
> 		d = memcmp(nla_data(nla), str, len);

> nla_strcmp compares the string length plus one, so it's implicitly
> including the nul-termination in the comparison.
>  int nla_strcmp(const struct nlattr *nla, const char *str)
>  {
>         int len = strlen(str) + 1;
>         ...
> 		d = memcmp(nla_data(nla), str, len);

[..]

> However, if NLA_STRING is used, userspace can send us a string without
> the null-termination. This is a problem since the nf_tables lookup
> functions won't find any matching as the last byte may mismatch.
> So we have to enforce that strings are nul-termination to avoid
> mismatches.

Looks to me as if the real fix is:

int nla_strcmp(const struct nlattr *nla, const char *str)
{
	return nla_memcmp(nla, str, strlen(str));
}

[ better yet, add static inline wrapper for it ].
