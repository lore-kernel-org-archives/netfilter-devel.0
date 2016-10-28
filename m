From: James Feeney <james@nurealm.net>
Subject: Re: reject statement - "crazy" parse error?
Date: Fri, 28 Oct 2016 10:33:46 -0600
Message-ID: <129a58d6-4e88-3f3e-4b33-b719019947e4@nurealm.net>
References: <aea0c58c-dd68-bffb-859c-81f77ebe8dfd@nurealm.net>
 <CAOkSjBjd6CwTcMv_G1p1KmWnQukHUn6f4oCoaeZHmXEyJDiW4g@mail.gmail.com>
 <5a8da546-8694-40b8-b514-1f80bff71a44@nurealm.net>
 <CAOkSjBgd0UJzg3Xp-ub4twebDmHdVJ25e5GkWEw5h2XUmQxKxQ@mail.gmail.com>
Reply-To: james@nurealm.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:60145 "EHLO
        resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S937846AbcJ1Qds (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 12:33:48 -0400
In-Reply-To: <CAOkSjBgd0UJzg3Xp-ub4twebDmHdVJ25e5GkWEw5h2XUmQxKxQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks Arturo

> I'm using Debian, of course :-)

I see that Debian Sid has kernel 4.7.8-1, where Arch is at kernel 4.8.4-1.  So I
tried loading the test.nft on a machine running the Arch lts kernel, 4.4.27-1.
It loaded without any problem.

At this point, I will infer that nftables-0.6 or libnftnl 1.0.6 is not playing
well with linux 4.8, where there seems to be a problem on both 4.8.1 and 4.8.4,
but not on 4.4.27 or 4.7.8.

Is there any way you could try loading test.nft with a recent 4.8 kernel?

> You could check the config of your kernel. That error message seems to
> come from the kernel.

That makes sense, since this issue seems to track with kernel version.

> Please, check NF_TABLES* and NFT_* symbols (also NF_*)

No problem there.  Those modules are all enabled.

> Yes, the error reporting in the 'nft -f' situation is something to improve,
> specially with kernel reported errors.

Assuming this issue is something to do with linux kernel interaction, any
suggestion about where to look next?  Has the kernel changed the nft_reject
sysfs interface?
