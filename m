From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Allow DNPT target from raw table?
Date: Mon, 06 May 2013 04:38:19 +0200
Message-ID: <2531686.RPhsabGAWo@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:36760 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3EFCid (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 May 2013 22:38:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 4AFBFA1CF7
	for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2013 03:38:27 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 5nVjnnO0fxQJ for <netfilter-devel@vger.kernel.org>;
	Mon,  6 May 2013 03:38:00 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

Currently, the DNPT target is restricted to the mangle table; this means that 
it is effectively impossible to utilise NPT in tandem with conntrack since it's 
impossible to rewrite the destination prefix prior to conntrack taking a look 
at the skb.

Please consider allowing the use of DNPT from the raw table so that it's 
possible to do prefix translation without having to forego the benefits of 
conntrack.

Kind Regards,
Oliver
