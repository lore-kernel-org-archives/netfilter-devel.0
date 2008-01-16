From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [0/19] slew of iptables patches
Date: Wed, 16 Jan 2008 14:46:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46840 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYAPNq4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:46:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Filler filler filler filler.
 
Here we are, 19-patch series for iptables.

Autotools comes first, it seemed like a good thing. Hope I got it right. 
Nothing spectacular about the patch, just notice the chmod request in 
it. Please read INSTALL afterwards for the new shiny syntax.

The rest of the patches is boilerplate, code shuffling and waxing and 
so. Old cruft gets gradually removed afterwards. (You can tell I have 
bigger plans :)

Anyway, let the series begin.
