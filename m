From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/4 v2] libnftnl: set: Implement new buffer of TLV
 objects.
Date: Tue, 5 Jan 2016 14:28:47 +0100
Message-ID: <20160105132847.GA24311@breakpoint.cc>
References: <1451999013-4313-1-git-send-email-carlosfg@riseup.net>
 <1451999013-4313-2-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kaber@trash.net
To: Carlos Falgueras =?iso-8859-15?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39254 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbcAEN2u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 08:28:50 -0500
Content-Disposition: inline
In-Reply-To: <1451999013-4313-2-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Carlos Falgueras Garc=EDa <carlosfg@riseup.net> wrote:
> These functions allow create a buffer (nftnl_attrbuf) of TLV objects
> (nftnl_attr). It is inspired in libmnl/src/attr.c.

It would be nice to get a summary on how this going to be used.

At this time I don't understand why nftnl needs this api,
the kernel doesn't enforce any format on this data (good), so we cannot
rely on it having any specific format when reading arbitrary userdata
(added by someone else).

> +EXPORT_SYMBOL_ALIAS(nftnl_attrbuf_alloc, nft_attrbuf_alloc);

This should be plain EXPORT_SYMBOL everywhere, ALIAS is just
for backwards compat.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
