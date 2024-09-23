Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9492195809;
	Mon, 23 Sep 2024 10:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727085972; cv=none; b=Kc/eRQC0UkRnn6mYY5198r7yPY0+Cz/cTlZ61hjDOWDCmRrTQnyCrv1UeXyLMWlH9wPiAZUMvf26pLPJSrBibixiMtiBwZE1XBQLKTF2C41t4PqZIjW8J4pyrNXYs3SAzgqT1fEGCuOT3IX/lB1ieuy/6UhDmq2nXvbCO7h2NQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727085972; c=relaxed/simple;
	bh=5++EG5YPR8G36zcQsH8ZUeN+eishUBKNaNN9MgfrI14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=phH3bgzDhAuv8BGVMremvHOapV+7wNPI0hcSPZm5joYyHDeouUpeA7233lzjNdvNOa09Qg705H4FXd5Zs3lW1qi6+UGAlqHD2cwh3M3w4z0aVJxmu0fjrntotZampWToJYYfTvjIdNY0bcG/25p195x6QZqrxItzq/aa+Sunang=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=iwf/esCn; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="iwf/esCn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1727085955;
	bh=BBFkSpdkqkXzOv7hw0jDfkWRq2N7z6ltN378fMvMfd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=iwf/esCnQY0IUxVjZWI/Opzdqdj9jhNpRukqQTwpttbJmi1dGHp1KaSGbbD+bGf7k
	 FfJW8EDcJR3Nr13ZsTvI1fnn7d0JejMLsVZGKmTmU47T5knByQhO0x8OJ0HFRASnkp
	 SvqqF1oMFEHV5zKIMzYGAfpS+RpoOQVEdeEpS62s=
X-QQ-mid: bizesmtpsz13t1727085952teleyq
X-QQ-Originating-IP: DWjoYKT1vymwUPdyRIsvl3RwFkVa8GXG3DpnfPbDnkg=
Received: from [10.20.254.18] ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 23 Sep 2024 18:05:50 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13227385092718996023
Message-ID: <80515DEDE931DC2A+7fa48c7a-2955-4afb-821f-a0108a72009f@uniontech.com>
Date: Mon, 23 Sep 2024 18:05:51 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/bridge: Optimizing read-write locks in ebtables.c
To: Eric Dumazet <edumazet@google.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, roopa@nvidia.com,
 razor@blackwall.org, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <EC5AC714C75A855E+20240923091535.77865-1-yushengjin@uniontech.com>
 <CANn89i+4wbef3k6at_Kf+8MBmU4HhE9nxMRvROR_OxsZptffjA@mail.gmail.com>
From: yushengjin <yushengjin@uniontech.com>
In-Reply-To: <CANn89i+4wbef3k6at_Kf+8MBmU4HhE9nxMRvROR_OxsZptffjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4a-0


在 23/9/2024 下午5:29, Eric Dumazet 写道:
> On Mon, Sep 23, 2024 at 11:16 AM yushengjin <yushengjin@uniontech.com> wrote:
>> When conducting WRK testing, the CPU usage rate of the testing machine was
>> 100%. forwarding through a bridge, if the network load is too high, it may
>> cause abnormal load on the ebt_do_table of the kernel ebtable module, leading
>> to excessive soft interrupts and sometimes even directly causing CPU soft
>> deadlocks.
>>
>> After analysis, it was found that the code of ebtables had not been optimized
>> for a long time, and the read-write locks inside still existed. However, other
>> arp/ip/ip6 tables had already been optimized a lot, and performance bottlenecks
>> in read-write locks had been discovered a long time ago.
>>
>> Ref link: https://lore.kernel.org/lkml/20090428092411.5331c4a1@nehalam/
>>
>> So I referred to arp/ip/ip6 modification methods to optimize the read-write
>> lock in ebtables.c.
>>
>> test method:
>> 1) Test machine creates bridge :
>> ``` bash
>> brctl addbr br-a
>> brctl addbr br-b
>> brctl addif br-a enp1s0f0 enp1s0f1
>> brctl addif br-b enp130s0f0 enp130s0f1
>> ifconfig br-a up
>> ifconfig br-b up
>> ```
>> 2) Testing with another machine:
>> ``` bash
>> ulimit -n 2048
>> ./wrk -t48 -c2000 -d6000 -R10000 -s request.lua http://4.4.4.2:80/4k.html &
>> ./wrk -t48 -c2000 -d6000 -R10000 -s request.lua http://5.5.5.2:80/4k.html &
>> ```
>>
>> Signed-off-by: yushengjin <yushengjin@uniontech.com>
>> ---
>>   include/linux/netfilter_bridge/ebtables.h |  47 +++++++-
>>   net/bridge/netfilter/ebtables.c           | 132 ++++++++++++++++------
>>   2 files changed, 145 insertions(+), 34 deletions(-)
>>
>> diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
>> index fd533552a062..dd52dea20fb8 100644
>> --- a/include/linux/netfilter_bridge/ebtables.h
>> +++ b/include/linux/netfilter_bridge/ebtables.h
>> @@ -93,7 +93,6 @@ struct ebt_table {
>>          char name[EBT_TABLE_MAXNAMELEN];
>>          struct ebt_replace_kernel *table;
>>          unsigned int valid_hooks;
>> -       rwlock_t lock;
>>          /* the data used by the kernel */
>>          struct ebt_table_info *private;
>>          struct nf_hook_ops *ops;
>> @@ -124,4 +123,50 @@ static inline bool ebt_invalid_target(int target)
>>
>>   int ebt_register_template(const struct ebt_table *t, int(*table_init)(struct net *net));
>>   void ebt_unregister_template(const struct ebt_table *t);
>> +
>> +/**
>> + * ebt_recseq - recursive seqcount for netfilter use
>> + *
>> + * Packet processing changes the seqcount only if no recursion happened
>> + * get_counters() can use read_seqcount_begin()/read_seqcount_retry(),
>> + * because we use the normal seqcount convention :
>> + * Low order bit set to 1 if a writer is active.
>> + */
>> +DECLARE_PER_CPU(seqcount_t, ebt_recseq);
>> +
>> +/**
>> + * ebt_write_recseq_begin - start of a write section
>> + *
>> + * Begin packet processing : all readers must wait the end
>> + * 1) Must be called with preemption disabled
>> + * 2) softirqs must be disabled too (or we should use this_cpu_add())
>> + * Returns :
>> + *  1 if no recursion on this cpu
>> + *  0 if recursion detected
>> + */
>> +static inline unsigned int ebt_write_recseq_begin(void)
>> +{
>> +       unsigned int addend;
>> +
>> +       addend = (__this_cpu_read(ebt_recseq.sequence) + 1) & 1;
>> +
>> +       __this_cpu_add(ebt_recseq.sequence, addend);
>> +       smp_mb();
>> +
>> +       return addend;
>> +}
>> +
>> +/**
>> + * ebt_write_recseq_end - end of a write section
>> + * @addend: return value from previous ebt_write_recseq_begin()
>> + *
>> + * End packet processing : all readers can proceed
>> + * 1) Must be called with preemption disabled
>> + * 2) softirqs must be disabled too (or we should use this_cpu_add())
>> + */
>> +static inline void ebt_write_recseq_end(unsigned int addend)
>> +{
>> +       smp_wmb();
>> +       __this_cpu_add(ebt_recseq.sequence, addend);
>> +}
> Why not reusing xt_recseq, xt_write_recseq_begin(), xt_write_recseq_end(),
> instead of copy/pasting them ?
>
> This was added in
>
> commit 7f5c6d4f665bb57a19a34ce1fb16cc708c04f219    netfilter: get rid
> of atomic ops in fast path
They used different seqcounts, I'm worried it might have an impact.
>
> If this is an include mess, just move them in a separate include file.

Can i copy  ebt_write_recseq_begin(), ebt_write_recseq_endend to
include/linux/netfilter/x_tables.h ?

Or add a parameter in xt_write_recseq_begin() , xt_write_recseq_end()  to
clarify whether it is xt_recseq or ebt_recseq.


