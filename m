From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables PATCH v4 1/5] netfilter: nft_nat: include a flag attribute
Date: Tue, 9 Sep 2014 12:14:25 +0200
Message-ID: <CAOkSjBj3e+MFFhtvMOD7cSWHekk_E7s-tJa0SJ80ARWN7EcnGA@mail.gmail.com>
References: <20140904120518.5971.77791.stgit@nfdev.cica.es> <20140909095003.GA9128@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33075 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaIIKOq convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:14:46 -0400
Received: by mail-la0-f52.google.com with SMTP id b8so7437482lan.25
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Sep 2014 03:14:45 -0700 (PDT)
In-Reply-To: <20140909095003.GA9128@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 September 2014 11:50, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> On Thu, Sep 04, 2014 at 02:06:14PM +0200, Arturo Borrero Gonzalez wro=
te:
>> Both SNAT and DNAT (and the upcoming masquerade) can have additional
>> configuration parameters, such as port randomization or NAT addressi=
ng
>> persistence.
>> We can cover these scenarios by simply adding a flag attribute for
>> userspace to fill when needed.
>>
>> The flags to use are defined in include/uapi/linux/netfilter/nf_nat.=
h,
>>  NF_NAT_RANGE_MAP_IPS
>>  NF_NAT_RANGE_PROTO_SPECIFIED
>>  NF_NAT_RANGE_PROTO_RANDOM
>>  NF_NAT_RANGE_PERSISTENT
>>  NF_NAT_RANGE_PROTO_RANDOM_FULLY
>>  NF_NAT_RANGE_PROTO_RANDOM_ALL
>>
>> The caller must take care of not messing up with the flags, as they =
are
>> added unconditionally to the final resulting nf_nat_range.
>
> Not sure this comment is relevant. Of course, userspace should select
> the flags accordingly :-). Let me know if the intention was other tha=
n
> insisting on the fact that the flags alter the way the NAT is done.
>

Yes, I meant that no additional check is done to know if the flags
combination makes sense.

>
> I'm going to make the following comestic change:
>
> #define NF_NAT_RANGE_MASK                                      \
>      (NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |    \
>       NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |    \
>       NF_NAT_RANGE_PROTO_RANDOM_FULLY)
>
> Next time, place the '|' '&' and so on after at the end of the line.
>

Ok, thanks.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
