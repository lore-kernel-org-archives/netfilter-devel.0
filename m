From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
	finding.
Date: Thu, 15 Apr 2010 16:30:50 +0800
Message-ID: <h2i412e6f7f1004150130mce8f443ao25c0d87a555f544@mail.gmail.com>
References: <4BBEA97A.5020303@gmail.com> <4BC442E5.8020001@trash.net>
	<n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com>
	<1271162669.16881.301.camel@edumazet-laptop> <r2q412e6f7f1004130609we90ce635u673ba882b8b50f50@mail.gmail.com>
	<1271164991.16881.346.camel@edumazet-laptop> <4BC470B3.4030007@trash.net>
	<h2n412e6f7f1004142353uac023edfqc59d076c0d8a1784@mail.gmail.com>
	<1271319790.16881.2188.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55860 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab0DOIbL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:31:11 -0400
Received: by iwn8 with SMTP id 8so483439iwn.16
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2010 01:31:10 -0700 (PDT)
In-Reply-To: <1271319790.16881.2188.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 15, 2010 at 4:23 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> Le jeudi 15 avril 2010 =C3=A0 14:53 +0800, Changli Gao a =C3=A9crit :
>> On Tue, Apr 13, 2010 at 9:25 PM, Patrick McHardy <kaber@trash.net> w=
rote:
>> >> Yes, that is why vmalloc() is perfect for this case. No extra mem=
ory for
>> >> management, but one pointer for each page of memory.
>> >
>> > I agree, if it works for conntrack, it certainly also works for
>> > nfnetlink_queue.
>> >
>>
>> I need to allocate memory in atomic section, so vmalloc() can't be u=
sed. :(
>>
>> does double check mechanism works?
>>
>
> Allocate memory to setup a hash table in atomic section ?
>
> Changli you can forget this right now, this is not serious.
>
> We are not going to use this thing because your requirements are craz=
y.
>

OK, I'll keep it myself. :)

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
