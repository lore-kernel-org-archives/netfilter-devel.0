From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: is this make sense: iptables -A PREROUTING -t nat -j SNAT --to
 0.0.0.0
Date: Sat, 26 Mar 2005 14:03:12 +0200
Message-ID: <42454F80.4090603@outerspace.dyndns.org>
References: <42403008.9070006@cardvn.net> <42444A4A.5090308@cardvn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Nguyen Dinh Nam <64vn@cardvn.net>
In-Reply-To: <42444A4A.5090308@cardvn.net>
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

Nguyen Dinh Nam wrote:
| Senior netfilter developers, please tell me if SNAT in PREROUTING is
| worth the effort to implement. At least, tell me if it is fit with the
| linux networking architecture?

I'm no senior, but could the SAME target in patch-o-matic-ng maybe help you out?

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCRU9+xyF48ZTvn+4RAjCgAKDFc0QJvIsOxAxGXqJd4wCmtY3iXQCgnAAI
M6Jxpx7DfqrBeRsrkF9SRXE=
=xcEV
-----END PGP SIGNATURE-----
