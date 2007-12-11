From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Tue, 11 Dec 2007 11:29:42 +0100
Message-ID: <475E6696.50805@trash.net>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>	 <475578F1.8060600@trash.net>	 <beb91d720712040805u7dd0241by2349e9b34c361a87@mail.gmail.com>	 <47557D04.1040101@trash.net>	 <beb91d720712040832p71981f85yd097f86614e680af@mail.gmail.com>	 <47565BB3.9030500@trash.net>	 <beb91d720712050339w7daeb392me3e3e3cc44bad0d@mail.gmail.com>	 <4757C632.60503@trash.net>	 <beb91d720712060325l22f4b609kdc481a64d36768e9@mail.gmail.com>	 <beb91d720712090534i4df4513bk22b840d75e2ff543@mail.gmail.com> <beb91d720712090611va682efcn80db6efb1efbaf0e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43825 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbXLKK3o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:29:44 -0500
In-Reply-To: <beb91d720712090611va682efcn80db6efb1efbaf0e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Salatiel Filho wrote:
> I forgot to mention that the kernel is crosscompiled , but iptables is
> natively compiled. Can this generate this problem ?


It shouldn't, but I haven't seen any other complaints about this
yet, so please try to either compile the kernel natively or also
cross-compile iptables.

