From: Patrick McHardy <kaber@trash.net>
Subject: Re: About the kernel panic using the ip_queue!
Date: Thu, 25 Sep 2008 06:49:38 +0200
Message-ID: <48DB1862.3000209@trash.net>
References: <web-4539790@mail.primecreation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jacky Luk <jacky.luk@primecreation.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57554 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYIYEtl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:49:41 -0400
In-Reply-To: <web-4539790@mail.primecreation.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jacky Luk wrote:
> Hi,
> 
> I am using the ip_queue to copy the packets to the userspace to perform 
> some modification in the system which is installed the Red Hat 
> Enterprise Linux ES release 4 Nahant Update 6 (Kernel: 2.6.9-67.ELsmp). 
> This system has six NIC ports and forms three bondings (Two ports to 
> form one bonding). Therefore, two of the bondings would be used to 
> handle the packet modification. They are belonged to different network 
> and subnets. One of the bonding is belonged to 192.168.0.x and the other 
> one is belonged to 192.168.1.x.
> 
> I have discovered that the system would be freezed under the high 
> traffic loading in certain time. The following is the error message 
> which is captured from the /var/log/message:
> 

> Sep 19 02:25:28 NEIPPROXY02 kernel: EFLAGS: 00010246  (2.6.9-67.ELsmp)
> Sep 19 02:25:28 NEIPPROXY02 kernel: EIP is at flush_old_exec+0x178/0x24c

That doesn't look related to ip_queue. In any case, that kernel
is many years old, so you need to talk to your vendor for support.
There have been *a lot* of queueing related fixes since then.
