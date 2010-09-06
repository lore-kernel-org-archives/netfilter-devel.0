From: rui.sousa@mindspeed.com
Subject: Re: TCP proto info
Date: Mon, 6 Sep 2010 18:10:58 +0200
Message-ID: <OF24005F20.C66A3847-ONC1257796.0058E53E-C1257796.0058E54B@mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail137.messagelabs.com ([216.82.249.19]:7500 "HELO
	mail137.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753076Ab0IFQMF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Sep 2010 12:12:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


-----Pablo Neira Ayuso <pablo@netfilter.org> wrote: -----

>On=A002/09/10=A011:21,=A0rui.sousa@mindspeed.com=A0wrote:
>> Pablo Neira Ayuso  wrote on 09/02/2010
>10:57:39=A0AM:
>>
>>>=A0Hi=A0Rui,
>>
>>=A0Hi=A0Pablo,
>>
>>>=A0On=A001/09/10=A015:45,=A0rui.sousa@mindspeed.com=A0wrote:
>>>>=A0Hi,
>>>>
>>>> I have an application using libnetfilter_conntrack-0.100 that
>started
>>>>=A0reporting=A0errors=A0after=A0the=A0commit:
>>>>
>>>>=A01c450e1595afdc8d1bfabb4f640c9251808426eb.
>>>
>>>=A0Looking=A0at=A0the=A0source=A0code,=A0this=A0seems=A0to=A0be=A0al=
ready=A0fixed=A0in
>>>=A0libnetfilter_conntrack=A00.0.102,=A0please=A0upgrade=A0to=A0lates=
t.
>>
>> Hmm... looking at the git tree I see that the __build_conntrack()
>code=A0is
>> still calling __build_protoinfo() unconditionally and inside the
>function
>>=A0we=A0always=A0do:
>>
>>=A0nest=A0=3D=A0nfnl_nest(&req->nlh,=A0size,=A0CTA_PROTOINFO);
>>=A0nest_proto=A0=3D=A0nfnl_nest(&req->nlh,=A0size,=A0CTA_PROTOINFO_TC=
P);
>>=A0...
>>=A0nfnl_nest_end(&req->nlh,=A0nest_proto);
>>=A0nfnl_nest_end(&req->nlh,=A0nest);
>>
>> even if none of the ATTR_TCP_xxx bits are set. This is what causes
>the
>>=A0kernel=A0to=A0return=A0-EINVAL
>>=A0and=A0ignore=A0the=A0conntrack=A0update.=A0Or=A0am=A0I=A0missing=A0=
something?
>
>I=A0see,=A0I=A0guess=A0that=A0you're=A0using=A0a=A0Linux=A0kernel=A0<=3D=
=A02.6.25

Correct. It's an ARM based embedded linux system still running 2.6.21.

>=A0since=A0I
>couldn't reproduce it with recent kernels. Please, could you give a
>try
>to=A0the=A0following=A0patch?

This patch fixed my problem.

Thanks,
Rui

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
