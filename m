From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and
 optimization
Date: Thu, 24 Jun 2004 12:24:15 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406241220180.8190-100000@blackhole.kfki.hu>
References: <200406241012.TAA24555@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <kisza@securityaudit.hu>, <netfilter-devel@lists.netfilter.org>,
	<laforge@netfilter.org>, <usagi-core@linux-ipv6.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200406241012.TAA24555@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 24 Jun 2004, Yasuyuki Kozakai wrote:

> OK, I try to solve this problem... But how same problem was managed when
> removing skb_linearize() from "ip_tables.c" ? Maybe the order of arguments
> of target() were changed ?

Exactly!

/* Registration hooks for targets. */
struct ipt_target
{
[...]
        /* Returns verdict.  Argument order changed since 2.4, as this
           must now handle non-linear skbs, using skb_copy_bits and
           skb_ip_make_writable. */
        unsigned int (*target)(struct sk_buff **pskb,
[...]

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
