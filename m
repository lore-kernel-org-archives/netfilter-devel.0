From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 5/5] netfilter: nfnl_cthelper: fix a race when walk the
 nf_ct_helper_hash table
Date: Tue, 21 Mar 2017 22:48:21 +0800
Message-ID: <CAML_gOcmYsogb0BKRxkYh0MF9kW7KTd-HyvEbsa3uL_YTQOa7g@mail.gmail.com>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-6-git-send-email-zlpnobody@163.com> <20170321103334.GD1940@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:35719 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757063AbdCUOsX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 10:48:23 -0400
Received: by mail-vk0-f65.google.com with SMTP id z204so5439871vkd.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 07:48:22 -0700 (PDT)
In-Reply-To: <20170321103334.GD1940@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-03-21 18:33 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Sun, Mar 19, 2017 at 10:36:02PM +0800, Liping Zhang wrote:
>> From: Liping Zhang <zlpnobody@gmail.com>
>>
>> The nf_ct_helper_hash table is protected by nf_ct_helper_mutex, while
>> nfct_helper operation is protected by nfnl_lock(NFNL_SUBSYS_CTHELPER).
>> So it's possible that one CPU is walking the nf_ct_helper_hash for
>> cthelper add/get/del, another cpu is doing nf_conntrack_helpers_unregister
>> at the same time. This is dangrous, and may cause use after free error.
>>
>> Note, delete operation will flush all cthelpers added via nfnetlink, so
>> using rcu to do protect is not easy.
>>
>> Now introduce a dummy list to record all the cthelpers added via
>> nfnetlink, then we can walk the dummy list instead of walking the
>> nf_ct_helper_hash. Also, keep nfnl_cthelper_dump_table unchanged, it
>> may be invoked without nfnl_lock(NFNL_SUBSYS_CTHELPER) held.
>>
>> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
>> ---
>>  net/netfilter/nfnetlink_cthelper.c | 176 +++++++++++++++++++------------------
>>  1 file changed, 89 insertions(+), 87 deletions(-)
>>
>> diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
>> index fc4733f..47424ec 100644
>> --- a/net/netfilter/nfnetlink_cthelper.c
>> +++ b/net/netfilter/nfnetlink_cthelper.c
>> @@ -32,6 +32,13 @@ MODULE_LICENSE("GPL");
>>  MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
>>  MODULE_DESCRIPTION("nfnl_cthelper: User-space connection tracking helpers");
>>
>> +struct nfnl_cthelper {
>> +     struct list_head                list;
>> +     struct nf_conntrack_helper      *helper;
>> +};
>> +
>> +static LIST_HEAD(nfnl_cthelper_list);
>
> We need a field possible_net_t so we can store what netns this helper
> belongs to, thus in case of flush command, we just remove the helpers
> that this netns owns.

Yes, good point, I will send v2.

Thanks Pablo.
