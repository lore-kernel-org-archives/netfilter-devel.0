From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] iptables: ip6table version support and
 libip6t_multiport.fix
Date: Thu, 12 Oct 2006 17:11:02 +0900 (JST)
Message-ID: <200610120811.k9C8B3GM025472@toshiba.co.jp>
References: <200610021747.42658@auguste.remlab.net>
	<200610031430.k93EUJgA008197@toshiba.co.jp>
	<200610032258.30338@auguste.remlab.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: ljlane@debian.org, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: rdenis@simphalempin.com
In-Reply-To: <200610032258.30338@auguste.remlab.net>
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


Hello, sorry for late replying.

From: R=E9mi Denis-Courmont <rdenis@simphalempin.com>
Date: Tue, 3 Oct 2006 22:58:28 +0300

> Le mardi 3 octobre 2006 17:30, vous avez =E9crit :
> > IPv4 multiport match (and policy match, too) would help you. It has=

> > the line
> >
> > 	#include ../../include/netfilter_ipv4/ipt_multiport.h
> >
> > and definitions for old kernel are included in the header.
> =

> Ok. This time there is no trace of (xt|XT)_ at all:

??? Did you send intended patch ? It includes XT_MULTI_PORTS as folows.=


> diff -Nru iptables-1.3.5.orig/extensions/libip6t_multiport.c =

> iptables-1.3.5/extensions/libip6t_multiport.c
> --- iptables-1.3.5.orig/extensions/libip6t_multiport.c	2005-02-19 =

> 21:19:17.000000000 +0200
> +++ iptables-1.3.5/extensions/libip6t_multiport.c	2006-08-27 =

> 13:03:36.000000000 +0300
> @@ -20,6 +20,23 @@
>  " --dports ...\n"
>  "				match destination port(s)\n"
>  " --ports port[,port,port]\n"

snip

> +	for (i=3D0; i<XT_MULTI_PORTS; i++)
> +		multiinfo->pflags[i] =3D 0;
> + =


And I noticed that your mailer breaks the patch. For example, =


> +	printf(" ");
> +}
> +
>  /* Saves the union ip6t_matchinfo in parsable form to stdout. */
>  static void save(const struct ip6t_ip6 *ip, const struct =

> ip6t_entry_match *match)
>  {
> @@ -246,6 +392,41 @@
>  	printf(" ");
>  }

ip6t_entry_match *match) is moved to next line. That should be after
"const struct ".

Regards,

-- Yasuyuki Kozakai
