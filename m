From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] iptables-save --log-level keywords
Date: Sat, 7 Sep 2002 16:24:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020907162426.V9675@sunbeam.de.gnumonks.org>
References: <20020826173619.Q27940@sunbeam.de.gnumonks.org> <20020903183643.50621.qmail@web14603.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: application/pgp; x-action=sign; format=text
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Schwendt <mschwendt@yahoo.com>
Content-Disposition: inline; filename="msg.pgp"
In-Reply-To: <20020903183643.50621.qmail@web14603.mail.yahoo.com>; from mschwendt@yahoo.com on Tue, Sep 03, 2002 at 11:36:43AM -0700
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Tue, Sep 03, 2002 at 11:36:43AM -0700, Michael Schwendt wrote:
> Find attached a revised diff against 1.2.7a and CVS that includes a patch
> against the IPv6 LOG extension code.

Thanks, I'll apply the patch to CVS.

> That is impossible. parse_level() in libipt_LOG.c does not allow a
> log-level higher than 7. Example:
> 
>   # iptables -A FORWARD -j LOG --log-level 8 
>   iptables v1.2.6a: log-level 8' unknown
>   Try iptables -h' or 'iptables --help' for more information.

Thanks for pointing this out. 

> Regards,
> Michael Schwendt

> Do You Yahoo!?

No, despite their advertisement efforts.

- -- 
Live long and prosper
- - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+ 
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9egwZXaXGVTD0i/8RAhm7AKCkjYNSnt7h104B3MFYekdaA+Lu/wCfcNlJ
UT15JEOs47YeoTVk2PGpbFI=
=RQ6N
-----END PGP SIGNATURE-----
