From: borg@uu3.net
Subject: Re: Patch using ipset match in policy routing.
Date: Tue, 4 Dec 2012 22:46:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1212042240550.16537@cube>
References: <Pine.LNX.4.64.1212032247290.19414@cube>
 <alpine.DEB.2.00.1212042115450.26188@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.uu3.net ([87.99.63.19]:59742 "EHLO borg.uu3.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab2LDVq5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:46:57 -0500
In-Reply-To: <alpine.DEB.2.00.1212042115450.26188@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

Uh. Seems you didnt read whole email?
This is generaly a fix for wrong src addr in policy routing:
https://bugzilla.kernel.org/show_bug.cgi?id=16216

While using iptables MARK and ip rule fwmark works for forwarded
packets, this breaks localy generated packets making them
routed correctly but having wrong src addr.
This is because kernel first lookups routing table
to get src addr and then pass packet to netfilter.
In that stage is too late to do policy routing for localy
generated packets.

This should be fixed, but unfortunately its not easy.

Regards,
Borg

PS: Does IPSET have any mailing list or contacts? I couldnt
find them.. Thats why I mailed netfilter-devel.


---------- Original message ----------

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: borg@uu3.net
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Patch using ipset match in policy routing.
Date: Tue, 4 Dec 2012 21:22:10 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1212042115450.26188@blackhole.kfki.hu>

Hi,

On Mon, 3 Dec 2012, borg@uu3.net wrote:

> Forwarding here as well. Feels like it belongs here more.
> 
> ---------- Forwarded message ----------
> From: borg@uu3.net
> To: linux-kernel@vger.kernel.org
> Subject: Patch using ipset match in policy routing.
> Date: Mon, 3 Dec 2012 10:57:13 +0100 (CET)
> Message-ID: <Pine.LNX.4.64.1212031042330.4310@cube>
> 
> Hello.
> 
> Here comes the patch thats makes possible to use ipset
> directly in ip rule (policy routing).
> This makes such configuration easier, because
> there is no need to have:
> iptables -t mangle -A OUTPUT -m set --set ... -j MARK --set-mark 1
> ip rule add fwmark 1 lookup 1
> 
> Additionaly, it fixes issue with wrong src addr for unconnected
> protocols such as UDP, ICMP...
> https://bugzilla.kernel.org/show_bug.cgi?id=16216
> 
> Brief question to google confirms that few people might have
> interest in this patch.
> 
> ftp://borg.uu3.net/home/borg/patch/linux-2.6.27.62+ipset_routing.patch
> ftp://borg.uu3.net/home/borg/patch/iproute2+ipset.patch
> 
> To install the patch, first you need to patch kernel using
> ipset (4.5 preffered). Then, you apply this patch.
> Additionaly, you need to patch iproute2 to use new match:
> ip route add ipset <name> src|dst lookup <n>
> 
> The place for this is IPSET webpage I belive, but I mailing
> it here because I have few concerns:
> - Now this patch needs IPSET to be compiled into kernel (no modules)
>   I would like to fix it
> - I had to add 2 new function to API of IPSET, and so I probably
>   doing something wrong.
> - Patch is conditional: CONFIG_IP_NF_SET
>   except in 2 places:
>   size_t payload = NLMSG_ALIGN(sizeof(struct fib_rule_hdr))
>   enum { ... } // FRA_* defs
> 
>   Not sure if this is correct way.
> 
> Sorry that patch is agaist old kernel. I just needed it fast
> for monday and this one is run on 2 production boxes I need
> this feature.
> 
> One box is already patched and is running fine (non SMP host).
> No issues so far. I will compare CPU usage after roughty 24 hrs.
> 
> Second box is SMP and I will try to patch it ASAP.

I'm sorry but please justify why such a feature would be required. I don't 
think "this way there's no need to mark" is enough.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
