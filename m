From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.9.1 released
Date: Thu, 15 Sep 2011 00:51:43 +0100
Message-ID: <4E713E0F.1050403@googlemail.com>
References: <alpine.DEB.2.00.1109062143300.9388@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42064 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1INXvy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Sep 2011 19:51:54 -0400
In-Reply-To: <alpine.DEB.2.00.1109062143300.9388@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> I'm happy to announce ipset 6.9.1. It contains two important bugfixes: if 
> you use ipset on a hardware with tight memory usage, please upgrade.
>   
I am trying to compile this source (kernel modules only) against the 
latest fedora-released kernel - 2.6.40 (a.k.a. 3.0.1), but get the 
following errors:

net/netfilter/ipset/ip_set_core.c:244:5: warning: "LINUX_VERSION_CODE" 
is not defined
net/netfilter/ipset/ip_set_core.c:244:26: warning: "KERNEL_VERSION" is 
not defined
net/netfilter/ipset/ip_set_core.c:244:40: error: missing binary operator 
before token "("
net/netfilter/ipset/ip_set_core.c:1175:5: warning: "LINUX_VERSION_CODE" 
is not defined
net/netfilter/ipset/ip_set_core.c:1175:26: warning: "KERNEL_VERSION" is 
not defined
net/netfilter/ipset/ip_set_core.c:1175:40: error: missing binary 
operator before token "("
net/netfilter/ipset/ip_set_core.c: In function 'ip_set_dump':
net/netfilter/ipset/ip_set_core.c:1178: error: too many arguments to 
function 'netlink_dump_start'
make[3]: *** [net/netfilter/ipset/ip_set_core.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [net/netfilter/ipset] Error 2
make[1]: *** [net/netfilter] Error 2
make: *** [net] Error 2
make: *** Waiting for unfinished jobs....


Am I missing something?
