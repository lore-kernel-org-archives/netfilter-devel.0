From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: pom-20040409: patches that break iptables-1.2.9-20040409,
 kernel 2.4.25 or pom's runme
Date: Sun, 11 Apr 2004 15:55:23 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040411155523.1fd06a78.johnpol@2ka.mipt.ru>
References: <407928B7.6040505@fl.priv.at>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Friedrich Lobenstock <fl@fl.priv.at>
In-Reply-To: <407928B7.6040505@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 11 Apr 2004 13:15:03 +0200
Friedrich Lobenstock <fl@fl.priv.at> wrote:

> Hi netfilter team!
> 
> *persons responsible for each individual breaking patch CC'd*

Hello, I am maintainer of the OSF extension.

> I want to inform you that the following patches in pom-20040409,
> which btw apply cleanly to the kernel 2.4.25, do break the
> compilation of iptables-1.2.9-20040409:

>    3) base/osf
>         breaks the extension in iptables - see log below

> Extensions found: IPv4:IPV4OPTSSTRIP IPv4:NETLINK IPv4:addrtype 
> IPv4:condition IPv4:fuzzy IPv4:ipv4options IPv4:mport
>   IPv4:nth IPv4:osf IPv4:pool IPv4:POOL IPv4:psd IPv4:quota
>   IPv4:random 
> IPv4:recent IPv4:time IPv4:u32 IPv6:REJECT IPv
> 6:ah IPv6:esp IPv6:frag IPv6:fuzzy IPv6:ipv6header IPv6:nth IPv6:hbh 
> IPv6:dst IPv6:random IPv6:rt
> [...]
> cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/ 
> -DIPTABLES_VERSION=\"1.2.9-20040409\"  -fPIC -o extensions/
> libipt_osf_sh.o -c extensions/libipt_osf.c
> extensions/libipt_osf.c: In function `parse':
> extensions/libipt_osf.c:106: error: `IPT_OSF_NETLINK' undeclared
> (first use in this function)
> extensions/libipt_osf.c:106: error: (Each undeclared identifier is
> reported only once
> extensions/libipt_osf.c:106: error: for each function it appears in.)
> make: *** [extensions/libipt_osf_sh.o] Error 1

What sources do you use?
You need CVS pom-ng + CVS iptables/extensions/libipt_osf.c for
successfull compilation.

IPT_OSF_NETLINK is defined in
patch-o-matic-ng/osf/linux/include/linux/netfilter_ipv4/ipt_osf.h:

#define IPT_OSF_NETLINK		8


With CVS pom-ng and CVS iptables/extensions/libipt_osf.c I can compile
both libipt_osf.so and ipt_osf.o ( using my own scripts, but it doesn't
matter).


Thank you for review.

> 
> -- 
> MfG / Regards
> Friedrich Lobenstock


	Evgeniy Polyakov ( s0mbre )

Only failure makes us experts. -- Theo de Raadt
