From: Chris Wilson <chris@aptivate.org>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Fri, 9 Nov 2012 16:17:23 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1211091609010.6644@lap-x201>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <alpine.LNX.2.01.1211082055570.29371@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:50625 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2KIQR1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:17:27 -0500
Received: from 82-68-244-70.dsl.in-addr.zen.co.uk ([82.68.244.70] helo=lap-x201.local)
	by one-mail.aptivate.org with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.80.1)
	(envelope-from <chris@aptivate.org>)
	id 1TWrGm-0004rN-8b
	for netfilter-devel@vger.kernel.org; Fri, 09 Nov 2012 16:17:24 +0000
In-Reply-To: <alpine.LNX.2.01.1211082055570.29371@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

On Thu, 8 Nov 2012, Jan Engelhardt wrote:

>>> An operating system can therefore never automatically know whether it 
>>> is ok to continue using certain tuples over a link or not, unless the 
>>> user intervenes in some way.
...
>> Even a default-off MASQUERADE flag that says "--update-source-address" would
>> give us the option to have this fixed automatically, provided that people know
>> about the flag and use it.
>
> I'll leave this to the nf_nat maintainer(s) and what direction it
> should go.

While thinking about this last night, I realised that if this is actually 
a bug or limitation in MASQUERADE, then anyone using a Linux router on 
dynamic IP (frequently changing) with one of these UDP devices behind it 
is almost certainly experiencing the same problem:

After the public IP changes (which might be every 8-24 hours in some 
cases), outbound packets from the device keep the old conntrack entry 
alive forever, with the wrong public IP address, and no replies will ever 
be received to those packets. Surely this is a more common scenario than a 
Linux box managing multihoming or failover connections.

I hope that either we will make the MASQUERADE target update the source 
(SNAT) address address automatically by default, or that all cheap router 
vendors will add rules like this:

iptables -t nat -A POSTROUTING -p udp -j MASQUERADE --update-source-address
iptables -t nat -A POSTROUTING -j MASQUERADE

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

