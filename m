From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] clean up for conntrack stats
Date: Thu, 07 Oct 2004 02:30:01 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41648E09.3000202@trash.net>
References: <4162B517.8030200@eurodev.net> <41642FAC.6050406@trash.net>
	<41647489.2090402@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41647489.2090402@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:

> Patrick McHardy wrote:
>
>>> b) Martin, I've killed this to make them use the macro, are you ok 
>>> with this? I know that we call twice smp_proccesor_id now, but it's 
>>> clean I think.
>>>
>>> -       /* use per_cpu() to avoid multiple calls to 
>>> smp_processor_id() */
>>> -       unsigned int cpu = smp_processor_id();
>>>
>>>        MUST_BE_READ_LOCKED(&ip_conntrack_lock);
>>>        list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
>>>                if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
>>> -                       per_cpu(ip_conntrack_stat, cpu).found++;
>>> +                       CONNTRACK_STAT_INC(found);
>>>                        return h;
>>>
>>
>> Please send this part as a seperate patch.
>
>
>
> attached to this email, conntrack_find-stats-cleanup.patch file.

Applied, thanks. smp_processor_id doesn't involve atomic
operations (at least on x86), so I don't expect it harms performance
noticeable.

>>
>> Why this change ? ct_add_counters is an inline function with an
>> empty body when CONFIG_IP_NF_CT_ACCT is undefined.
>
>
>
> True, it changes nothing. Packet counting vanishes if 
> CONFIG_IP_NF_CT_ACCT is unset, to make the system consistent maybe we 
> should make vanish normal stats counting as well. See 
> ct-stat-macro-vanishes.patch file. If you don't like it anyway, drop 
> it :-).


If we make it configurable it should use a different config
option. CONFIG_IP_NF_CT_ACCT is per-conntrack accounting,
conntrack stats is something quite different. I'm still not
convinced it is worth adding yet another config option,
considering it doesn't cost much, and it provides some useful
debugging information for people complaining about long delays
(lots of expectations) and such.

> I've attached another patch, see fix-remove-ip_conntrack_expect.patch 
> file, if conntrack stats are set, ip_conntrack is compiled as module 
> and you unload it, ip_conntrack_expect entry in /proc stays there 
> forever.

Thanks alot, also applied. But please do two things next time
you submit patches:

- Sign off your patches. I've signed your name this time,
if you don't protest I'm going to submit them tomorrow.

- Please send each patch in a seperate mail. This makes
it easier to review and reply.

Thanks.

Regards,
Patrick
