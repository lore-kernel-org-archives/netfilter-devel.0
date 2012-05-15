From: =?iso-8859-1?Q?Hans_Schillstr=F6m?= <hans.schillstrom@ericsson.com>
Subject: RE: [PATCH] netfilter: xt_HMARK: endian bugs
Date: Tue, 15 May 2012 09:33:17 +0200
Message-ID: <C8A6796DE7C66C4ABCBC18106CB6C1CC164B83BE12@ESESSCMS0356.eemea.ericsson.se>
References: <1337002943-16374-1-git-send-email-hans.schillstrom@ericsson.com>
	 <20120514144052.GD12992@1984>
	 <alpine.LNX.2.01.1205141702110.11548@frira.vanv.qr>,<1337009079.8512.535.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"kaber@trash.net" <kaber@trash.net>,
	"jengelh@medozas.de" <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
	"hans@schillstrom.com" <hans@schillstrom.com>
To: Eric Dumazet <eric.dumazet@gmail.com>,
	Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailgw1.ericsson.se ([193.180.251.45]:42795 "EHLO
	mailgw1.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab2EOHdU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 May 2012 03:33:20 -0400
In-Reply-To: <1337009079.8512.535.camel@edumazet-glaptop>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2012-05-14 at 17:05 +0200, Jan Engelhardt wrote:
> On Monday 2012-05-14 16:40, Pablo Neira Ayuso wrote:
>
> >> -          if (t->uports.p16.dst < t->uports.p16.src)
> >> +          if (ntohs(t->uports.p16.dst) < ntohs(t->uports.p16.src))
> >
> >Do we really need this to make sparse happy?
>

This looks insane to make sparse happy 

static inline u32 addr_mask(const __be32 *addr32, const __be32 *mask)
{
                return (__force u32)htonl((__force u32)(*addr32 & *mask));
}

with the "more logic"  way to write it  sparse complains on everything...

static inline u32 addr_mask(const __be32 *addr32, const __be32 *mask)
{
                return htonl(*addr32 & *mask);
}

Is there a better way to do this ?