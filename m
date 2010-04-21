From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] nfnetlink_queue: use hash table to speed up entry lookup
Date: Wed, 21 Apr 2010 08:04:33 +0800
Message-ID: <i2t412e6f7f1004201704ubf9a7018oaf385e0831382a12@mail.gmail.com>
References: <1271773896-28246-1-git-send-email-xiaosuo@gmail.com>
	<4BCDC0F4.5070904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44848 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab0DUAE4 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:04:56 -0400
Received: by gwj19 with SMTP id 19so1098323gwj.19
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2010 17:04:56 -0700 (PDT)
In-Reply-To: <4BCDC0F4.5070904@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 20, 2010 at 10:57 PM, Patrick McHardy <kaber@trash.net> wro=
te:
> Changli Gao wrote:
>> use hash table to speed up entry lookup
>>
>> A hash table is used to speed up entry lookup when the verdicts aren=
't received
>> in order. The size of hash table can be specified by NFQA_CFG_QUEUE_=
HTBLSIZ.
>> Its default value is 1. Reciprocal division is used to lower the cos=
t of
>> division, and the entry IDs are generated carefully to get fair entr=
y
>> distribution in the buckets of the hash table.
>
>> +static u32 __get_uniq_id(struct nfqnl_instance *queue)
>> +{
>> + =C2=A0 =C2=A0 u32 i;
>> +
>> + =C2=A0 =C2=A0 for (i =3D 0; i < INT_MAX; i++) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue->id_sequence +=3D =
queue->id_increment;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (queue->id_sequence >=
=3D queue->id_limit) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (++queue->id_offset >=3D queue->id_increment)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue->id_offset =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 queue->id_sequence =3D queue->id_offset;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (__find_entry(queue, =
queue->id_sequence) =3D=3D NULL)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return queue->id_sequence;
>
> No freaking way. So you want to lower the overhead for your case
> any everyone else has to pay the price? This means that every
> existing user will now have to walk the entire queue of queued
> packets for every new packet.

Oh, it is really a bad news for the current users. But how to avoid
duplicate IDs? Since we use list(hash table with 1 buckets), we must
afford this cost, although it is rare there are duplicate IDs in one
queue. How about enlarging the default size of the hash table, and
change its size with the max size of queue?

>
> How about you start with something simple and try to optimize
> later in case there are actually performance problems? That
> probably means use a simple modulo operation for cases where
> the hash table size is > 1.
>

I also think there are too much tricks in my code above, but Eric
concerns the performance of modulo.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
