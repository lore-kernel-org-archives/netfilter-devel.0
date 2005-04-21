From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Thu, 21 Apr 2005 13:31:22 +0000
Message-ID: <4267AB2A.9050604@outerspace.dyndns.org>
References: <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>	<20050406044806.GA9711@linuxace.com>
	<4263108E.1030707@trash.net>	<20050419005847.GA591@linuxace.com>
	<42666F4C.5080706@trash.net>	<20050420155308.GA7057@linuxace.com>
	<42667E51.3060005@trash.net>	<20050420172406.GB7057@linuxace.com>
	<42669674.3020905@trash.net>	<20050420182505.GA7612@linuxace.com>
	<4267042A.2090906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4267042A.2090906@trash.net>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Patrick McHardy on 2005-04-21 01:38 UTC:
> Well, I also can't submit a patch that doesn't fix the problem properly
> to -stable. This patch moves helpers to a new hook two priorities below
> ip_conntrack_confirm() and sequence number adjustment to a new hook at
> the next priority, thereby restoreing the old order. Can someone
> affected by the problem please confirm that this patch fixes it?

> +++ edited/include/linux/netfilter_ipv4.h	2005-04-21 03:10:07 +02:00
> @@ -62,6 +62,9 @@
>  	NF_IP_PRI_FILTER = 0,
>  	NF_IP_PRI_NAT_SRC = 100,
>  	NF_IP_PRI_SELINUX_LAST = 225,
> +	NF_IP_PRI_CONNTRACK_HELPER = INT_MAX - 2,
> +	NF_IP_PRI_NAT_SEQ_ADJUST = INT_MAX - 1,
> +	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX,
>  	NF_IP_PRI_LAST = INT_MAX,
>  };

Not that I know much about netfilter hooks or the importance of the
newly added hooks really being the last ones to be executed, but..

Would there be something to lose in using INT_MAX/2 (or something)
instead of INT_MAX as a base for the additions? And/or maybe have a bit
of space between them in case something new pops up later? Of course you
_can_ change them later, but there's always the risk that some 3rd party
software out there basing themselves on a standard kernel including
these additions, so I think it would be nice not to have to change them
later..

That said, I have to repeat that I don't know much about these things,
and thus my suggestions might be too generic.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCZ6snxyF48ZTvn+4RAotTAJ9GZ1G8IETHyC3P5rZ9Z8WWD6RaTQCffE7I
0lxX0NDf8GwBtYt+LE+fReU=
=esWQ
-----END PGP SIGNATURE-----
