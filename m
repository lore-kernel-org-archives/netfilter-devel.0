From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
Date: Wed, 27 Jun 2007 15:28:39 +0200
Message-ID: <46826607.4060201@trash.net>
References: <4615FE1D.80206@sw.ru>	<20070406102433.d3a670a5.dada1@cosmosbay.com>	<4616203A.80203@sw.ru> <4616626C.9020100@trash.net>	<4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com>	<46187770.1070106@sw.ru> <46417137.5080501@sw.ru>	<467FC8D2.5070102@trash.net> <46811292.1010501@sw.ru>	<468223D0.90305@sw.ru> <46822540.2010004@trash.net> <4682523F.6000002@trash.net> <4682582D.7080501@sw.ru> <46825D63.3060500@trash.net> <46825FE0.7060306@sw.ru> <4682638F.40507@trash.net> <46826566.2060304@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	"David S. Miller" <davem@davemloft.net>, devel@openvz.org
To: Vasily Averin <vvs@sw.ru>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760841AbXF0N3T@vger.kernel.org>
In-Reply-To: <46826566.2060304@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Vasily Averin wrote:
> Patrick McHardy wrote:
> 
>>+	for (i = 0; i < nf_conntrack_htable_size; i++) {
>>+		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
>>+			tmp = nf_ct_tuplehash_to_ctrack(h);
>>+			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
>>+				ct = tmp;
> 
> 
> It is incorrect: you should break nested loop here too.


No, as I said, we want the last entry of the chain.
