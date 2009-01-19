From: Jan Engelhardt <jengelh@medozas.de>
Subject: Rejecting non-CIDR conformant masks?
Date: Mon, 19 Jan 2009 19:19:31 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901191917001.7294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35127 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbZASSTd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:19:33 -0500
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 2FD911C468B6D
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2009 19:19:31 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


once again, with that lovely IRC channel that is out there, I noticed a 
software that produces odd rules, and indeed, the latest iptables 
(and ip6tables) seem to allow a match that has no equivalent CIDR
number, such as:

	-A test -d 0.0.0.123/0.0.0.255

It absolutely works, but if iptables is supposed to support that (is 
it?), I should be adding it to the manpage.
Comments?
