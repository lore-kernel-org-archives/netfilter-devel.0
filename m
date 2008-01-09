From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: kernel-source required?
Date: Wed, 9 Jan 2008 18:30:36 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801091826410.29244@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57504 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYAIRah (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jan 2008 12:30:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


just now as an IRC user posted about a compilation error, the only 
situation that I could think of to load to this error was a missing 
kernel source tree.
Since many Xtables header files are copied to the iptables source tree, 
yet `make KERNEL_DIR=somethinginvalid` gives a compiler error because it 
cannot find <linux/compiler.h> (required by ip_tables.h).

So I wonder, do we actually support building iptables without a 
kernel source tree?
