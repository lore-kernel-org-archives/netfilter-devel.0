From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_gateway locks up
Date: Mon, 22 Oct 2007 00:14:10 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710220012060.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Sam Liddicott <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46748 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXJUWOM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Oct 2007 18:14:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Sam,


just for the fun of it, I tried:

	iptables -t mangle -A PREROUTING -m gateway --nexthop 10.10.96.1

and it locked up hard (not even sysrq-b was possible).
I am not sure why that happened - it does work properly in -t filter -A 
OUTPUT, though. I'll experiment a bit.
The codebase I am on is at 
http://dev.computergmbh.de/wsvn/misc_kernel/xt_gateway/
