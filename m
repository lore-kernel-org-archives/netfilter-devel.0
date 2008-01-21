From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: xt_owner-xt_socket plans
Date: Mon, 21 Jan 2008 13:20:45 +0100
Message-ID: <20080121122044.GA20295@sch.bme.hu>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr> <479461C2.1060703@balabit.hu> <Pine.LNX.4.64.0801211156320.24186@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laszlo Attila Toth <panther@balabit.hu>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:45908 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYAUMxg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:53:36 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801211156320.24186@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On h, jan 21, 2008 at 11:58:34 +0100, Jan Engelhardt wrote:
> 
> On Jan 21 2008 10:11, Laszlo Attila Toth wrote:
> >
> > http://people.netfilter.org/hidden/tproxy/tproxy4-2.6.24-200710190050.tar.bz2
> >
> In the xt_socket code, I just noticed:
> 
> 	struct udphdr *hp;
> 	hp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);
> 
> Does that mean xt_socket only receives UDP? Also, the header should always be
> available so that skb_header_pointer is not necessary.
> Where am I being misled?

No, not just UDP but it uses only the port part of the header which has
the same layout as the TCP header. It's ugly, though. (But I'm afraid this
is not the only place where this appears.)

The skb_header_pointer() might be unnecessary, bit I'm not quite sure
about this. Where exactly do we make sure that we have at least the UDP
header available?

And as already mentioned, the this match depends heavily on the other
parts of the tproxy patchset. In fact we'd need to create a new table to
make it work for NAT-ted connections (the current tproxy patchset has a
problem with SNAT), so it wouldn't be possible to use it on
mangle/PREROUTING... (Do you happen to have any ideas for this new table
name? I wouldn't call it tproxy but something else which tells you its
place in the flowchart, like 'postnat' or something like that.)

-- 
KOVACS Krisztian
