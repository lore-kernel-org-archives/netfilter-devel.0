From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 2.4 released
Date: Thu, 23 Oct 2008 16:55:42 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810231653270.28786@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu>
 <alpine.LNX.1.10.0810230253170.15215@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0810230253170.15215@bizon.gios.gov.pl>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 23 Oct 2008, Krzysztof Oledzki wrote:

> In file included from net/ipv4/netfilter/ip_set_iptree.c:23:
> include/linux/netfilter_ipv4/ip_set_iptree.h:25: error: field 'gc' has
> incomplete type
> 
> It seems that "#include <linux/timer.h>" is missing in both files, however it
> worked with the previous ipset release (2.6.26.6 + ipset-2.3.2a) without such
> include. Strange.

I did remove a lot of include files - probably my hand was too quick with 
<linux/timer.h>. It is strange, because compiling/running/testing did not 
produce me any warnings/problems on my system.

I'll go throught all the include files again to make sure nothing is 
missing or redundant.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
