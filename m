From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] src: fix memory leaks at
 nft_[object]_nlmsg_parse
Date: Tue, 18 Aug 2015 01:54:58 +0200
Message-ID: <20150817235458.GA26360@salvia>
References: <1438770214-3064-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38279 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbbHQXsp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Aug 2015 19:48:45 -0400
Content-Disposition: inline
In-Reply-To: <1438770214-3064-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 05, 2015 at 12:23:34PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> Free object attributes before overwrite it. Fix 'nlmsg_parse' methods=
 of
> following objects: 'table', 'chain', 'rule', 'set' and 'set_element'.

Applied, thanks Carlos.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
