From: "Kaloyan Kovachev" <kkovachev@varna.net>
Subject: new target or new option
Date: Fri, 28 Sep 2007 20:06:21 +0300
Message-ID: <20070928170244.M71172@varna.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=windows-1251
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.Varna.Net ([217.145.80.1]:58994 "EHLO ns.varna.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbXI1R03 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:26:29 -0400
Received: from varna.net (localhost [127.0.0.1])
	by ns.varna.net (8.13.6/8.13.6) with ESMTP id l8SH6LCD003135
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Sep 2007 20:06:21 +0300
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,
 i need to mark the connection with the realm number, but it seems there is no
'easy way' and there should be separate rule for each realm.

 Are there any plans to add this functionality and which is the preferable way
to go:
   1) create new REALMCONNMARK target with and/or mask
   2) extend the current CONNMARK by adding --realm-mark in addition to --set-mark

 I think the second one will be easier and can be done in iptables extension
only without touching the kernel source right?

