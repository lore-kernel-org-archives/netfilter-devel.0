From: Thomas Heinz <creatix@hipac.org>
Subject: Re: iptables as a state machine
Date: Sat, 02 Oct 2004 23:52:00 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415F2300.2020609@hipac.org>
References: <20040930193955.6fa24afc.davem@davemloft.net>
	<876ef97a0410021401429a429b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigC8B866E3E8281E43AF562A24"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a0410021401429a429b@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC8B866E3E8281E43AF562A24
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Tobias

You wrote:
> What about using a n-ary PATRICIA trie to solve this problem? That
> would yield O(1)-time matching of rules and the data pointer for each
> node in the tree could be the list of targets that apply to that
> particular IP/subnet? Not sure how ranges would work yet, though if
> they didn't fit into a CIDR block...

Maybe you want to have a look at the following paper.
http://tiny-tera.stanford.edu/~nickm/papers/classification_tutorial_01.pdf

It provides a very good overview of a wide range of different
approaches towards packet classification.

There are two basic trie-based approaches presented in the paper.
1) hierarchical tries
    lookup time:        O(w^d)
    storage complexity: O(n * d * w)

2) set-pruning tries
    lookup time:        O(d * w)
    storage complexity: O(n^d * d * w)

n: number of rules
d: number of dimensions (such as source ip, dest. ip, protocol)
w: bit width of largest header field

As you can see from the performance complexity both approaches
are not desirable for d > 1.


BTW, every range in [0, 2^w - 1] can be expressed by at most
2*(w-1) prefixes. Hence, if you have a single rule with d range
matches, you need at most (2*(w-1))^d rules with prefix matches
to express the _single_ range rule.

Sounds not very promising, does it? ;-)


Regards,

Thomas

--------------enigC8B866E3E8281E43AF562A24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Debian - http://enigmail.mozdev.org

iD8DBQFBXyMH8oNQPJ8CvngRAlD/AJ0SNPNhx91j07L4OdhDFMwB61TS4QCfR9nW
qZAH1wYR+RZ2qiElq/pAUdg=
=TC0M
-----END PGP SIGNATURE-----

--------------enigC8B866E3E8281E43AF562A24--
