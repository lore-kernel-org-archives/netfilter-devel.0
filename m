From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
	finding.
Date: Thu, 15 Apr 2010 23:01:41 +0800
Message-ID: <j2w412e6f7f1004150801m66503602wbd0296c09aa45e90@mail.gmail.com>
References: <4BBEA97A.5020303@gmail.com> <1271162669.16881.301.camel@edumazet-laptop>
	<r2q412e6f7f1004130609we90ce635u673ba882b8b50f50@mail.gmail.com>
	<1271164991.16881.346.camel@edumazet-laptop> <4BC470B3.4030007@trash.net>
	<h2n412e6f7f1004142353uac023edfqc59d076c0d8a1784@mail.gmail.com>
	<4BC6EC15.4070205@trash.net> <t2t412e6f7f1004150735l54619e32t3e7fcdce7b118bd9@mail.gmail.com>
	<4BC72572.1050507@trash.net> <4BC726B4.1030003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:39651 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab0DOPCE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:02:04 -0400
Received: by iwn8 with SMTP id 8so645469iwn.16
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2010 08:02:01 -0700 (PDT)
In-Reply-To: <4BC726B4.1030003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 15, 2010 at 10:46 PM, Patrick McHardy <kaber@trash.net> wro=
te:
> Patrick McHardy wrote:
>>
>> That should be easily fixable. For the lookup we can add a reference
>> counter so we don't need the rcu read side critical section.
>
> Actually we don't even need that, since we're holding nfnl_mutex the
> instance can't go away.
>

I don't think so. a netlink queue instance maybe destroyed by
nfqnl_rcv_nl_event(). And the function is called by netlink directly
without nfnl_mutex.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
