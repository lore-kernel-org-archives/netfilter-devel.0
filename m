From: jpiszcz <jpiszcz@lucidpixels.com>
Subject: Re: [Fwd: Question with printk warnings in ip_conntrack with 2.4.20.]
Date: Fri, 06 Dec 2002 09:27:46 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3DF0B3E2.8060104@lucidpixels.com>
References: <Pine.LNX.4.33.0212061448500.2648-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
List-Id: netfilter-devel.vger.kernel.org

Sure:

http://installkernel.tripod.com/tcpdump.log.bz2

Jozsef Kadlecsik wrote:

>On Thu, 5 Dec 2002, jpiszcz wrote:
>
>  
>
>>Stange?  I am just using vcheck (perl script) that goes out and checks
>>out software for the latest versions.
>>    
>>
>
>If the script uses active mode FTP and when that is refused by the server
>reverts back to passive mode, that is a natural explanation for such log
>entries.
>
>Could you record by tcpdump at least one such FTP session?
>
>  
>
>>Will there possibly be a /proc or kernel config option for warnings such
>>as these?
>>    
>>
>
>In my opinion a new directory tree /proc/sys/net/ipv4/netfilter is
>required so that tuning options could be easily added to the system.
>But that implies backward (in)compatibily issues...
>
>Regards,
>Jozsef
>-
>E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
>PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
>Address : KFKI Research Institute for Particle and Nuclear Physics
>          H-1525 Budapest 114, POB. 49, Hungary
>
>
>
>  
>
