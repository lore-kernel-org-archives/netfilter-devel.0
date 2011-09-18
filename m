From: Gidon Miller <gmiller@vasonanetworks.com>
Subject: Re: conntrack (nf_conn) locking question
Date: Sun, 18 Sep 2011 10:04:21 +0300
Message-ID: <CAOAcFN_+tRmu9C0HCOcDzsH66gJoGWtqf+0e2yjCgfKPrr9nDA@mail.gmail.com>
References: <CAOAcFN-fXwCrtDu1snSAH-O5ud92bcBS4Dh8fR2m38pc=5hbTA@mail.gmail.com>
	<20110912084557.GA2080@1984>
	<CAOAcFN8DeYAk_sv+f=DrDykEqxd7jQ-yBKCBnqieHOr=RofY5g@mail.gmail.com>
	<20110912185354.GB4018@1984>
	<4E6E5985.9080306@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: =?ISO-8859-2?Q?Krzysztof_Ol=EAdzki?= <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:38454 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752096Ab1IRHEX convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Sep 2011 03:04:23 -0400
Received: by mail-ww0-f49.google.com with SMTP id 14so4285561wwp.18
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Sep 2011 00:04:21 -0700 (PDT)
In-Reply-To: <4E6E5985.9080306@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Krzysztof, Pablo,
thanks for your advice. it took me a while to get around to have a
look at the code but I finally reviewed it a bit.
correct me if I'm wrong but it seems that the list of ct extensions is
closed. the extension id is defined in enum nf_ct_ext_id and
registered in ct->ext whos offset member is NF_CT_EXT_NUM sized. looks
like the extensions cannot be expanded if I'm writing my code in a
module.
have I missed something?
thanks,
Gidon

2011/9/12 Krzysztof Ol=C4=99dzki <ole@ans.pl>
>
> On 2011-09-12 20:53, Pablo Neira Ayuso wrote:
>>
>> On Mon, Sep 12, 2011 at 01:11:50PM +0300, Gidon Miller wrote:
>>>
>>> Hi Pablo,
>>> thanks for your reply. can you please refer me to any documentation=
 on
>>> how to use ct extensions?
>>
>> Only code, see net/netfilter/nf_conntrack_acct.c for instance.
>
> Plus:
> =C2=A0include/net/netfilter/nf_conntrack_acct.h
> =C2=A0include/net/netfilter/nf_conntrack_extend.h
>
> BTW: if nothing changed, extensions can be only attached to a conntra=
ck before it is confirmed.
>
> Best regards,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Krzysztof Ol=C4=99dzki
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
