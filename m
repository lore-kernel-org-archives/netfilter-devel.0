From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: your mail
Date: Wed, 31 Aug 2011 14:10:01 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108311409060.2589@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1108281611060.31802@frira.zrqbmnf.qr> <alpine.DEB.2.00.1108311352450.31028@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60271 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1HaMKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:10:04 -0400
In-Reply-To: <alpine.DEB.2.00.1108311352450.31028@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-08-31 13:56, Jozsef Kadlecsik wrote:

>Hi Jan,
>
>On Sun, 28 Aug 2011, Jan Engelhardt wrote:
>
>> libxt_SET.c requires IPSET_INVALID_ID, but this constant has moved into 
>> a #ifdef __KERNEL__ section lately and is thus absent from userspace. 
>> (In linux-kernel/include/linux/netfilter/ipset/ip_set.h.)
>
>After rewieving your patches, I don't get it: what userspace tool would 
>use linux-kernel/include/linux/netfilter/ipset/ip_set.h? iptables does 
>definitely not use it and ipset either. So why your patches are 
>required?

iptables/extensions/xt_SET.c #includes <netfilter/xt_set.h> which 
#includes ip_set.h to get at the definition of ip_set.h.
Patch will be resent.

