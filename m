From: Rodrigo Severo <rodrigo.lists@fabricadeideias.com>
Subject: Re: ippool -X not working
Date: Mon, 08 Dec 2003 10:56:11 -0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD474EB.90906@fabricadeideias.com>
References: <Pine.LNX.4.44.0312051604100.3680-300000@filer.marasystems.com> <1070646289.22338.3.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1070646289.22338.3.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:

>The latest "semi-released" version of the new ippool can be found at:
>http://gandalf.hjorten.nu/ippool/ippool-0.3.2b.tgz
>  
>
I'm trying it in a test machine. Right now I'm still stuck at 
compilation level.

I already compiled a kernel with pool support.

During iptables make I get:

[root@fellini iptables-1.2.9]# make
Extensions found: IPv4:IPMARK IPv4:ROUTE IPv4:condition IPv4:mport 
IPv4:pool IPv4:POOL IPv4:recent IPv4:string IPv4:time IPv6:ah IPv6:esp 
IPv6:frag IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/ 
-DIPTABLES_VERSION=3D\"1.2.9\"  -fPIC -o extensions/libipt_pool_sh.o -c 
extensions/libipt_pool.c
In file included from extensions/libipt_pool.c:13:
include/libippool/ip_pool_support.h:17: parse error before 
"ip_pool_get_index"
include/libippool/ip_pool_support.h:17: warning: type defaults to `int' 
in declaration of `ip_pool_get_index'
include/libippool/ip_pool_support.h:17: warning: data definition has no 
type or storage class
include/libippool/ip_pool_support.h:24: parse error before "ip_pool_t"

AFAICT, the problem is the lack of ip_pool_t definition, but I can't 
find a place where it IS defined so I could include it in ip_pool_suppor=
t.h.

I have not compiled userspace ippool yet.

Suggestions?

>It's not a nice patch, it needs some file-copying and manual chaning of
>Makefile etc...
>  
>
I believe I got the handwork fine but it can also be the reason for my 
problems.



Thanks in advance for your attention,

Rodrigo

-- 
----------------------------------------------------
Rodrigo Severo
F=E1brica de Id=E9ias
Fone: +55(61)321 1357
Fax: +55(61)223 1712
SBS - Quadra 2 - Ed. Empire Center - Sala 1301
Bras=EDlia/DF - Brasil
CEP: 70.070-904
----------------------------------------------------
