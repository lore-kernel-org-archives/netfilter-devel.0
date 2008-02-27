From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: helpers register for a specific port, but work anyway
Date: Wed, 27 Feb 2008 15:32:50 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802271528310.15321@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51775 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYB0Ocv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:32:51 -0500
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id A12CE1C1A2309
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2008 15:32:50 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


in nf_conntrack_ftp.c for example we find

             ftp[i][j].tuple.src.u.tcp.port = htons(ports[i]);

assuming the user does not specify any ports on modprobe, the default 
port list defaults to {21}, so ftp[0][x].tuple.src will contain port 21. 
But even ftp connections to non-21 ports are inspected for PORT 
commands. So, where is the magic that actually ignores the port and 
makes it work, given that __nf_ct_helper_find/helper_hash hashes on the 
port?
