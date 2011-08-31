From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: your mail
Date: Wed, 31 Aug 2011 15:04:36 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108311502150.7962@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1108281611060.31802@frira.zrqbmnf.qr> <alpine.DEB.2.00.1108311352450.31028@blackhole.kfki.hu> <alpine.LNX.2.01.1108311409060.2589@frira.zrqbmnf.qr> <alpine.DEB.2.00.1108311414470.31028@blackhole.kfki.hu>
 <alpine.LNX.2.01.1108311444300.30915@frira.zrqbmnf.qr> <alpine.DEB.2.00.1108311447070.31028@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:47584 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab1HaNEi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:04:38 -0400
In-Reply-To: <alpine.DEB.2.00.1108311447070.31028@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-08-31 14:49, Jozsef Kadlecsik wrote:

>On Wed, 31 Aug 2011, Jan Engelhardt wrote:
>
>> On Wednesday 2011-08-31 14:16, Jozsef Kadlecsik wrote:
>> 
>> >On Wed, 31 Aug 2011, Jan Engelhardt wrote:
>> >
>> >> On Wednesday 2011-08-31 13:56, Jozsef Kadlecsik wrote:
>> >> 
>> >> >On Sun, 28 Aug 2011, Jan Engelhardt wrote:
>> >> >
>> >> >> libxt_SET.c requires IPSET_INVALID_ID, but this constant has moved into 
>> >> >> a #ifdef __KERNEL__ section lately and is thus absent from userspace. 
>> >> >> (In linux-kernel/include/linux/netfilter/ipset/ip_set.h.)
>> >> >
>> >> >After rewieving your patches, I don't get it: what userspace tool would 
>> >> >use linux-kernel/include/linux/netfilter/ipset/ip_set.h? iptables does 
>> >> >definitely not use it and ipset either. So why your patches are 
>> >> >required?
>> >> 
>> >> iptables/extensions/xt_SET.c #includes <netfilter/xt_set.h> which 
>> >> #includes ip_set.h to get at the definition of ip_set.h.
>> >> Patch will be resent.
>> >
>> >iptables/extensions/libxt_SET.c includes <linux/netfilter/xt_set.h> and 
>> >xt_set.h includes nothing.
>> 
>> 14:44 seven:../linux/netfilter > git show v3.0:include/linux/netfilter/xt_set.h | grep includ
>> #include <linux/types.h>
>> #include <linux/netfilter/ipset/ip_set.h>
>
>This is the kernel source tree. You wrote about libxt_SET.c and userspace:
>
>kadlec@mentat:/usr/src/git/iptables$ rgrep ip_set.h *
>kadlec@mentat:/usr/src/git/iptables$ 

Of course the header files in the iptables source tree come from the 
(sanitized) kernel headers, and time and again, new copies from the 
kernel are brought into the iptables tree.

(Cf. commits b4af04be14560b3fcc6cf23200148d408014a2f5, 
350661a6eb089f3e54e67e022db9e16ea280499f, 
978e27e8f8c2e49d0528c6c4ae3a56627fbe8492, 
e0bba47e550420e371c97425cc6d39909a6e059b, and possibly more in the 
past.)
