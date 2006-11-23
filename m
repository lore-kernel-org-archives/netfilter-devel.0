From: Patrick McHardy <kaber@trash.net>
Subject: Re: connbytes & 64bit counters
Date: Thu, 23 Nov 2006 15:05:59 +0100
Message-ID: <4565AAC7.8050702@trash.net>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
	<453FE325.1040502@trash.net>
	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
	<45462043.5010207@trash.net>
	<Pine.LNX.4.64.0610302055060.3941@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Krzysztof Oledzki <olenf@ans.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0610302055060.3941@bizon.gios.gov.pl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Krzysztof Oledzki wrote:
> 
> 
> On Mon, 30 Oct 2006, Patrick McHardy wrote:
> 
>> Krzysztof Oledzki wrote:
>>
>>> [NETFILTER] Reimplementation of 64bit counters for bytes/packets
>>> accounting
>>>
>>> Initially netfilter has had 64bit counters for conntrack-based
>>> accounting, but
>>> it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit
>>> counters are
>>> still required, for example for "connbytes" extension. Add possibility
>>> to choose
>>> between 32 and 64bits but keep default 32bit counters.
>>>
>>> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
>>>
>>> +++ linux-2.6.19-rc3/net/netfilter/nf_conntrack_netlink.c    2006-10-28
>>> 18:24:12.000000000 +0200
>>> @@ -194,13 +194,23 @@
>>>  {
>>>      enum ctattr_type type = dir ? CTA_COUNTERS_REPLY:
>>> CTA_COUNTERS_ORIG;
>>>      struct nfattr *nest_count = NFA_NEST(skb, type);
>>> -    u_int32_t tmp;
>>> +#ifdef CONFIG_NF_CT_ACCT_64BIT_COUNTERS
>>> +    __be64 tmp;
>>> +
>>> +    tmp = cpu_to_be64(ct->counters[dir].packets);
>>> +    NFA_PUT(skb, CTA_COUNTERS_PACKETS, sizeof(__be64), &tmp);
>>> +
>>> +    tmp = cpu_to_be64(ct->counters[dir].bytes);
>>> +    NFA_PUT(skb, CTA_COUNTERS_BYTES, sizeof(__be64), &tmp);
>>> +#else
>>
>>
>> We can't make the API depend on config options
> 
> But this does not change the API imho, and this situation is perfectly
> handled by libnetfilter_conntrack:


It does change the API since we currently use u32. But you're
right that it shouldn't break anything (even if something
besides libnetfilter_conntrack uses the raw attributes) since
we use big endian.

>> (and I don't like all those ifdefs).
> 
> Why?

Because they make the code ugly and unreadable.

>> For now I would suggest to keep the ctnetlink interface as it is and
>> use 64 bit counters either unconditionally or only when the connbytes
>> match is enabled.
> 
> 
> What is wrong in sending 64 bit counters to userspace if we already have
> 64 bit counters in kernel?

Nothing - but changing the API based on config options is bad design.
I am fine with sending 64 bit unconditionally. But you need to make
sure you don't send (32 bit) overflow events to userspace anymore.

Mhh .. this hole thing is a mess:

enum ctattr_counters {
        CTA_COUNTERS_UNSPEC,
        CTA_COUNTERS_PACKETS,           /* old 64bit counters */
        CTA_COUNTERS_BYTES,             /* old 64bit counters */
        CTA_COUNTERS32_PACKETS,
        CTA_COUNTERS32_BYTES,

        __CTA_COUNTERS_MAX
};

So apparently we already broke compatibility. My prefered solution would
be to get rid of this mess and return to 64 bit counters unconditionally
and everywhere.
