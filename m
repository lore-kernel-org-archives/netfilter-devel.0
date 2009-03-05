From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Identifying if the packet has been conn tracked by the conn
 track  module in the NAT module.
Date: Thu, 5 Mar 2009 14:12:14 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903051409330.4607@fbirervta.pbzchgretzou.qr>
References: <17923cc80903042147p6426a582tb503bff825ab0a5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: sachin sanap <sachin.sanap.1gb@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53619 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029AbZCENMS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:12:18 -0500
In-Reply-To: <17923cc80903042147p6426a582tb503bff825ab0a5b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-05 06:47, sachin sanap wrote:

>Hi,
>
>I want to know if its possible for the NAT module to know if the
>packet sent to it has been identified by conn track modules like FTP,
>H323 and is treated differently than simple NAT.

if (skb->nfct != NULL && !nf_ct_is_untracked(skb))
	/* tracked */
