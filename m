From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [SOLVED] Re: ipset-4.4 on 2.6.16.60 kernel
Date: Sun, 07 Nov 2010 00:12:42 +0000
Message-ID: <4CD5EEFA.8060403@googlemail.com>
References: <alpine.DEB.2.00.1010012214250.19669@blackhole.kfki.hu> <4CD5B85A.4050007@googlemail.com> <alpine.DEB.2.00.1011062230030.31105@blackhole.kfki.hu> <4CD5DD9A.8000608@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34516 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0KGAMr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Nov 2010 20:12:47 -0400
In-Reply-To: <4CD5DD9A.8000608@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> That is exactly what I did, and it compiled without error. After that 
> I did KERNEL_DIR=... make install and installed the whole thing.
>
> HOWEVER, it still does not work!
>
> After reboot, when I try 'ipset --version' it tells me it does not 
> know the kernel version, so I looked at /lib/modules/2.6.16.60/ and 
> saw that in a directory called 'extra' there were all the ipset 
> modules sitting. So what I did is modprobe all .ko files to load them 
> into the memory. lsmod confirmed it that they are loaded without errors.
>
> So, hopeful that I finally cracked it I executed 'iptables -I 
> blacklist 1 -m set --match-set test dst -j DROP' (I created the 
> treemap called 'test' prior to that) and got this message:
>
> iptables v1.3.7: Unknown arg `--match-set'
> Try `iptables -h' or 'iptables --help' for more information.
>
> Looked in /usr/lib/iptables/ and there are two additional files 
> libipt_set.so and libipt_SET.so, which were installed by the newly 
> compiled version of iptables so don't know why it does not work!

Please ignore the above - it has been a long day and I clearly had too 
much on my plate today. IT WORKS! I've just got the syntax wrong - in 
'older' iptables version the syntax is not --match-set, but just --set 
and I completely forgot about this.

One more thing - it would be nice if you could update the iptables 
1.3.7. section on the ipset installation page to state that both 
ip_set.h and ipt_set.h are needed for re-compilation of iptables in 
order to make the whole thing work, so that others like me don't bang 
their heads against the wall in the future.
