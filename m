From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] ip6tables: check for valid init prior to calling
Date: Mon, 04 Jul 2005 04:54:58 +0000
Message-ID: <42C8C122.40007@outerspace.dyndns.org>
References: <20050703170345.GA20892@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050703170345.GA20892@linuxace.com>
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

Quoting Phil Oester on 2005-07-03 17:03 UTC:
> Unlike iptables, ip6tables does not check that match|target->init
> is !NULL prior to calling, leading to problems in those extensions
> which don't define init, like owner:
> 
> # ip6tables -m owner
> Segmentation fault
> 
> The below patch copies iptables checks.
> 
> Phil

Hmm, I already fixed this three months ago :)

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/iptables/ip6tables.c?rev=3818&r1=3814&r2=3818

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCyMEgxyF48ZTvn+4RAisrAJ9NR/P89HiNEAiJQsKfcyqPkLjEFACgpSAA
qq91OSpPDFt/1CM/7EeKluI=
=ubNX
-----END PGP SIGNATURE-----
