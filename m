From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: What can i do ? When i rmmod the modules .
Date: Fri, 9 May 2003 15:08:06 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305091502210.9035-100000@blackhole.kfki.hu>
References: <000801c31625$9c29c510$01e7a8c0@zpeak>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: cyberyam <zpeak@cyberyam.com>
In-Reply-To: <000801c31625$9c29c510$01e7a8c0@zpeak>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 9 May 2003, cyberyam wrote:

> unable to handle kernel NULL pointer dereference at virtual address 000004a0
>  printing eip:
> c689a16e
> *pde = 00000000
> Oops: 0000
> myfirewall ipt_MASQUERADE iptable_nat ip_conntrack autofs pcnet32 mii ipt_REJE
> CPU:    0
> EIP:    0010:[<c689a16e>]    Tainted: P
> EFLAGS: 00000296
>
> EIP is at fini [myfirewall] 0x1e (2.4.18-14)

Unfortunately we don't have telepathy capabilities and cannot read out the
source code of myfirewall from your hard disk.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
