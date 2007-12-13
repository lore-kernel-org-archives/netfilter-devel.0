From: Rohit <will.u.tellmemore@gmail.com>
Subject: Re: How to duplicate packets in PRE_ROUTING hook and send it to multiple machines in simpe way
Date: Thu, 13 Dec 2007 23:25:24 +0530
Message-ID: <97993dc40712130955l2b22510h119eeaadd934ed28@mail.gmail.com>
References: <97993dc40712122246v7d5f3e42o9eee5f9a122c0100@mail.gmail.com>
	 <Pine.LNX.4.64.0712131252250.32346@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-failover@lists.netfilter.org,
	netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:11971 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbXLMRz1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:55:27 -0500
Received: by el-out-1112.google.com with SMTP id v27so139670ele.23
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Dec 2007 09:55:25 -0800 (PST)
In-Reply-To: <Pine.LNX.4.64.0712131252250.32346@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I was wondering if i copy buffer from PRE_ROUTING and call okfn with
new buffer , okfn being the function pointer passed to my hooking
function @ PRE_ROUTING,will this work always.?? I tried this with test
module and it was working.but i am not sure if it is going to work
always and what can be the issues with this approach.

So  code snippet looks like this.

struct sk_buff * packet2 = skb_copy(*pskb);
if(packet2){
    modify_packet(packet2);   //modify ip addr ,port etc.
     okfn(packet2);
}

This does send packet out . Is this correct way to achieve this ?? Are
there any security or accounting related things that i am missing
here.

--Rohit

On Dec 13, 2007 5:23 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Dec 13 2007 12:16, Rohit wrote:
> >
> >I want to send tcp packets received on IP1: P1 to different machines
> >say IP2:P2, IP3:P3. I have a kernel module which  uses PRE_ROUTING and
> >POST_ROUTING.But i am not very clear about how can i make copies of
> >each tcp packet that i recieve in PRE_ROUTING and send it to these
> >machines __efficiently__ ??
>
> Take http://marc.info/?l=netfilter-devel&m=119601957530762&w=2
> It's not perfect yet, but is reported to do its job.
>
