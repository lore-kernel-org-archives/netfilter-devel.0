From: Harald Welte <laforge@netfilter.org>
Subject: Re: [Resend] OSF update: netlink logging
Date: Sat, 31 Jan 2004 17:31:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040131163155.GL11753@sunbeam.de.gnumonks.org>
References: <20040131154725.5a6a82be.johnpol@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Content-Disposition: inline
In-Reply-To: <20040131154725.5a6a82be.johnpol@2ka.mipt.ru>
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


> -#define IPTABLES_VERSION	"1.2.6a" /* It looks like FIXME */
> +#define IPTABLES_VERSION	"1.2.7a" /* Permanent FIXME */

Why do you define IPTABLES_VERSION ??

This is defined by the makefile, and it is not a good idea to re-define
it, since then your compiled extension won't work [since current version
is higher than 1.2.7a].

Apart from that, the patch is fine to me.
- -- 
- - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAG9h7XaXGVTD0i/8RApgtAKCDXEGCAVoT42hBkyaZRUAtmVKYPgCfULm1
3zA/UYiVRXYDH3EY0EDWMFk=
=Q6g+
-----END PGP SIGNATURE-----
