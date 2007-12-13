From: Rohit <will.u.tellmemore@gmail.com>
Subject: How to duplicate packets in PRE_ROUTING hook and send it to multiple machines in simpe way
Date: Thu, 13 Dec 2007 12:16:02 +0530
Message-ID: <97993dc40712122246v7d5f3e42o9eee5f9a122c0100@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-failover@lists.netfilter.org,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:44216 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761199AbXLMGqE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:46:04 -0500
Received: by py-out-1112.google.com with SMTP id u77so1349411pyb.16
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Dec 2007 22:46:03 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I want to send tcp packets received on IP1: P1 to different machines
say IP2:P2, IP3:P3. I have a kernel module which  uses PRE_ROUTING and
POST_ROUTING.But i am not very clear about how can i make copies of
each tcp packet that i recieve in PRE_ROUTING and send it to these
machines __efficiently__ ??

How to make copies ??  skb_clone,pskb_copy,skb_copy ?? i will have to
change ip header before sending to other machines so which functions
to be used ??
Or can i do it in some otherway without making copies of packet.

How to send those packets out ?? Where do i need to add these packets
?? The linked list of packets to be sent out from  device ??
Or do i have access to other data structures from the original packet
which i intercepted at PRE_ROUTING  and and use some information which
is there to add myother packets so that they will aslo go out ??


--Rohit

P.S. I have very good reasons for duplicating these tcp packets , so
why to do this is really not the question  : )
