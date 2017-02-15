From: Anatole Denis <natolumin@gmail.com>
Subject: Re: [Question] Is there some documentation for nftables development
Date: Wed, 15 Feb 2017 19:37:54 +0100
Message-ID: <1487183874.795.1@smtp.gmail.com>
References: <f23dc1f5-6965-cdf0-cd7d-04d2c200e4a6@students.fh-hagenberg.at>
        <d73038eb-3609-d4a8-85af-30c81174eb3d@mindchasers.com>
        <fb394aca-8979-332d-c1f0-cbffef52f581@students.fh-hagenberg.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@vger.kernel.org
To: Fabian Franz <s1410239008@students.fh-hagenberg.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36521 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752088AbdBOSh6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 13:37:58 -0500
Received: by mail-wr0-f173.google.com with SMTP id k90so196656803wrc.3
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 10:37:57 -0800 (PST)
In-Reply-To: <fb394aca-8979-332d-c1f0-cbffef52f581@students.fh-hagenberg.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On mer., f=C3=A9vr. 15, 2017 at 6:21 , Fabian Franz=20
<s1410239008@students.fh-hagenberg.at> wrote:
> Dear Mr. Cochran,
>=20
>=20
> even if your document looks good, I am looking for some documentation
> related to nftables - iptables is NO option because I want to=20
> implement
> a kernel module for nftables doing that.
>=20
> The problem is, that there is a wiki how to use it, but there is no
> information how to extend it:
>=20
> https://wiki.nftables.org/wiki-nftables/index.php/Main_Page

 From your description, "query a user space application, if the packet=20
is allowed", seems to be exactly nfqueue, which is already developed=20
and in mainline kernel, and supported by nftables. The wiki you link to=20
has a page on it:=20
https://wiki.nftables.org/wiki-nftables/index.php/Queueing_to_userspace.

As you can also see in the link, there is a userspace library for it,=20
libnetfilter_queue, as well.

The question is maybe, do you want to solve a problem (in which case I=20
believe nfqueue could be a solution), or write a kernel module (in=20
which case, sorry to be useless, I don't know about any documentation=20
on the kernel side of netfilter) ?

--
Anatole
=

