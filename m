From: dansmith <dansmith@riseup.net>
Subject: iptables owner gid matches random packets
Date: Mon, 23 Jun 2014 05:56:09 +0000
Message-ID: <53A7C179.8000507@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:54774 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaFWGDQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:03:16 -0400
Received: from fruiteater.riseup.net (fruiteater-pn.riseup.net [10.0.1.74])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "*.riseup.net", Issuer "Gandi Standard SSL CA" (not verified))
	by mx1.riseup.net (Postfix) with ESMTPS id A0D8151912
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2014 22:56:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, I have an iptables rule:
iptables -I OUTPUT 1 -m state --state NEW -m owner --gid-owner test -j
NFQUEUE --queue-num 11223
an an appropriate nfq handler for queue 11223 in the code.
Group "test" does not have any users in it. The only executable on my
system that has its gid=="test" proceeds to open 10000s of non-blocking
sockets and firing off connect()s. I see all those connect's being
processed by the nfq handler.
However, every once and again, the nfq handler will process a packet
which comes from some random already running process on my machine. I
can tell that the packet is from a different process, because at the
time when nfq triggers, I look up /proc/net/tcp for the source port,
find a correlating inode/socket and then look up which process the
socket belongs to by scanning all pids in  /proc/*<pid>/fd

Is this a known bug? I could come up with minimal code reproducing this
if needed.

