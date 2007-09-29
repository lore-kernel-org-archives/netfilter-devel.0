From: "john ye" <johny@asimco.com.cn>
Subject: Re: remarkably Increase iptables' speed on SMP system.
Date: Sat, 29 Sep 2007 21:23:06 +0800
Message-ID: <008701c8029b$df6984c0$d6ddfea9@JOHNYE1>
References: <001201c80298$3509ac10$0201a8c0@ibmea4709fd199>
To: <jengelh@computergmbh.de>, <netfilter-devel@vger.kernel.org>,
	<iceburgue@gmail.com>, "John Ye" <johny@asimco.com.cn>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asimco-na.com ([207.138.153.195]:17062 "EHLO
	mail.asimco-na.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbXI2NX0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Sep 2007 09:23:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Dear Everyone,

OK, I will send you the patch soon. I have though that a loadable module should be much better
than kernel patch, because you don't need to compile and rebuild the kernel.

The packet re-ordering can be avoided by hash CPU based on a simple and quick formula

cpu = iph->saddr + iph->daddr + skb->h.th->source + skb->h.th->dest. (for TCP).

so you can see, one TCP connection is always dispatched to one cpu.
This is a CONNTRACK similar issue, but we don't need that complicated as connection tracking,
a simple hash should be enough.

As I said in previous email, we have not considered reordering issue for other protocols
, such as UDP(snat), GRE, etc.

The key is to to hash a cpu(0 to nr_cpus) based on packet. it should be simple and quick hash.


John Ye

----- Original Message ----- 
From: "Jan Engelhardt" <jengelh@computergmbh.de>
To: "John Ye" <johny@asimco.com.cn>
Cc: <netfilter-devel@vger.kernel.org>; "YE QY" <iceburgue@gmail.com>
Sent: Friday, September 28, 2007 9:52 PM
Subject: Re: remarkably Increase iptables' speed on SMP system.



On Sep 28 2007 10:15, John Ye wrote:
>
>It can be viewed and downloaded from blog http://blog.chinaunix.net/u/12848/showart.php?id=389602
>You are welcome to review and test without patching and re-compiling the kerenl.

Well, send a patch. I have no idea what to make out of that single file,
which obviously even has some code that does not look nice.






