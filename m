From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] Delete nfcache use in ip_table
Date: Fri, 06 May 2005 06:56:31 +0000
Message-ID: <427B151F.4040101@outerspace.dyndns.org>
References: <427A469D.8030305@eurodev.net> <427A49F6.2090607@trash.net>
	<427AB976.8040402@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <427AB976.8040402@eurodev.net>
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

Quoting Pablo Neira on 2005-05-06 00:25 UTC:

> While I was at it, I thought about killing NFC_* stuff in
> include/linux/netfilter[_ipv4].h, then I realized that old iptables
> versions won't compile if I do so. Those will have to remain there to
> ensure backward compatibility compilation.

Would it be possible (and would it make sense) using #ifdefs to only
have those NFC_* visible to userspace? Or would that break something too?

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCexUdxyF48ZTvn+4RAgSSAKCThQsBMaX+WSaqnA/l3Ljyok+QUwCgsrcn
tXAeFh2XKpgg5BnPrgC7XEw=
=ZmxL
-----END PGP SIGNATURE-----
