From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] new 'tcpack' match
Date: Mon, 28 Mar 2005 17:06:48 +0300
Message-ID: <42480F78.9050103@outerspace.dyndns.org>
References: <42464598.9040707@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42464598.9040707@outerspace.dyndns.org>
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

Jonas Berlin wrote:
| Matches TCP packets that has no payload, i.e. contains only ACKs.
|
|   iptables -A INPUT -p tcp -m tcpack --tcpack -j CLASSIFY 1:10
|
| Or match non-ack packets:
|
|   iptables -A INPUT -p tcp -m tcpack ! --tcpack -j CLASSIFY 1:12

Actually after thinking about it, the "ack" reference is quite bogus.. it
matches packets that simply has no data bytes in them.. regardless of the
possible flags SYN ACK FIN RST.

I think I'll rename it and rewrite the documentation a bit so it's clearer
and also add some more usage examples and ideas.

So if possible, please hold merging this patch into pom-ng :)

Sorry for my over-enthusiasm, this was my first self-written pom-ng module I
publicly announced :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCSA92xyF48ZTvn+4RAj45AJ9wjU6CsSq88PB4NxKI54h0fKzIHgCggZ7p
I5Uha/RhbnLdYi7Eu2Fk4ZU=
=WwNx
-----END PGP SIGNATURE-----
