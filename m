From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables vs. IPsec SP
Date: Wed, 18 Feb 2009 17:29:08 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902181728190.26536@fbirervta.pbzchgretzou.qr>
References: <8a38e1330902180817h6a2f9017v1b38b7f6a75fd6b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jianqing Zhang <arrow.jianqing@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41061 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbZBRQ3K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:29:10 -0500
In-Reply-To: <8a38e1330902180817h6a2f9017v1b38b7f6a75fd6b3@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-18 17:17, Jianqing Zhang wrote:

>If I configure both IPsec SPs and iptables, when an IP packet is going
>out or coming,  which will process the packet first? SP or iptables
>(netfilters) rules?

On the input path, obviously ESP is the first one seen, then the unpacked one;
on the output path this is precisely reversed.
