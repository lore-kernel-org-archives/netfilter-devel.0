Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000D8C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 13:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346720AbhLBN0n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 08:26:43 -0500
Received: from dehost.average.org ([88.198.2.197]:36774 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346690AbhLBN0m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 08:26:42 -0500
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Dec 2021 08:26:42 EST
Received: from [IPV6:2a02:8106:1:6800:4d98:14f5:53ee:1b84] (unknown [IPv6:2a02:8106:1:6800:4d98:14f5:53ee:1b84])
        by dehost.average.org (Postfix) with ESMTPSA id B04393946213
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Dec 2021 14:16:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1638450980; bh=7agHy+5QSLGmZI9AbSE8Eaxs4LWjN7enRqpbf6J8K9E=;
        h=Date:To:From:Subject:From;
        b=sQ1wAUFdw4NHaLfyFKgccEyhw6ejibsTslfxk0Akf3+yLCwfHgkfnqpFVJ3Id5gbo
         bAlnQjaPoJN/k8Ym70b0IeTjGFQ5TNNAH851HKGkYeao2kUTzMBZXSLKxOzITmQ5MN
         jA4OJi2w9HEaf79IEvFgeh2Z+1VWxAmsXcTSb5wM=
Message-ID: <45b08de8-13d7-b30d-ca47-b44deeeff83a@average.org>
Date:   Thu, 2 Dec 2021 14:16:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Content-Language: en-GB
From:   Eugene Crosser <crosser@average.org>
Subject: Suboptimal error handling in libnftables
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------RWOGwUnoNyVsR900CGy4nFaN"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------RWOGwUnoNyVsR900CGy4nFaN
Content-Type: multipart/mixed; boundary="------------R312vXuVmU0SIhY3cqYA81Ou";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <45b08de8-13d7-b30d-ca47-b44deeeff83a@average.org>
Subject: Suboptimal error handling in libnftables

--------------R312vXuVmU0SIhY3cqYA81Ou
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

there is read-from-the-socket loop in src/iface.c line 90 (function
iface_cache_update()), and it (and other places) call macro
netlink_init_error() to report error. The function behind the macro is
in src/netlink.c line 81, and it calls exit(NFT_EXIT_NONL) after writing
a message to stderr.

I see two problems with this:

1. All read-from-the-socket functions should be run in a loop, repeating
if return code is -1 and errno is EINTR. I.e. EINTR should not be
treated as an error, but as a condition that requires retry.

2. Library functions are not supposed to call exit() (or abort() for
that matter). They are expected to return an error indication to the
caller, who may have its own strategy for handling error conditions.

Case in point, we have a daemon (in Python) that uses bindings to
libnftables. It's a service responding to requests coming over a TCP
connection, and it takes care to intercept any error situations and
report them back. We discovered that under some conditions, it just
closes the socket and goes away. This being a daemon, stderr was not
immediately accessible; and even it it were, it is pretty hard to figure
where did the message "iface.c:98: Unable to initialize Netlink socket:
Interrupted system call" come from and why!

There is another function that calls exit(), __netlink_abi_error(). I
believe that even in such a harsh situation, exit() is not the right way
to handle it.

Thank you,

Eugene

--------------R312vXuVmU0SIhY3cqYA81Ou--

--------------RWOGwUnoNyVsR900CGy4nFaN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmGoxx0ACgkQfKQHw5Gd
RYzHlAf+P2jaBnzy7DC/2Shl/VPR7Yd3C2pWXpXDddc0mlnoYWCoSZdPwiYSEwsj
TMqoE2BVPCwH4tTDBKZiTK/1/V1tlG+I76zUgo9IAFQoLdPj1D2W9G0i5BXmhL20
GxwCqWiStr42OeznQAktaVGqzQ2NT67rpTSuTQCquPj5BDicrRByhgWT0HlwPIOQ
o4m6ajKk03X9gKfmMXAU8/7/qtUsZNoWv+uUX6U9eAokRn87ZR7QEdb/67fqNb/6
lErPPE5cH8Mlm79Y30A1hYz44FdolqRvHVOee+CGhSu4UAXN+KBLiJyR6SUaiACo
GE9FqfvZFJUNxLLAPqgpPtatWr4MwA==
=2sdS
-----END PGP SIGNATURE-----

--------------RWOGwUnoNyVsR900CGy4nFaN--
