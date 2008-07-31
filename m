From: "Filka Michal" <Michal.Filka@sitronicsts.com>
Subject: Copying sk_buffer
Date: Thu, 31 Jul 2008 16:40:35 +0200
Message-ID: <4474723F928CA640ADB2172099AEAB111E8BF8@exalfa.stromtelecom.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.strom.cz ([80.95.102.231]:13858 "EHLO mail.strom.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbYGaOkd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:40:33 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I try to duplicate an incoming packet(s) in netfilter's prerouting hook.
I create a copy using pskb_copy, then I call netif_rx for new skb
(trying to simulate next incoming packet). netif_rx returns
NET_RX_SUCCESS, however the copy doesn't leave the computer (it is copy
of a "non local" packet, so it should be routed to final destination) -
I cannot see it in tcpdump (I can see original packet)

Does anyone can suggest an idea? What's wrong?

Thanks for your help.

Michal Filka
