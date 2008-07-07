From: Jan Engelhardt <jengelh@medozas.de>
Subject: HTTP connection tracking
Date: Mon, 7 Jul 2008 16:13:38 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807071547330.8248@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34355 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYGGONk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:13:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id BDFF51C061963
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2008 16:13:38 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

a user in irc came up with the following scenario:

- home router is connected to two ISPs with different IP addresses and 
  does round-robin or some other form of packet scheduling.

- in such a setup, one generally uses MARK/CONNMARK to make sure that 
  packets of a certain connection always leave through the same device 
  through which the first packet was sent. (This is required to not 
  break TCP connections.)

But how can we make sure that arbitrary connections which are defined as 
related, can be sent through the same device? Think of a website which, 
when the user is logged in, requires that all HTTP and HTTPS connections 
that will be made by the user, must come from the same IP address.

Connection helpers seemed like a good idea at first, since expected 
connections inherit the connmark value of the original connection. 
However, once an expectation is set up, there is no way to set up 
another right after one expectation has been confirmed.

The stomper approach that seems left is to write a target extension that 
collects destination IP addresses (on IP_CT_NEW) and the mark value of 
the packet, or restores the mark value from the collection cache on 
!IP_CT_NEW.

There got to be a better way. What's Netfilter capable of I don't 
know yet?
