From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
	finding.
Date: Tue, 13 Apr 2010 19:06:33 +0800
Message-ID: <n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com>
References: <4BBEA97A.5020303@gmail.com> <4BC442E5.8020001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:32772 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0DMLG5 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:06:57 -0400
Received: by gwaa18 with SMTP id a18so518032gwa.19
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 04:06:56 -0700 (PDT)
In-Reply-To: <4BC442E5.8020001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 13, 2010 at 6:09 PM, Patrick McHardy <kaber@trash.net> wrot=
e:
> Changli Gao wrote:
>> use hash table to speed up entry finding.
>>
>> If verdicts aren't received in order, list isn't efficient, and hash
>> table is better.
>
> Any what is the advantage of using flex arrays compared to a simple
> open code hash table?
>

=46rom Documentation/flexible-arrays.txt

Large contiguous memory allocations can be unreliable in the Linux kern=
el.
Kernel programmers will sometimes respond to this problem by allocating
pages with vmalloc().  This solution not ideal, though.  On 32-bit syst=
ems,
memory from vmalloc() must be mapped into a relatively small address sp=
ace;
it's easy to run out.  On SMP systems, the page table changes required =
by
vmalloc() allocations can require expensive cross-processor interrupts =
on
all CPUs.  And, on all systems, use of space in the vmalloc() range
increases pressure on the translation lookaside buffer (TLB), reducing =
the
performance of the system.

User may create lots of queues, which have large hash tables. Flex
array has better scalability than vmalloc() and kmalloc().

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
