From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] Delete nfcache use in ip_table
Date: Sat, 07 May 2005 04:44:58 +0000
Message-ID: <427C47CA.1060307@outerspace.dyndns.org>
References: <427A469D.8030305@eurodev.net> <427A49F6.2090607@trash.net>
	<427AB976.8040402@eurodev.net>
	<427B151F.4040101@outerspace.dyndns.org>
	<427B8C36.4060000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <427B8C36.4060000@trash.net>
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

Quoting Patrick McHardy on 2005-05-06 15:24 UTC:
>>Would it be possible (and would it make sense) using #ifdefs to only
>>have those NFC_* visible to userspace? Or would that break something too?
> Possible sure (#ifndef __KERNEL__), but what would the gain be?

I assumed the point by the removal was to make sure nobody used them [in
the kernel] anymore.. But maybe the point is just to phase it out
completely.. :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCfEfIxyF48ZTvn+4RAoMUAKCdCS032rSUAM9AEcpdEfNkuxw22QCgiCrn
bGScaDZ3IReiUdQHhakbVc0=
=NAx/
-----END PGP SIGNATURE-----
