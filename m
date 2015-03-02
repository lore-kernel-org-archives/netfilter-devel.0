From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] nft trace
Date: Mon, 2 Mar 2015 01:20:04 +0100
Message-ID: <20150302002004.GA9881@salvia>
References: <54F35515.5050807@rrzn.uni-hannover.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Markus =?iso-8859-1?Q?K=F6tter?= <koetter@rrzn.uni-hannover.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55244 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbbCBAQ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Mar 2015 19:16:28 -0500
Content-Disposition: inline
In-Reply-To: <54F35515.5050807@rrzn.uni-hannover.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing Patrick.

On Sun, Mar 01, 2015 at 07:06:13PM +0100, Markus K=F6tter wrote:
[...]
> I'd love a response regarding the odds of getting the nft trace
> functionality merged - I promise to continue working on it, clean
> things up, I'll take care it is optional and does not tie nft to
> libnetfilter_conntrack (e.g. for embedded platforms).

You can use libmnl, I think there's a example on the tree, so you
don't really need to rely on libnetfilter_log.

It would be good to have a netlink interface to configure nf_log, to
provide a replacement for the existing /proc interface and allow
further configurability (indicate the nfnetlink log group instead of
defaulting on zero). I agree the existing interface to configure the
prefered logging stub is not nice.

I think it's reasonable to have some tracing command intergrated into
nft, but we still have to discuss the text output layout. No
objections from my side if you want to get that rfc patch in better
shape and send us patches.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
