From: Meyer Raffaele <raffaele.meyer@fhnw.ch>
Subject: Possible segfault in nft utility
Date: Fri, 8 Apr 2016 11:10:47 +0000
Message-ID: <60982738E3650D41B91037A907B50C6A31797345@MXAMU25.adm.ds.fhnw.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mxnmu12.fhnw.ch ([147.86.3.25]:41987 "EHLO mxnmu12.fhnw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517AbcDHLKv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 07:10:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by mxnmu12.fhnw.ch (Postfix) with ESMTP id ED514114389
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:10:48 +0200 (CEST)
Received: from mxnmu12.fhnw.ch ([127.0.0.1])
 by localhost (mxnmu12.fhnw.ch [127.0.0.1]) (amavisd-new, port 10041)
 with LMTP id 06333-17 for <netfilter-devel@vger.kernel.org>;
 Fri,  8 Apr 2016 13:10:48 +0200 (CEST)
Received: from MXEMU24.edu.ds.fhnw.ch (mxemu24.edu.ds.fhnw.ch [10.51.2.37])
	by mxnmu12.fhnw.ch (Postfix) with ESMTP id 5E535114320
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:10:48 +0200 (CEST)
Content-Language: de-DE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Sir or Madam

I am currently using nftables under Ubuntu 15.10. Kernel version is 4.2.0-16-generic and nftables version is nftables v0.4 (Support Edward Snowden).
I was looking for a way to match packets based on the mss optional value in the tcp header. While using the describe command, I encountered a segfault:

user@machine:~$ nft describe tcp reserved
Segmentation fault (core dumped)

It is not really a bad bug since the reserved keyword is probably not used anyway but I thought to report it. At the same time I wanted to ask if it is possible to match packets on wether they have a MaximumSegmentSize set in the TCP header or not. I want this since most of the TCP-Syn flood tools seem to not set this option and most legitimate TCP stacks do set it.

Greetings
Raffaele Meyer
