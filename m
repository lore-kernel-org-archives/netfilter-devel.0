From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Netfilter socket hooks
Date: Tue, 10 May 2005 20:37:10 +0000
Message-ID: <42811B76.1060105@outerspace.dyndns.org>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>	<426F64C8.1070601@trash.net>	<426FA44A.2010008@evtek.fi>	<426FA73E.3090605@trash.net>	<20050427114926.45a91b5e.davem@davemloft.net>	<426FE9DD.80201@trash.net>
	<4280DA51.8090201@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4280DA51.8090201@trash.net>
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

Quoting Patrick McHardy on 2005-05-10 15:59 UTC:
> Here is a first shot at socket hooks.

Great :)

> Comments?

On what level will this be.. would one be able to filter what userspace
programs do in addition to filtering what internet clients are allowed
to do?

I.e. would one be able to filter userspace socket calls like accept(),
connect(), bind(), recv(), send(), and maybe even setsockopt() etc?

Isn't it almost as important to protect the internet from malicious
users as to protect users from the internet ?-) SELinux could maybe add
features to base web access policies on SELinux's normal mechanism that
currently grants/restricts access.

Example: If wget tryes to access the internet as a child of process A
(which has been granted all web access), then wget would be allowed to
do whatever it wants. Otherwise, wget's connect() call (when connecting
to a http server) would fail with some Exxxx errno code..

It would also be nice if this skfilter provided something similar to the
 QUEUE target to allow users yet another level to hook in.. This could
possibly allow quite clean implementations of interactive firewall clients..

//

I would also be interested if you could give some idea of what kind of
commands you were thinking of that would be used to control skfilter..

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCgRt0xyF48ZTvn+4RAr3iAJ9Hl3TNHKn6wlBQNXUCgBtK7LY3tQCfWsM3
6TfPFQaGf02SD9XZVHOmmd0=
=n1tg
-----END PGP SIGNATURE-----
