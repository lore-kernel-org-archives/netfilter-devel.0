From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] REJECT for 2.6.9+
Date: Mon, 21 Mar 2005 22:51:36 +0200
Message-ID: <423F33D8.1090706@outerspace.dyndns.org>
References: <423BF227.8030502@outerspace.dyndns.org> <423DA194.40100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <423DA194.40100@trash.net>
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

Patrick McHardy wrote:

|> The empty patch file is there so that the original patch won't be
|> attempted.
|
| Why add a new branch instead of simply restoring that file?

Maybe I have not understood the pom-ng functionality correctly/fully. I
thought that plain files in the tree must not exist already and so I thought
I needed to keep the old branch for the <=2.6.8 kernels that still have the
file that was deleted in 2.6.9..

| Even better, I think I'm simply going to submit the IPv6
| REJECT target of nobody objects.

No objections here :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCPzPWxyF48ZTvn+4RAo2ZAJ9RUpp6LzOk2J6vT38QCfulSLODCQCfeu83
m2JTEwyTHKe4iZwPrfkeaiI=
=3VtI
-----END PGP SIGNATURE-----
