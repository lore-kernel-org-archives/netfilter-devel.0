From: Jan Engelhardt <jengelh@medozas.de>
Subject: conntrack-utils needs to autoload netlink
Date: Sun, 19 Apr 2009 13:08:32 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904191307310.31907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60189 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbZDSLIg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Apr 2009 07:08:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


I observed that running `conntrack -E` does not autoload 
nf_conntrack_netlink.ko, and as such, does not receive any events. 
`conntrack -L` on the other hand does autoload it, and subsequent -E 
works.


Jan

