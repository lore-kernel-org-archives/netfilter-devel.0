From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] new 'tcpack' match
Date: Mon, 11 Apr 2005 12:11:59 +0000
Message-ID: <425A698F.6080703@outerspace.dyndns.org>
References: <42464598.9040707@outerspace.dyndns.org>
	<425032D5.2010302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <425032D5.2010302@trash.net>
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

Quoting Patrick McHardy on 2005-04-03 18:15 UTC:

|> ~  iptables -A INPUT -p tcp -m tcpack --tcpack -j CLASSIFY 1:10
|
| I can see that it would be useful, given all the half-working ACK
| matching rules for shaping floating around, but we already a tcp
| match, so it should be done in there, and, if possible, kept a little
| bit more generic. Perhaps a data-len match option.

Should I make a new revision of the tcp match in order not to break
binary compatibility?

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCWmmNxyF48ZTvn+4RAps7AKC2Bii7ZaWYecGwYgPQ8xJxmgLWqgCfRucE
PajDstxPkhhzN3q17+hXzfA=
=Gsrz
-----END PGP SIGNATURE-----
