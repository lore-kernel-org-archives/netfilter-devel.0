From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [iptables 1.3.0 / libiptc patch] sort chains by hooknum/names
Date: Tue, 19 Apr 2005 14:51:14 +0000
Message-ID: <42651AE2.9050402@outerspace.dyndns.org>
References: <20050304212114.130e2a7c@coruscant> <4228E962.8090005@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4228E962.8090005@trash.net>
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

Quoting Patrick McHardy on 2005-03-04 23:04 UTC:

>> OK, why two patches? The first one need some preconditions: *all*
>> buildin chains need to be "in order" and in front of *any* user chain
>> when parsing the kernel-list.
> 
> I assume with "in order", you mean it relies on the current numbering of
> the hooks:
> 
> This seems fine to me. I'm going to apply your first patch, thanks.

What he meant by "in order" was that when getting a list of chains from
the kernel, they would be returned like this:

PREROUTING
INPUT
FORWARD
OUTPUT
POSTROUTING
USER_CHAIN_B
USER_CHAIN_A
USER_CHAIN_C
...

I.e. builtin chains first, and then user chains in random order.

This is not the case however (at least with my 2.6.11 kernel), they seem
to come in a vaguely alphabetic order, with builtin chains being among
the user chains like:

USER_CHAIN_A
PREROUTING
INPUT
USER_CHAIN_B
FORWARD
OUTPUT
POSTROUTING
USER_CHAIN_C
...

Thus, his second patch is necessary (at least for me) in order to get
them in the order

<builtin chains sorted logically>
<user chains sorted alphabetically>

I tested switching to the second patch and the results were Good. :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCZRrhxyF48ZTvn+4RAiNKAJ0U96HA8lxIkWUvn8+vE4zEY7jHgACeJjaD
94uZ+M79//yeo0xQi3397SA=
=GShI
-----END PGP SIGNATURE-----
