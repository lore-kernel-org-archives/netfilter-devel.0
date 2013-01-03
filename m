From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: allow IPv6 port NAT without address NAT
Date: Thu, 3 Jan 2013 01:13:06 +0100
Message-ID: <20130103001306.GB27394@1984>
References: <20130102155244.GB5133@uweber-WS>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ulrich Weber <ulrich.weber@sophos.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40394 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab3ACANJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:13:09 -0500
Content-Disposition: inline
In-Reply-To: <20130102155244.GB5133@uweber-WS>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Ulrich,

On Wed, Jan 02, 2013 at 04:52:44PM +0100, Ulrich Weber wrote:
> correct parsing of IPv6 port NAT without address NAT
> and also print brackets for port only IPv6 NAT.

I think we can go further with some extra sanity checkings, something
like:

parse_to(...)
[...]
        start = strchr(arg, '[');
        if (start == NULL)
                xtables_error(PARAMETER_PROBLEM,
                              "IPv6 address has to be enclosed in brackets");

That will help users that expect a similar syntax than IPv4 DNAT.

The current error shows misleading error reporting if brackets are
missing:

# ip6tables -D PREROUTING -p tcp -t nat -j DNAT --to :80-110
ip6tables v1.4.17: Bad IP address ":80"

Would you send me a new version of this patch?

Thanks.
