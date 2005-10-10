From: =?ISO-8859-1?Q?S=E9bastien_Bernard?= <seb@frankengul.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Mon, 10 Oct 2005 23:48:16 +0200
Message-ID: <434AE1A0.5030400@frankengul.org>
References: <20051010164141.GG5627@rama>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20051010164141.GG5627@rama>
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

Harald Welte a =E9crit :

>Hi Dave!
>
>This is my proposed patch for the problem you've described.  Please test
>and submit.  If it works, I'll also prepare a patch for {arp,ip6}_tables=
.
>
>
>[NETFILTER] ip_tables: fix per cpu handling=20
>
>As David Miller points out, the "smp_processor_id()'s" are not always
>contiguous.  Esp. some boxes like Sun Ultra60 have CPU 0 and 2 installed=
 in
>one system, but no "1".   Therefore the current logic of how iptables
>manages the per cpu copies of the ruleset is broken.  This patch is
>supposed to fix it.
>
>Signed-off-by: Harald Welte <laforge@netfilter.org>
>
>---
>commit e759eaa9e9e92330c5fcfd760d767d4f39375a03
>tree 63b96f7df57f51dc7e284969c3a08b9264cc2c5f
>parent 1ab8dccdbf16c09f8da124fc4c82024de24dfae2
>author Harald Welte <laforge@netfilter.org> Mon, 10 Oct 2005 18:29:24 +0=
200
>committer Harald Welte <laforge@netfilter.org> Mon, 10 Oct 2005 18:29:24=
 +0200
>
>[snip]
> =20
>
I tested this patch on my machine.
It ooops instantly in get_counters() from ip_tables.c.

    Seb
