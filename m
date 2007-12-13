From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: How to duplicate packets in PRE_ROUTING hook and send it to
 multiple machines in simpe way
Date: Thu, 13 Dec 2007 12:53:21 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712131252250.32346@fbirervta.pbzchgretzou.qr>
References: <97993dc40712122246v7d5f3e42o9eee5f9a122c0100@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-failover@lists.netfilter.org,
	netfilter-devel@vger.kernel.org
To: Rohit <will.u.tellmemore@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34303 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbXLMLxW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 06:53:22 -0500
In-Reply-To: <97993dc40712122246v7d5f3e42o9eee5f9a122c0100@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 13 2007 12:16, Rohit wrote:
>
>I want to send tcp packets received on IP1: P1 to different machines
>say IP2:P2, IP3:P3. I have a kernel module which  uses PRE_ROUTING and
>POST_ROUTING.But i am not very clear about how can i make copies of
>each tcp packet that i recieve in PRE_ROUTING and send it to these
>machines __efficiently__ ??

Take http://marc.info/?l=netfilter-devel&m=119601957530762&w=2
It's not perfect yet, but is reported to do its job.
