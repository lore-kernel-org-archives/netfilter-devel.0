From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: PANIC: divide by zero in xt_connbytes
Date: Thu, 18 Jan 2007 13:38:41 +0000
Message-ID: <45AF7861.5000201@outerspace.dyndns.org>
References: <45AF5318.8040204@outerspace.dyndns.org>
	<45AF7617.8010202@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45AF7617.8010202@netfilter.org>
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
Hash: RIPEMD160

Quoting Pablo Neira Ayuso on 01/18/2007 01:28 PM UTC:
|> ~  http://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=533
|
| Copied from your patch available on bugzilla:
|
|> diff -ur linux-2.6.19/net/netfilter/xt_connbytes.c linux-2.6.19-xt_connbytes_fix/net/netfilter/xt_connbytes.c
|> --- linux-2.6.19/net/netfilter/xt_connbytes.c	2007-01-11 20:01:51.000000000 +0200
|> +++ linux-2.6.19-xt_connbytes_fix/net/netfilter/xt_connbytes.c	2007-01-18 12:15:50.000000000 +0200
|> @@ -89,26 +89,39 @@
|>  	case XT_CONNBYTES_AVGPKT:
|>  		switch (sinfo->direction) {
|>  		case XT_CONNBYTES_DIR_ORIGINAL:
|> -			what = div64_64(counters[IP_CT_DIR_ORIGINAL].bytes,
|> -					counters[IP_CT_DIR_ORIGINAL].packets);
|
| Better check that divisor must be != 0 inside div64_64.

I initially suggested that too and would have renamed the function to div64_64_safe() or similar in the same go.. but Hidden (on irc) thought it was up to the caller to do the checking, and I felt he probably knows the kernel way of thinking better than me and succumbed. :) I think it's up to Patrick, I'm really only concerned with that it gets fixed :) If Patrick so requests, I'll redo it the other way..

|> +					/* FIXME_THEORETICAL: what to do if sum
|> +					 * overflows ? */
|                                            ^^^
| Hm, already had this discussion: This is really hard to happen with 64
| bits counters, it would take years even in a high performance network.

Well I didn't put it there and it was out of scope to do any modifications to it in this patch :)

- - xkr47

- --
~ "if I'd make up my own definitions, unrational would be the the end
~  result after someone unrationalized something i.e. actively worked
~  to cut down on rationality, whereas irrational would be more a
~  result of laziness or lack of skill"
~                - me, 23.11.2006
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFr3hexyF48ZTvn+4RAz6DAJ4kNXaOEPE3EFCKJsDvmCJVIOjD0gCfRVmV
8iX2XHtLXMcRy0+MnOnoryE=
=fNp+
-----END PGP SIGNATURE-----
