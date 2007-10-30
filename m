From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_TCPMSS loading issue
Date: Tue, 30 Oct 2007 18:55:01 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0710301853110.31325@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53106 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbXJ3RzD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:55:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id ADC091C05DED6
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Oct 2007 18:55:01 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Using iptables 1.4.0rc1(svn7083), iptables seems to have problems 
autoloading TCPMSS:

18:53 ichi:/ws/iptables # strace -e open ./iptables -t mangle -A OUTPUT 
-d 1.3.3.7 -p tcp --syn -j TCPMSS --clamp-mss-to-pmtu
open("/ws/iptables/extensions/libxt_tcp.so", O_RDONLY) = 3
open("/ws/iptables/extensions/libxt_TCPMSS.so", O_RDONLY) = 3
iptables: No chain/target/match by that name

18:53 ichi:/ws/iptables # modinfo xt_TCPMSS
filename:       
/lib/modules/2.6.23.1-900.ccj58-regular/kernel/net/netfilter/xt_TCPMSS.ko
alias:          ip6t_TCPMSS
alias:          ipt_TCPMSS
description:    x_tables TCP MSS modification module
author:         Marc Boucher <marc@mbsi.ca>
license:        GPL
srcversion:     F9280CB30B14724A70F943F
depends:        x_tables
vermagic:       2.6.23.1-900.ccj58-regular SMP mod_unload 586 

The aliases are there (a common source of errors is lacking these 
aliases). If I manually `modprobe xt_TCPMSS`, iptables succeeds. Any 
idea?
