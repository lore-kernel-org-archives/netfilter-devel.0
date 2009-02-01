From: Pete Whiting <pete@whitings.org>
Subject: Re: trying to test libnetfilter_queue on openwrt kamikaze_RC2 -
	failing with "connection refused"
Date: Sun, 1 Feb 2009 05:38:39 -0700
Message-ID: <3ba156dd0902010438p63a30d8bs961ccf9292f53db1@mail.gmail.com>
References: <3ba156dd0901312047s3f54f6a4t3b43a36025103dfe@mail.gmail.com>
	 <498587A9.9040003@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:53202 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZBAMim convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Feb 2009 07:38:42 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1097382rvb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Feb 2009 04:38:39 -0800 (PST)
In-Reply-To: <498587A9.9040003@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

you were correct - I had the wrong kernel modules loaded. Once built
and installed the error went away. Patch to ignore return code was not
needed.

sorry for the noise.

kernel version 2.6.25.17

2009/2/1 Eric Leblond <eric@inl.fr>:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi,
>
> Pete Whiting a =E9crit :
>> I am trying to build/test libnetfilter_queue for a user-space app
>> running on openwrt. Compile failed in the utils subdirectory until I
>> modified Makefile.in to include libnfnetlink.so:
>>
>>
>> I verified that xt_NFQUEUE is installed:
>> root@Kamikaze_RC2:~# lsmod | grep QUEUE
>> xt_NFQUEUE               672  0
>> x_tables                8976  16
>> xt_NFQUEUE,ipt_ULOG,xt_string,xt_layer7,ipt_ipp2p,ipt_MASQUERADE,ipt=
able_nat,xt_state,ipt_REJECT,xt_TCPMSS,ipt_LOG,xt_multiport,xt_mac,xt_l=
imit,ip_tables,xt_tcpudp
>
> It seems the nfnetlink_queue module is missing. It should not be on t=
hat
> list because of your grep but it could be a good explanation (your
> strace seems to confirm this).
>
> If this is not the case, please apply the joined patch and let us kno=
w.
>
> By the way, please tell us your kernel version. It seems this problem=
 is
> specific to some version.
>
> BR,
> - --
> Eric Leblond <eric@inl.fr>
> INL: http://www.inl.fr/
> NuFW: http://www.nufw.org/
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
>
> iD8DBQFJhYecnxA7CdMWjzIRAqX7AJsEM3sXmWRZG64PrQQog+FYuxnQQQCfVsfC
> IQeVwqHXrG1GSnxkEli3o+s=3D
> =3DPk8w
> -----END PGP SIGNATURE-----
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
