From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Thu, 11 Mar 2004 18:26:31 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0403111818110.16353-100000@blackhole.kfki.hu>
References: <20040311160401.GA1565@finarfin.cooper.xfnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jonathan Cooper <netfilter@jonc.me.uk>
In-Reply-To: <20040311160401.GA1565@finarfin.cooper.xfnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jonathan,

On Thu, 11 Mar 2004, Jonathan Cooper wrote:

> Specifically, the message:
>
> kernel: LIST_DELETE: ip_conntrack_core.c:302
> &ct->tuplehash[IP_CT_DIR_REPLY]'(d40acea4) not in ip_conntrack_hash[hr].
>
> From doing a bit of googling it appears this problem has been around for
> some time; hopefully my situation will help you track it down.

We had such problem at kernel 2.4.20 when an internal routine changed.

> The machine exhibiting the problem has 2 network cards: an nForce2 card
> (eth1) on the motherboard (connected to external network) and a sis900
> (eth0) which is connected via crossover cable to another computer. This
> connection is masqueraded.

So you use NAT. If you could test the system without using
NAT at all (I mean no NAT related module loaded in), that could probably
help to identify the problem.

> Under the 2.4.23 and 2.4.24 kernels my machine would oops on reboot (just
> after killing syslog) after the message had occurred. This has not (yet)
> happened on 2.4.25. One common feature, that has occurred once under
> 2.4.23 and once under 2.4.25 is that after several occurrences of this
> message the computer froze solid, with no keyboard, mouse or network
> response.
>
> I have experienced no problems of this nature with Debian's 2.4.22
> kernel.

All the kernels are downloaded from ftp.kernel.org?

Did you compile all of them with gcc 3.3.3? Could you recompile the
kernels with gcc 2.95?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
