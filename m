From: Michael Richardson <mcr@sandelman.ottawa.on.ca>
Subject: Re: isakmp/ike nat helper
Date: Fri, 14 Jan 2005 11:41:47 -0500
Message-ID: <3236.1105720907@marajade.sandelman.ottawa.on.ca>
References: <41E7B978.1040102@xelerance.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: leon_tseng@wneweb.com.tw, netfilter-devel@lists.netfilter.org
In-Reply-To: Message from Ken Bantoft <ken@xelerance.com>
	of "Fri, 14 Jan 2005 07:22:16 EST." <41E7B978.1040102@xelerance.com>
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


Please do not any helpers for ISAKMP in your NAT.
You just make it worse, and it breaks more often.

Instead, you should be providing: IPv6 support	(via 6to4 to get
address space if you do not have v6 on the outside)

Your customers should use NAT traversal for IPsec. This is widely available.
The NAT-T permits packets to originate from different UDP ports.

- -- 
] Michael Richardson          Xelerance Corporation, Ottawa, ON |  firewalls  [
] mcr @ xelerance.com           Now doing IPsec training, see   |net architect[
] http://www.sandelman.ca/mcr/    www.xelerance.com/training/   |device driver[
] panic("Just another Debian GNU/Linux using, kernel hacking, security guy"); [
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)
Comment: Finger me for keys

iQCVAwUBQef2SoqHRg3pndX9AQGQ3wP9GQTovd0K9CVNilQPACkv2kzcN6LTyXuH
r8Wm1ElBaCuZmob5Gco1pMnoYHMRRsEH6suEUhdD36AodOgaCs3mwGjIGMqC56BO
Pel+8d8Kd+iDXjsaKESno2DypoM2Ap3IPc8TCZoSO6mYw6MY+YdoIzVjmmcjZ4Oq
PuP70ah/C5g=
=InH5
-----END PGP SIGNATURE-----
