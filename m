From: Michael Schwendt <rh0209ms@arcor.de>
Subject: Re: small buglet in iptables-save with "-m mac"
Date: Mon, 16 Dec 2002 12:40:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021216124016.079b870f.rh0209ms@arcor.de>
References: <Pine.LNX.4.44.0212101518580.1838-100000@pc40.e18.physik.tu-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
In-Reply-To: <Pine.LNX.4.44.0212101518580.1838-100000@pc40.e18.physik.tu-muenchen.de>
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

On Tue, 10 Dec 2002 15:26:30 +0100 (CET), Roland Kuhn wrote:

> Please Cc: me as I'm not on the list.
> 
> This small buglet is biting me since quite a while, so I got the
> 1.2.7a source to see if it is fixed, and it isn't: if you try
> iptables-save on a rule with inverted MAC matching (e.g. "-m mac
> --mac-source ! xx:xx:xx:xx:xx:xx") you'll end up with "-m mac --mac
> !xx:xx:xx:xx:xx:xx", which doesn't work because of the missing space
> between the ! and the MAC. The patch below should fix it (tested on
> RH7.2, kernel 2.4.20).

This has been fixed several weeks ago in CVS.

Sometime later I've submitted a patch which cleans up libipt_mac.c
so the space is only printed for iptables-save and not for iptables
- -L (other userspace extension do it similarly with readability in
mind).

Michael

- -- 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)

iD8DBQE9/bug0iMVcrivHFQRArKwAJ4jFlBLTGhhFzcPR4Z7aiEMtaOhIACfQt7U
rFm3uUrJdvmKrGF1l4nJSt0=
=GSMW
-----END PGP SIGNATURE-----
