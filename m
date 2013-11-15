From: "Dawid Stawiarski - nazwa.pl" <dawid.stawiarski@netart.pl>
Subject: linux 3.12 - snat problem with ftp helper
Date: Fri, 15 Nov 2013 14:07:04 +0100
Message-ID: <52861C78.10607@netart.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.netart.pl ([85.128.128.50]:55502 "EHLO mail.netart.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab3KON3G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:29:06 -0500
Received: from [10.110.10.37] ([10.110.10.37])
	(authenticated bits=0)
	by mail.netart.pl (8.13.8/8.13.8) with ESMTP id rAFD74w4007529
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2013 14:07:05 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hello,

after upgrade to mainline kernel v. 3.12 our machines are not able to 
connect to ftp service (from inside of the lxc containters). Mainline 
kernel 3.11.8 works fine.

Containters use private IP class and are SNATed on host machine to one 
IP address.

this is part of the session captured with tcpdump when the problem occurs:

1 B.21 > A.59236: Flags [P.], seq 23:60, ack 17, win 1120, length 37
2 A.59236 > B.21: Flags [P.], seq 17:33, ack 60, win 58, length 16
3 B.21 > A.59236: Flags [.], ack 33, win 1120, length 0
4 B.21 > A.59236: Flags [P.], seq 60:90, ack 33, win 1120, length 30
5 B.21: Flags [P.], seq 33:41, ack 90, win 58, length 8
6 B.21 > A.59236: Flags [.], ack 41, win 1120, length 0
7 B.21 > A.59236: Flags [P.], seq 90:109, ack 41, win 1120, length 19
8 A.59236 > B.21: Flags [P.], seq 42:70, ack 109, win 58, length 28
9 B.21 > A.59236: Flags [.], ack 41, win 1120, options [nop,nop,sack 1 
{42:70}], length 0
10 A.59236 > B.21: Flags [R], seq 4097123445, win 0, length 0
11 A.59236 > B.21: Flags [P.], seq 42:70, ack 109, win 58, length 28
12 B.21 > A.59236: Flags [R], seq 2304960165, win 0, length 0

in packet 8 host sends rewriten PORT command (with changed private to 
public IP) - however the packet has incorrect sequence number (should 
have 41).
the ftp server responds with SACK but the host resets the connection.

Dawid Stawiarski
