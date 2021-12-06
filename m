Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4018BC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Dec 2021 17:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbhLFRIq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 12:08:46 -0500
Received: from dehost.average.org ([88.198.2.197]:43850 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245015AbhLFRCF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 12:02:05 -0500
Received: from [IPV6:2a02:8106:1:6800:9312:aaab:eddf:2053] (unknown [IPv6:2a02:8106:1:6800:9312:aaab:eddf:2053])
        by dehost.average.org (Postfix) with ESMTPSA id 75A953949892;
        Mon,  6 Dec 2021 17:58:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1638809911; bh=JQwoRVzGlfqK36Vycz44PfNohjhykwPUsQBKAtgS3So=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=Z+5Z9FqIDmydwYhIDrMSRFbvkrqxFlDf8KvPtjtH310RabNvVmJkRkpjw5bjWajLU
         p74F8J+8lCkxUTqnTLwjanv8JhyDncpVFgKnENLs7giT4DNZT1f9F3pgVqMPWXvOAz
         0IiuWEzKTYUyBQizpqP8zH03dCDm6bz++djdPkDU=
Message-ID: <0b606613-076e-9b05-5283-46ade61292b2@average.org>
Date:   Mon, 6 Dec 2021 17:58:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Content-Language: en-GB
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <45b08de8-13d7-b30d-ca47-b44deeeff83a@average.org>
 <YajP+n5qYEZOzmCD@salvia>
From:   Eugene Crosser <crosser@average.org>
Subject: Re: Suboptimal error handling in libnftables
In-Reply-To: <YajP+n5qYEZOzmCD@salvia>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------J1o8uYu85KLcAYvBJz3G3NCA"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------J1o8uYu85KLcAYvBJz3G3NCA
Content-Type: multipart/mixed; boundary="------------XKxllJ0lNGvNbuLnvIQUA0UQ";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <0b606613-076e-9b05-5283-46ade61292b2@average.org>
Subject: Re: Suboptimal error handling in libnftables
References: <45b08de8-13d7-b30d-ca47-b44deeeff83a@average.org>
 <YajP+n5qYEZOzmCD@salvia>
In-Reply-To: <YajP+n5qYEZOzmCD@salvia>

--------------XKxllJ0lNGvNbuLnvIQUA0UQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/12/2021 14:54, Pablo Neira Ayuso wrote:
> On Thu, Dec 02, 2021 at 02:16:12PM +0100, Eugene Crosser wrote:
>> Hello,
>>
>> there is read-from-the-socket loop in src/iface.c line 90 (function
>> iface_cache_update()), and it (and other places) call macro
>> netlink_init_error() to report error. The function behind the macro is=

>> in src/netlink.c line 81, and it calls exit(NFT_EXIT_NONL) after writi=
ng
>> a message to stderr.
>>
>> I see two problems with this:
>>
>> 1. All read-from-the-socket functions should be run in a loop, repeati=
ng
>> if return code is -1 and errno is EINTR. I.e. EINTR should not be
>> treated as an error, but as a condition that requires retry.
>>
>> 2. Library functions are not supposed to call exit() (or abort() for
>> that matter). They are expected to return an error indication to the
>> caller, who may have its own strategy for handling error conditions.
>>
>> Case in point, we have a daemon (in Python) that uses bindings to
>> libnftables. It's a service responding to requests coming over a TCP
>> connection, and it takes care to intercept any error situations and
>> report them back. We discovered that under some conditions, it just
>> closes the socket and goes away. This being a daemon, stderr was not
>> immediately accessible; and even it it were, it is pretty hard to figu=
re
>> where did the message "iface.c:98: Unable to initialize Netlink socket=
:
>> Interrupted system call" come from and why!
>=20
> This missing EINTR handling for iface_cache_update() is a bug, would
> you post a patch for this?

It looks like there is more than just a missing retry when
socket-receive returns EINTR. In the code in src/iface.c between lines
87 and 98, EINTR may come from one of two functions:
mnl_socket_recvfrom() and mnl_cb_run(). If it is returned by
mnl_socket_recvfrom(), the correct course of action is to blindly call
that function again. But when it is returned by mnl_cb_run(), the
meaning is different. mnl_cb_run() retruns -1 and sets errno=3DEINTR when=

netlink message contained NLM_F_DUMP_INTR. I assume (though I am not
sure) that NLM_F_DUMP_INTR means that the data that is being transferred
has changed while transfer was only partially complete, and the user is
advised to restart _the whole dump process_ by sending a new NLM_F_DUMP
request message. (Arguably, libmnl ought to report such situation with
some other indication, not EINTR.) In any case, I believe that the
aforementioned code should handle both of these two "need to retry" cases=
=2E

I our tests it looks like we are hitting NLM_F_DUMP_INTR rather then
interrupted socket recv(). I will report back after this is verified.

Best regards,

Eugene

--------------XKxllJ0lNGvNbuLnvIQUA0UQ--

--------------J1o8uYu85KLcAYvBJz3G3NCA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmGuQTEACgkQfKQHw5Gd
RYyYoQf9HHe9XeFWobBNw5p05l35NLU6wvYsW7NtBaFqUBSOFJVUn4fIhX1q3tv1
dHdqXgz26+r5FRzzZPTAzz5z2gioob71Mee4M9N2uI789YlhmEwQG7zT9ShtrSbm
PBKkL1ZfQScU9opXo6CIMCwSe95FOajDXgTpxBWmL7TkkyaRhFY7BdnPkr5gYLGg
yrdPALtpsckZ4gzFplCnI0eAkg8oAXV6/iwWsF4hIQW5eUJBe6Tnd6A/M6HQgCp5
s7uUTNtsrm8IqpX6+XJ4WJUBEAvhun/j9daqlqhaxpUjVo0UOwKqTGDY+4xjKKwz
xv6NAJbwdTgHda0MhbCj5Ey4BbW2ZA==
=AhuO
-----END PGP SIGNATURE-----

--------------J1o8uYu85KLcAYvBJz3G3NCA--
