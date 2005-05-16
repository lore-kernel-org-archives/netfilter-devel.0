From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Mangling IP Options fields
Date: Mon, 16 May 2005 18:43:35 +0000
Message-ID: <4288E9D7.10306@outerspace.dyndns.org>
References: <42889454.6040300@hoole.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Quinton Hoole <quinton@hoole.biz>
In-Reply-To: <42889454.6040300@hoole.biz>
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

Quoting Quinton Hoole on 2005-05-16 12:38 UTC:
> Is mangling of IP options fields supported by netfilter/iptables?
> 
> I've seen Fabrice's reply to a simimlar question some 3 years back:
> 
> https://lists.netfilter.org/pipermail/netfilter-devel/2002-March/006957.html

I think nothing has changed. The IPV4OPTSSTRIP mentioned in the mail
(which removes all options) is still available.

You can download the latest pom-ng (through www.netfilter.org), which
includes IPV4OPTSSTRIP. If you need more help regarding how to do stuff
in the net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c file (which is the one you
should modify), just ask :)

Good luck!

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCiOnVxyF48ZTvn+4RAj5zAJwKMG2mfElgS26RV2PRwwcIGuYBPwCfdJnv
RtaGxlBLe/NpODfN5b7zob4=
=9Bp4
-----END PGP SIGNATURE-----
