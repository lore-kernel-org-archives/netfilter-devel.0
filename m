From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 4/4] netfilter: sysctl support of logger choice.
Date: Thu, 19 Feb 2009 21:59:03 +0100
Message-ID: <499DC817.7010305@inl.fr>
References: <49980BA7.2040108@inl.fr> <1234701437-2754-4-git-send-email-eric@inl.fr> <499C2F92.3080105@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:34222 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZBSU7J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:59:09 -0500
In-Reply-To: <499C2F92.3080105@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Patrick McHardy a =E9crit :
> Eric Leblond wrote:
>> +static int nf_log_proc_dostring(ctl_table *table, int write, struct
>> file *filp,
>
>> +    for (i =3D NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
>> +        char *pr_name =3D kmalloc(3, GFP_KERNEL);
>> +        /* FIXME free at deinit but there is currently no deinit */
>> +        snprintf(pr_name, 3, "%d", i);
>> +        nf_log_sysctl_table[i].ctl_name    =3D i;
>=20
> This ctl_name use seems rather abusive. The names are used
> as numeric identifiers, we can't just stuff index values in
> there :)

Your remark is not clear for me. I store here a integer which is the
protocol number. I see it as a real numeric identifier.

Which change are you suggesting ?

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
