From: Jan Engelhardt <jengelh@medozas.de>
Subject: Scheduled removals
Date: Tue, 6 Jan 2009 04:32:29 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901060425250.14442@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53225 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZAFDcc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:32:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


as per Documentation/feature-removal-schedule.txt, some legacy code is 
ripe for removal. Now while pursuing this I wondered whether the struct 
definitions for the old code in the header files (e.g. in 
linux/netfilter/xt_CONNMARK.h) can also be removed or whether people 
will argue that doing so would unnecessarily cause dismay on behalf the 
potential users (of which there are not any). I am not aware of any 
users, and neither is Search Engine Google, so I'd just take the bait 
and kill it. Vetoes?
