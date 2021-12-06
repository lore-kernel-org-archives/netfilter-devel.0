Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFFFC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Dec 2021 19:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244872AbhLFUAL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 15:00:11 -0500
Received: from mail.netfilter.org ([217.70.188.207]:35640 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236478AbhLFT7w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 14:59:52 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 385E5605BC;
        Mon,  6 Dec 2021 20:54:01 +0100 (CET)
Date:   Mon, 6 Dec 2021 20:56:18 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eugene Crosser <crosser@average.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Suboptimal error handling in libnftables
Message-ID: <Ya5q4opTEInI9b28@salvia>
References: <45b08de8-13d7-b30d-ca47-b44deeeff83a@average.org>
 <YajP+n5qYEZOzmCD@salvia>
 <0b606613-076e-9b05-5283-46ade61292b2@average.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bMzaWB8Wx9otEB/c"
Content-Disposition: inline
In-Reply-To: <0b606613-076e-9b05-5283-46ade61292b2@average.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--bMzaWB8Wx9otEB/c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 06, 2021 at 05:58:25PM +0100, Eugene Crosser wrote:
> On 02/12/2021 14:54, Pablo Neira Ayuso wrote:
> > On Thu, Dec 02, 2021 at 02:16:12PM +0100, Eugene Crosser wrote:
> >> Hello,
> >>
> >> there is read-from-the-socket loop in src/iface.c line 90 (function
> >> iface_cache_update()), and it (and other places) call macro
> >> netlink_init_error() to report error. The function behind the macro is
> >> in src/netlink.c line 81, and it calls exit(NFT_EXIT_NONL) after writi=
ng
> >> a message to stderr.
> >>
> >> I see two problems with this:
> >>
> >> 1. All read-from-the-socket functions should be run in a loop, repeati=
ng
> >> if return code is -1 and errno is EINTR. I.e. EINTR should not be
> >> treated as an error, but as a condition that requires retry.
> >>
> >> 2. Library functions are not supposed to call exit() (or abort() for
> >> that matter). They are expected to return an error indication to the
> >> caller, who may have its own strategy for handling error conditions.
> >>
> >> Case in point, we have a daemon (in Python) that uses bindings to
> >> libnftables. It's a service responding to requests coming over a TCP
> >> connection, and it takes care to intercept any error situations and
> >> report them back. We discovered that under some conditions, it just
> >> closes the socket and goes away. This being a daemon, stderr was not
> >> immediately accessible; and even it it were, it is pretty hard to figu=
re
> >> where did the message "iface.c:98: Unable to initialize Netlink socket:
> >> Interrupted system call" come from and why!
> >=20
> > This missing EINTR handling for iface_cache_update() is a bug, would
> > you post a patch for this?
>=20
> It looks like there is more than just a missing retry when
> socket-receive returns EINTR. In the code in src/iface.c between lines
> 87 and 98, EINTR may come from one of two functions:
> mnl_socket_recvfrom() and mnl_cb_run(). If it is returned by
> mnl_socket_recvfrom(), the correct course of action is to blindly call
> that function again. But when it is returned by mnl_cb_run(), the
> meaning is different. mnl_cb_run() retruns -1 and sets errno=3DEINTR when
> netlink message contained NLM_F_DUMP_INTR. I assume (though I am not
> sure) that NLM_F_DUMP_INTR means that the data that is being transferred
> has changed while transfer was only partially complete, and the user is
> advised to restart _the whole dump process_ by sending a new NLM_F_DUMP
> request message. (Arguably, libmnl ought to report such situation with
> some other indication, not EINTR.) In any case, I believe that the
> aforementioned code should handle both of these two "need to retry" cases.
>=20
> I our tests it looks like we are hitting NLM_F_DUMP_INTR rather then
> interrupted socket recv(). I will report back after this is verified.

NLM_F_DUMP_INTR means that the existing netlink dump is stale (an
update happened while dumping the listing to userspace), so userspace
has to restart to get a consistent listing from the kernel.

Yes, in both cases, either signal interruped syscall or
NLM_F_DUMP_INTR, libnftables should retry.

--bMzaWB8Wx9otEB/c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEFEKqOX9jqZmzwkCc1GSBvS7ZkBkFAmGuauIACgkQ1GSBvS7Z
kBmltQ/+Mz0DcXCiksAyWBwgu/x6G//0eEA2Csb8TE+anvtVEom7mp1AiDBfGxPK
sskWLnLZrNhEJ42/qRo9IH9aKRfYPSRjr5oyOmhivto0ZFn4h7eEfSJjKq/Wvtfc
Ukn+cZk9IMNNowuo5PNxoru5Cs+QSy5lkskQDArbAUxZErZD+zNMuFirtAZbIYqI
X7UipOxT8b8Bw+wdP/tP2Oxm5whpiZlcHRPs/GNk8ToCSf93feiRap4BOzrLjLpa
W9HrvXxdq97b1SgsjcykwsSnfoTWQhpZ9+2++WjGZMQZqE+ONHMsHwXIwyCrIHao
7boH2uIKEzvDv7j+v8JL+vxVbYT0gJfHvqS7VqbiA1nTXve3qSaJsTi8Pb5Hh6Wd
MOnu3oNe18HI+XXCjwKd5meUVkLfu/5TNbVGdm9PgpS1qGTZYSwhOHoQdKnyBPNU
hXUKumMR4y+GSYIYof8X9dnR403oZYPFJ+C+UK+ReEM/SmZVd632HqQz0Cdi0Yv4
eeXByRsDujJleWQvVJtf3MSRrlZiFAlbj+Wct/WPSktEGIHYQZul1FgkILBFNkFs
gW3ItiJoNK+aqVZaMgKq6LQmexZamKNwykx3ODYwzn3ZUNu5sGLhj3lnttmvInGm
BJRu0+ShgNVFcnC5bB5r4di3Wce+03Pu5W/0pAsh5MC4QPn4zH0=
=gJE+
-----END PGP SIGNATURE-----

--bMzaWB8Wx9otEB/c--
