From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] CONNMARK getsockopt/setsockopt functionality
Date: Mon, 24 May 2004 09:31:01 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405240929001.15131-100000@blackhole.kfki.hu>
References: <1085125075.1782.36.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1085125075.1782.36.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Fri, 21 May 2004, KOVACS Krisztian wrote:

>   While thinking on problems with traffic control in user-space proxies,
> we came to the conclusion, that under some conditions manually setting
> the connmark value of an already established connection would be really
> useful. (For example, it would be possible to traffic-limit based on
> outband authentication decisions.)
>
>   I've created a patch for connmark, which registers a getsockopt() and
> a setsockopt() function for getting/setting the connection mark. The
> patch is for Linux 2.4.25 + CONNMARK from POM-ng, but theoretically it
> should apply on any 2.4.x version plus the newest connmark patch.

I believe ctnetlink would be the proper tool to do conntrack manipulation
from userspace.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
