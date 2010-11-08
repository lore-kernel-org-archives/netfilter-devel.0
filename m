From: "Yedidia Amit" <amit.yedidia@elbitsystems.com>
Subject: Using Netfiletr hooks without IP stack
Date: Mon, 8 Nov 2010 08:32:03 +0200
Message-ID: <A50724DAD8873141837C64A73A73735F052DD9@mailesl2.esl.corp.elbit.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exn.co.il ([63.218.53.65]:33317 "EHLO exn.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab0KHGap convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:30:45 -0500
Received: from ESLGWOUTMM ([10.0.0.5])
	by exn.co.il (8.13.8/8.11.6) with ESMTP id oA87EbxX006399
	for <netfilter-devel@vger.kernel.org>; Mon, 8 Nov 2010 09:14:37 +0200
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

I want to use the netfilter framework on my system (running linux
2.6.33)
My purpose is to capture and manipulate IP packets. The catch is that I
am working without the IP stack, so I need to capture the packets in the
Ethernet layer.  I have BSD sockets but the TCP/IP is removed from the
menuconfig

Are there any hooks which are available for me on that level, or should
I add some new ones?
Thanks.

Best Regards,
Amit Yedidia

The information in this e-mail transmission contains proprietary and business 
sensitive information.  Unauthorized interception of this e-mail may constitute 
a violation of law. If you are not the intended recipient, you are hereby 
notified that any review, dissemination, distribution or duplication of this 
communication is strictly prohibited. You are also asked to contact the sender 
by reply email and immediately destroy all copies of the original message.
