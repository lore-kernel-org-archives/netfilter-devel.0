From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
Date: Wed, 27 Jun 2007 15:35:49 +0200
Message-ID: <468267B5.5000308@trash.net>
References: <4615FE1D.80206@sw.ru>	<20070406102433.d3a670a5.dada1@cosmosbay.com>	<4616203A.80203@sw.ru>	<4616626C.9020100@trash.net>	<4617845F.7080203@sw.ru>	<461789CF.8000106@cosmosbay.com>	<46187770.1070106@sw.ru>	<46417137.5080501@sw.ru>	<467FC8D2.5070102@trash.net>	<46811292.1010501@sw.ru>	<468223D0.90305@sw.ru>	<46822540.2010004@trash.net>
	<4682523F.6000002@trash.net>	<4682582D.7080501@sw.ru>
	<46825D63.3060500@trash.net>	<46825FE0.7060306@sw.ru>
	<4682638F.40507@trash.net>	<46826566.2060304@sw.ru>
	<46826607.4060201@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org, devel@openvz.org,
	Eric Dumazet <dada1@cosmosbay.com>
To: Vasily Averin <vvs@sw.ru>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46826607.4060201@trash.net>
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

Patrick McHardy wrote:
> Vasily Averin wrote:
> 
>>Patrick McHardy wrote:
>>
>>
>>>+	for (i = 0; i < nf_conntrack_htable_size; i++) {
>>>+		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
>>>+			tmp = nf_ct_tuplehash_to_ctrack(h);
>>>+			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
>>>+				ct = tmp;
>>
>>
>>It is incorrect: you should break nested loop here too.
> 
> 
> 
> No, as I said, we want the last entry of the chain.


Ideally we should do something like this I think (please let it be
correct :)):

+       for (i = 0; i < nf_conntrack_htable_size; i++) {
+               entries = 0;
+               hlist_for_each_entry(h, n, &nf_conntrack_hash[hash],
hnode) {
+                       tmp = nf_ct_tuplehash_to_ctrack(h);
+                       if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
+                               ct = tmp;
+                       entries++;
+               }
+               if (ct)
+                       break;
+               if ((cnt -= entries) <= 0)
+                       break;
+               hash = (hash + 1) % nf_conntrack_htable_size;
        }

So we always walk chains up to the end and NF_CT_EVICTION_RANGE is
just a minimum. This ensures we will always get the last entry *and*
we won't scan less entries than currently if someone has a chain
longer than 8 entries.

What do you think?
