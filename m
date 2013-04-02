From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH iptables] nfnl_osf: use the right nfnetlink lib
Date: Tue, 02 Apr 2013 16:38:42 +0200
Message-ID: <515AED72.20300@6wind.com>
References: <1364566870-7320-1-git-send-email-nicolas.dichtel@6wind.com> <alpine.LNX.2.01.1303291620200.11529@nerf07.vanv.qr>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34311 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab3DBOiq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:38:46 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so520308wgh.25
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Apr 2013 07:38:45 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1303291620200.11529@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 29/03/2013 16:20, Jan Engelhardt a =E9crit :
> On Friday 2013-03-29 15:21, Nicolas Dichtel wrote:
>
>> If the user specify libnfnetlink_LIBS during the configure, we must =
use it.
>>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> ---
>> utils/Makefile.am | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/utils/Makefile.am b/utils/Makefile.am
>> index f1bbfc5..8a85396 100644
>> --- a/utils/Makefile.am
>> +++ b/utils/Makefile.am
>> @@ -7,4 +7,4 @@ AM_CPPFLAGS =3D ${regular_CPPFLAGS} -I${top_builddir=
}/include \
>> sbin_PROGRAMS =3D nfnl_osf
>> pkgdata_DATA =3D pf.os
>>
>> -nfnl_osf_LDADD =3D -lnfnetlink
>> +nfnl_osf_LDADD =3D ${libnfnetlink_LIBS} -lnfnetlink
>
> You really should remove -lnfnetlink :)
>
Not sure to understand your comment. ${libnfnetlink_LIBS} contains only=
=20
something like '-L/path/to/my/lib'.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
