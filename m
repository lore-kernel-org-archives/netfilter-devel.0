From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: netfilter & ipv6
Date: Thu, 10 Feb 2005 09:41:14 -0500 (EST)
Message-ID: <60195.142.169.215.10.1108046474.squirrel@142.169.215.10>
References: <42086F50.9090504@niksula.hut.fi> <420B6A93.3080005@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <420B6A93.3080005@niksula.hut.fi>
To: "Jonas Berlin" <jberlin@niksula.hut.fi>
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

On Thu, February 10, 2005 9:07 am, Jonas Berlin said:

Hi Jonas!

>
>   ip6tables ... -j CLASSIFY_v6 --set-class 1:20
>
> Although this works fine, having some modules with suffix _v6 and some
> not is just plain confusing. Is there any way to reuse the CLASSIFY for
> ipv6 name without conflicting with the CLASSIFY module already in pom?
> Maybe I missed something?

You have to create an ipv6 directory into the CLASSIFY in pom.

CLASSIFY/linux/net/ipv6/netfilter/ip6t_CLASSIFY.c

Same for the include
CLASSIFY/linux/include/linux/netfilter_ipv6/ip6t_CLASSIFY.h

Also, just register your target against ip6_tables with the same name
as CLASSIFY would do with ip_tables. There's no conflict in that way.

All of this is a AFAIK.

>
> --
> - xkr47
>

Thanks for your effort,
Samuel
