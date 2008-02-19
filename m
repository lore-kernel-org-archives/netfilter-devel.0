From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: UDP entries do not list ctstate
Date: Tue, 19 Feb 2008 01:13:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802190111280.26274@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37558 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYBSANf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:13:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


to figure out what Netfilter actually does, we add a rule to match 
incoming DNS replies for demonstrational purposes:

	iptables -I INPUT -p udp --sport 53 -m conntrack --ctstate 
	ESTABLISHED

as one would expect, ESTABLISHED matches. Now, after the DNS reply has 
been received, running `conntrack -L | grep udp` does not show the 
string "ESTABLISHED" at all, even if I run it within the UDP conntrack 
timeout. Glitch/Bug in /usr/sbin/conntrack?
