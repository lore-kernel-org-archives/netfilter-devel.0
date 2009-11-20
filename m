From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] nfnetlink_queue: Use hash to speed up finding entries in
	nfqueue
Date: Fri, 20 Nov 2009 22:00:03 +0800
Message-ID: <412e6f7f0911200600i377160e1j84ee0b1e5b4eb1eb@mail.gmail.com>
References: <4B06217F.6060901@gmail.com> <4B0695DB.3010401@trash.net>
	 <412e6f7f0911200546n5d44082dt69fec1514b51c12b@mail.gmail.com>
	 <4B06A010.4040506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:60186 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbZKTN75 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:59:57 -0500
Received: by pzk1 with SMTP id 1so2415776pzk.33
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2009 06:00:03 -0800 (PST)
In-Reply-To: <4B06A010.4040506@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 20, 2009 at 9:56 PM, Patrick McHardy <kaber@trash.net> wrot=
e:
> Changli Gao wrote:
>> On Fri, Nov 20, 2009 at 9:12 PM, Patrick McHardy <kaber@trash.net> w=
rote:
>>> Changli Gao wrote:
>>>> Use hash to speed up finding entries in nfqueue.
>>>>
>>>> If user implements QoS in userland, packet verdict won't be receiv=
ed in order. At this moment, a hash table is faster than a double linke=
d list when finding the corresponding entries in nfqueue.
>>>>
>>>> This patch also fixes a potential bug, which will allows more than=
 one entries with the same id are in the same nfqueue in the extreme.
>>> Instead of a double ID in a purely hypothetical case, we'd now
>>> get an endless loop. This part doesn't make much sense to me,
>>> please remove it from the patch.
>>>
>>
>> It isn't a endless loop, as we limite the queue size.
>
> It is if queue_maxlen is set to the maximum. In any case this change
> adds a new lookup for ID assignment and complicates the code for a
> case which I still consider purely hypothetical. Additionally it is
> not related to the hashing change and shouldn't be in the same patch.
>

Agree.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
