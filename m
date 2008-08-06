From: Jan Engelhardt <jengelh@medozas.de>
Subject: ebtables "|&" mixup
Date: Wed, 6 Aug 2008 16:44:35 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808061642390.5255@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: bdschuym@pandora.be
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35646 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762671AbYHFUoh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:44:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


I have just spotted

        if (BASE_CHAIN && (natinfo->target | ~EBT_VERDICT_BITS) == 
EBT_RETURN) 

in ebtables's ebt_nat.c (there may be other places), I think this should 
be & ~EBT_VERDICT_BITS instead, should not it?
