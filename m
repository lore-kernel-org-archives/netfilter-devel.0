From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_compat: fix sparse warning
Date: Thu, 12 Feb 2015 14:21:27 +0100
Message-ID: <20150212132127.GA3301@salvia>
References: <20150212101408.20533.19035.stgit@nfdev.cica.es>
 <20150212122025.GB3294@salvia>
 <CAOkSjBgk4=rjyEMPeqZWUJ4_49apz49XsTjtwE2VxrpnJvgipA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47434 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbbBLNSQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 08:18:16 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBgk4=rjyEMPeqZWUJ4_49apz49XsTjtwE2VxrpnJvgipA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 12, 2015 at 01:25:57PM +0100, Arturo Borrero Gonzalez wrote:
> On 12 February 2015 at 13:20, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Feb 12, 2015 at 11:14:09AM +0100, Arturo Borrero Gonzalez wrote:
> >> >> net/netfilter/nft_compat.c:140:37: sparse: incorrect type in assignment (different base types)
> >>    net/netfilter/nft_compat.c:140:37:    expected restricted __be16 [usertype] ethproto
> >>    net/netfilter/nft_compat.c:140:37:    got unsigned char [unsigned] [usertype] proto
> >> >> net/netfilter/nft_compat.c:351:37: sparse: incorrect type in assignment (different base types)
> >>    net/netfilter/nft_compat.c:351:37:    expected restricted __be16 [usertype] ethproto
> >>    net/netfilter/nft_compat.c:351:37:    got unsigned char [unsigned] [usertype] proto
> >
> > This is spotting a more serious problem. The existing code is trimming
> > the ethernet protocol field to u8. We should use u16 all around the
> > code and then force the casting to calm down sparse.
> 
> I see,  I can handle it if you want.

Please, go ahead. Thanks.
