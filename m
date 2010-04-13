From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
  finding.
Date: Tue, 13 Apr 2010 15:25:07 +0200
Message-ID: <4BC470B3.4030007@trash.net>
References: <4BBEA97A.5020303@gmail.com> <4BC442E5.8020001@trash.net>	 <n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com>	 <1271162669.16881.301.camel@edumazet-laptop>	 <r2q412e6f7f1004130609we90ce635u673ba882b8b50f50@mail.gmail.com> <1271164991.16881.346.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49470 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0DMNZI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:25:08 -0400
In-Reply-To: <1271164991.16881.346.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Le mardi 13 avril 2010 =E0 21:09 +0800, Changli Gao a =E9crit :
>> On Tue, Apr 13, 2010 at 8:44 PM, Eric Dumazet <eric.dumazet@gmail.co=
m> wrote:
>>> Thats theory. And for sparse arrays, that pro might be true.
>>> In your case, you prealloc all the array, using more ram than vmall=
oc...
>>>
>> I prealloc all the arrays, because all of them are needed later in a=
ny way.
>>
>=20
> Yes, that is why vmalloc() is perfect for this case. No extra memory =
for
> management, but one pointer for each page of memory.

I agree, if it works for conntrack, it certainly also works for
nfnetlink_queue.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
