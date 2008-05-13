From: "james hough" <jameshough@bemac.com>
Subject: Large packets received from the queue
Date: Tue, 13 May 2008 13:56:23 +0100
Message-ID: <001b01c8b4f8$bf9bb180$5c01a8c0@jimpc>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from omega-smtp.bemac.com ([194.193.56.2]:33579 "EHLO
	omega-real.bemac.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757085AbYENBKI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 21:10:08 -0400
Received: from sigma.bemac.com (localhost [127.0.0.1])
	by omega-real.bemac.com (8.9.3+Sun/8.9.3) with ESMTP id NAA15421
	for <netfilter-devel@vger.kernel.org>; Tue, 13 May 2008 13:56:17 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

I am developing an app on redhat el5 using the NFQUEUE  target. However i 
have hit a problem. first off the traffic i am queueing is TCP traffic only 
and use the following rules to insert these into iptables.

iptables -I INPUT 1 -p tcp -J NFQUEUE --queue-num 1
iptables -I OUTPUT 1 -p tcp -J NFQUEUE --queue-num 0

the problem I have is that my app is receiving larger than MTU packets off 
the queue, often in excess of 2000bytes. The MTU is set to 1500 and the 
problem only seems to occur on outbound traffic when doing file uploads. in 
this case I am doing an FTP put.

At first i thought that the packets were made up of a good packet followed 
by junk data but the ip header of the packet from the queue contains the 
correct size (2000+).

Since this problem became an issue I modified my app so that it simply 
received the packet off the queue, printed the size then set a verdict of 
accept. This showed the same issue that larger than MTU packets where 
entering the queue. This test application is pretty much the same as the 
test app provided with the source but with two queues.

I have installed the latest iptables v1.4.0 and have compiled the latest 
libnfnetlink and libnetfilter_queue but i still get this problem. My kernel 
is 2.6.18.

can anyone help or has experianced this problem before?

Thank you

James


