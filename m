From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: xt_owner-xt_socket plans
Date: Mon, 21 Jan 2008 15:46:55 +0100
Message-ID: <20080121144655.GB373@sch.bme.hu>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr> <479461C2.1060703@balabit.hu> <Pine.LNX.4.64.0801211156320.24186@fbirervta.pbzchgretzou.qr> <20080121122044.GA20295@sch.bme.hu> <Pine.LNX.4.64.0801211412380.24186@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: KOVACS Krisztian <hidden@sch.bme.hu>,
	Laszlo Attila Toth <panther@balabit.hu>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:42085 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYAUOq5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:46:57 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801211412380.24186@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On h, jan 21, 2008 at 02:16:58 +0100, Jan Engelhardt wrote:
> >And as already mentioned, the this match depends heavily on the other
> >parts of the tproxy patchset. In fact we'd need to create a new table to
> >make it work for NAT-ted connections (the current tproxy patchset has a
> >problem with SNAT),
> 
> What problem? Maybe it's a bit shortsighted, but I guess if you just
> use the conntrack origsrc/dst instead of iph->saddr, it should be a
> no-brainer, no?

For SNAT, this would be possible. It still wouldn't work for DNAT,
however... (Imagine you have a DNAT rule on nat/PREROUTING and try to do a
socket match _before_ traversing that chain.)

> >so it wouldn't be possible to use it on
> >mangle/PREROUTING... (Do you happen to have any ideas for this new table
> >name? I wouldn't call it tproxy but something else which tells you its
> >place in the flowchart, like 'postnat' or something like that.)

-- 
KOVACS Krisztian
