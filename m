From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
	finding.
Date: Thu, 15 Apr 2010 14:53:56 +0800
Message-ID: <h2n412e6f7f1004142353uac023edfqc59d076c0d8a1784@mail.gmail.com>
References: <4BBEA97A.5020303@gmail.com> <4BC442E5.8020001@trash.net>
	<n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com>
	<1271162669.16881.301.camel@edumazet-laptop> <r2q412e6f7f1004130609we90ce635u673ba882b8b50f50@mail.gmail.com>
	<1271164991.16881.346.camel@edumazet-laptop> <4BC470B3.4030007@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53875 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0DOGyR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:54:17 -0400
Received: by gyg13 with SMTP id 13so583101gyg.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Apr 2010 23:54:16 -0700 (PDT)
In-Reply-To: <4BC470B3.4030007@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 13, 2010 at 9:25 PM, Patrick McHardy <kaber@trash.net> wrot=
e:
>> Yes, that is why vmalloc() is perfect for this case. No extra memory=
 for
>> management, but one pointer for each page of memory.
>
> I agree, if it works for conntrack, it certainly also works for
> nfnetlink_queue.
>

I need to allocate memory in atomic section, so vmalloc() can't be used=
=2E :(

does double check mechanism works?

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
