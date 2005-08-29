From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Errors in ip_set.c, ipt_hashlimit.c
Date: Mon, 29 Aug 2005 14:13:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0508291412490.1159@blackhole.kfki.hu>
References: <4312F2A6.7050802@ieee.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nikolai Malykh <nmalykh@ieee.org>
In-Reply-To: <4312F2A6.7050802@ieee.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 29 Aug 2005, Nikolai Malykh wrote:

> there are few errors in ip_set.c and ipt_hashlimit.c
>
> In both missing include statement
>
> #include <linux/netfilter_ipv4/lockhelp.h>
>
> lockhelp.h file missed in 2.6.13 source code tree.

Yes, lockhelp.h was removed from the 2.6.13 tree. Expect the new ipset
version somewhere in this week.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
