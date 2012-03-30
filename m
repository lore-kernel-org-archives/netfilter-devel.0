From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: ipset nomatch not showing
Date: Fri, 30 Mar 2012 17:09:39 +0100
Message-ID: <4F75DAC3.8050903@googlemail.com>
References: <4F6C7368.3040905@googlemail.com> <alpine.DEB.2.00.1203232057030.20864@blackhole.kfki.hu> <4F6CD7DA.1080301@googlemail.com> <alpine.DEB.2.00.1203261055350.24242@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50776 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761065Ab2C3QJu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:09:50 -0400
Received: by wgbdr13 with SMTP id dr13so743265wgb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Mar 2012 09:09:49 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1203261055350.24242@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Could you send me then the patch?
>   
OK, I am posting this for future reference - as it turned out, for some 
reason the method I used to compile/build the kernel modules which form 
part of ipset was not up to scratch ("cp -al" has a lot to answer for!) 
and, apparently, 2 vital files/patches were missed: 
kernel/include/linux/netfilter/ipset/ip_set_ahash.h as well as a hunk in 
net/netfilter/ipset/pfxlen.c.

The kernel compilation miraculously succeeded, but I was not able to use 
the nomatch option, until I fixed the error thanks to Jozsef's help and 
assistance.

-bash-4.1# ipset a test-net 10.1.2.7 timeout 0 nomatch
-bash-4.1# ipset l test-net
Name: test-net
Type: hash:net
Header: family inet hashsize 64 maxelem 5 timeout 0
Size in memory: 924
References: 18
Members:
10.1.2.7 timeout 0 nomatch
10.1.2.0/24 timeout 0
-bash-4.1# ipset t test-net 10.1.2.7
10.1.2.7 is NOT in set test-net.

So, it all works now!
