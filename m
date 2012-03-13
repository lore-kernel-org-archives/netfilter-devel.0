From: Tarkan Erimer <tarkan.erimer@f-secure.com>
Subject: 10GbE Connectivity & Netfilter
Date: Tue, 13 Mar 2012 15:22:04 +0200
Message-ID: <4F5F49FC.1080207@f-secure.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fsmail-out.f-secure.com ([193.110.108.171]:41779 "EHLO
	fsmail-out.f-secure.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2CMNba (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:31:30 -0400
Received: from msgmaster.f-secure.com (fs-193-110-108-019.f-secure.com [193.110.108.19])
	by fsmail-out.f-secure.com (Postfix) with ESMTP id 9E9283414B
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Mar 2012 15:22:04 +0200 (EET)
Received: from pps.filterd (msgagent [127.0.0.1])
	by msgagent.f-secure.com (8.14.4/8.14.4) with SMTP id q2DDJXRS022167
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Mar 2012 15:22:04 +0200
Received: from fsintra.f-secure.com ([10.128.128.79])
	by msgagent.f-secure.com with ESMTP id 13j4hkg5bn-1
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Mar 2012 15:22:04 +0200
Received: from FSFIEX1.FI.F-Secure.com (fsfiex1.fi.f-secure.com [10.128.128.238])
	by fsintra.f-secure.com (Postfix) with ESMTP id 5495826093
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Mar 2012 15:22:04 +0200 (EET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I have some questions regarding to 10GbE connectivity with 
netfilter/iptables. I searched on google. But didn't find anything to 
make a clear conclusion. Most of the results were just confusing, 
conflicting with some others or quite outdated. So, I've decided to 
write here to get best possible answers by its developers' mouth :-)

So, before asking my questions, here are the some details regarding to 
the questioned environment :

- 10GbE NIC connectivity with the same speed direct Internet 
(10Gbit/sec) connection.
- 350.000 - 400.000 packets/sec. inspections/forwarding in some peak 
loads (it happens frequently. So, safe to say that it's average load 
most of the time.)
- In peak times, there is 7-8 Gbit/sec. traffic. Average is around 5 
Gbit/sec.
- Server has plenty of RAM and CPU/Cores. (Don't remember the exact 
configs now.)


My questions :

1- Is netfilter subsystem multi-threaded/multi-core enabled ? So that, 
it can spread the loads across the CPUs/Cores.
2- Can it handle such loads consistently (without any 
issues/bottlenecks) as I've mentioned above ?
3- Is there any performance matrix and/or practical examples to see ?
4- What kind of netfilter/kernel configs recommended for such a load ?


Many Thanks In Advance For Your Valuable Answers!


Cheers.

Tarkan
