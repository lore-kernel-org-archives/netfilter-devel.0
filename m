From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: Remove the duplicated word in comment
Date: Mon, 31 Aug 2015 16:44:25 +0800
Message-ID: <CA+6hz4rj8E7PJTa6-4uEeYhD2-B7soCcpkSMyjh5M5yyg+G9tg@mail.gmail.com>
References: <CA+6hz4o+XCrHt_f31kK1d2=jsHY3mDvU4rEM=8DbmhiVbxDSNw@mail.gmail.com>
	<20150828231436.GA24569@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34867 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbbHaIo0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2015 04:44:26 -0400
Received: by oigk185 with SMTP id k185so54788826oig.2
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2015 01:44:25 -0700 (PDT)
In-Reply-To: <20150828231436.GA24569@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Could you use the attachment instead of the codes in email ?
I think the attachment should not be mangled.

On Sat, Aug 29, 2015 at 7:14 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Aug 22, 2015 at 11:27:56AM +0800, Feng Gao wrote:
>> Hi Pablo,
>>
>> To try to resolve the "git am" issue, so I start the new email
>> conversation. The attachment is the latest patch file.
>>
>> The following is the patch content too.
>
> Still not working, I think your MUA is mangling the patch. I can see
> that tabs are converted to spaces.
>
> $ git am /temporary/netfilter-nf_ct_tcp-Remove-the-duplicated-word-in-comment.patch -s
> Applying: netfilter: nf_ct_tcp: Remove the duplicated word in comment
> error: patch failed: net/netfilter/nf_conntrack_proto_tcp.c:1088
> error: net/netfilter/nf_conntrack_proto_tcp.c: patch does not apply
> Patch failed at 0001 netfilter: nf_ct_tcp: Remove the duplicated word in comment
> When you have resolved this problem run "git am --resolved".
> If you would prefer to skip this patch, instead run "git am --skip".
> To restore the original branch and stop patching run "git am --abort".
> $ git am --abort
> $ patch -p1 < /temporary/netfilter_ct_tcp-Remove-the-duplicated-word-in-comment.patch
> patching file net/netfilter/nf_conntrack_proto_tcp.c
> Hunk #1 FAILED at 1088.
> 1 out of 1 hunk FAILED -- saving rejects to file
> net/netfilter/nf_conntrack_proto_tcp.c.rej
>
>> -       /* Set ASSURED if we see see valid ack in ESTABLISHED
>> -          after SYN_RECV or a valid answer for a picked up
>> -          connection. */
>> +       /* Set ASSURED if we see valid ack in ESTABLISHED after
>> +        * SYN_RECV or a valid answer for a picked up connection.
>> +        */
>    ^^^^^^^^
> I can see space here instead of tab.
>
