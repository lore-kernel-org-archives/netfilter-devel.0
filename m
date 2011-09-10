From: Hiroshi KIHIRA <hiro@dump-Storage.net>
Subject: Re: [PATCH RFC] iptables-restore: new option to change the commit
 timing
Date: Sun, 11 Sep 2011 02:27:19 +0900
Message-ID: <4E6B9DF7.7080502@dump-Storage.net>
References: <4E68C314.3070709@dump-Storage.net>  <alpine.LNX.2.01.1109081652310.13219@frira.zrqbmnf.qr> <1315494418.2456.23.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LNX.2.01.1109081716390.13219@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vs-saku1.dump-storage.net ([49.212.16.99]:59287 "EHLO
	VS-SAKU1.dump-Storage.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388Ab1IJR1W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Sep 2011 13:27:22 -0400
In-Reply-To: <alpine.LNX.2.01.1109081716390.13219@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(11/09/09 0:22), Jan Engelhardt wrote:
>>> What would probably be most desirable is that iptables-restore keep=
s
>>> copies in memory of each table it attempted to touch,
>>> for the eventual case of a rollback.
>>
>> Unfortunately, keeping a copy into userland memory is not enough to
>> guarantee a rollback is possible in kernel land.
>>
>> You might be in an OOM situation preveting new (large) memory
>> allocations.
>
> If restoring the old table fails, no big deal, since we are already
> in an inconsistent state anyway =E2=80=94 caused by the rejection of =
the new
> table =E2=80=94, so there is no additional loss AFAICS.

If memory allocation failed while reading the input,iptables-restore
simply dies without any modification in the kernel space. But if the
OOM situation happened while committing the new or old table, an
inconsistent state will occur.

I believe that the rollback function is useful for many cases except
the memory allocation failure and the problem in kernel space. and
I try to implement it. in the next patch.

I think that 2 handles per tables are needed for rollback. One of them
is used for backup, and the other is for modification.
The backup handle is used if iptc_commit for modified handle failed.
It should succeed, because the handle keeps the table data previously
applied in the kernel space.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
