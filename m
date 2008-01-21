From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_owner-xt_socket plans
Date: Mon, 21 Jan 2008 11:58:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801211156320.24186@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr>
 <479461C2.1060703@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37480 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbYAUK6g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:58:36 -0500
In-Reply-To: <479461C2.1060703@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 21 2008 10:11, Laszlo Attila Toth wrote:
>
> http://people.netfilter.org/hidden/tproxy/tproxy4-2.6.24-200710190050.tar.bz2
>
In the xt_socket code, I just noticed:

	struct udphdr *hp;
	hp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);

Does that mean xt_socket only receives UDP? Also, the header should always be
available so that skb_header_pointer is not necessary.
Where am I being misled?
