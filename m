From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH nf-next 2/3] netfilter: conntrack: use get_random_once for
 nat and expectations
Date: Sun, 24 Apr 2016 20:59:17 +0200
Message-ID: <571D1785.7040509@stressinduktion.org>
References: <1460989021-10780-1-git-send-email-fw@strlen.de>
 <1460989021-10780-3-git-send-email-fw@strlen.de>
 <20160424140915.GA1141@salvia> <20160424151620.GA27317@breakpoint.cc>
 <571D0751.5020504@stressinduktion.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55865 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbcDXS7V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 14:59:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 4A63125E24
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2016 14:59:20 -0400 (EDT)
In-Reply-To: <571D0751.5020504@stressinduktion.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.04.2016 19:50, Hannes Frederic Sowa wrote:
> Hello,
> 
> On 24.04.2016 17:16, Florian Westphal wrote:
>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>
>> [ CC Hannes ]
>>
>>> On Mon, Apr 18, 2016 at 04:17:00PM +0200, Florian Westphal wrote:
>>>> Use a private seed and init it using get_random_once.
>>>>
>>>> Signed-off-by: Florian Westphal <fw@strlen.de>
>>>> ---
>>>>  net/netfilter/nf_conntrack_expect.c | 7 +++----
>>>>  net/netfilter/nf_nat_core.c         | 6 ++++--
>>>>  2 files changed, 7 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
>>>> index 278927a..c2f7c4f 100644
>>>> --- a/net/netfilter/nf_conntrack_expect.c
>>>> +++ b/net/netfilter/nf_conntrack_expect.c
>>>> @@ -38,6 +38,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_hsize);
>>>>  unsigned int nf_ct_expect_max __read_mostly;
>>>>  
>>>>  static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
>>>> +static unsigned int nf_ct_expect_hashrnd __read_mostly;
>>>>  
>>>>  /* nf_conntrack_expect helper functions */
>>>>  void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
>>>> @@ -76,13 +77,11 @@ static unsigned int nf_ct_expect_dst_hash(const struct nf_conntrack_tuple *tuple
>>>>  {
>>>>  	unsigned int hash;
>>>>  
>>>> -	if (unlikely(!nf_conntrack_hash_rnd)) {
>>>> -		init_nf_conntrack_hash_rnd();
>>>> -	}
>>>> +	get_random_once(&nf_ct_expect_hashrnd, sizeof(nf_ct_expect_hashrnd));
>>>
>>> Not related to your patch, but to the underlying infrastructure: I can
>>> see get_random_once() implementation uses static_key_true() branch
>>> check.
>>>
>>> Shouldn't this be static_key_false() instead? On architectures with
>>> not jump_labels support, this will translate to unlikely().
>>
>> Yes, looks like it.  Hannes?
> 
> The code is a bit tricky but still looks correct to me.
> 
> static_keys are only allowed to be used in two ways:
> 
> static_key_false()/INIT_FALSE -> after boot the hook is disabled and the
> branch is unlikely
> static_key_true()/INIT_TRUE -> after book the hook is enabled and the
> branch is likely
> 
> I actually need the following: after boot the hook is enabled *but* the
> branch is unlikely, but this isn't really implemented in the jump_label
> api and wouldn't be that easy.
> 
> I worked around this but Linus suggested that likely/unlikely doesn't
> really matter that much on modern CPUs and I should simply use
> static_key_true instead. The unlikely is the wrong annotation for this
> particular case but the static keys internally do automatic the right
> thing. We just have an unconditional jump instead of a nop in case of
> the fast path right now.
> 
> If we really would like to improve that we would need to extend the
> static key state, which doesn't seem worthwhile for that.
> 
>>> If so, I can send a patch for this. I can see this DO_ONCE() API is
>>> also using the deprecated interfaces.
>>
>> I think it just predates the new api.
>>
> 
> Yes, that is true, we could upgrade to the new API. But also with the
> new API all the above still holds and we still end up having the wrong
> likely/unlikely.

I just updated myself about the new API and we now can actually express
the correct intention and state. If no one is already working on that, I
can provide a patch to update net_get_random_once to the new API.

Thanks,
Hannes

