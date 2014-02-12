From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RESEND v3] netfilter: xtables: add quota support to nfacct
Date: Wed, 12 Feb 2014 11:33:25 +0100
Message-ID: <20140212103325.GA15713@localhost>
References: <1391292671-26466-1-git-send-email-mathieu.poirier@linaro.org>
 <20140201225726.GF776@breakpoint.cc>
 <CANLsYkzCb=UqUoG5p4pVr-8YNfJcb25uesUZTMrwT7KuEh2LYg@mail.gmail.com>
 <20140202204012.GJ776@breakpoint.cc>
 <CANLsYkw=vVbc_cCAHHusxHmFi2EXg3jM6baG8jV355SDeHa1Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
	kadlec <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56420 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaBLKdf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:33:35 -0500
Content-Disposition: inline
In-Reply-To: <CANLsYkw=vVbc_cCAHHusxHmFi2EXg3jM6baG8jV355SDeHa1Pg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 03, 2014 at 04:40:49PM -0700, Mathieu Poirier wrote:
> I just did a small experiment on a 5-CPU vexpress highlighting what I
> see as a problem with "nfnl_acct_update":
> 
> 1)  I setup a rule where packets are guaranteed to hit "nfnl_acct_update":
>   $ iptables -I OUTPUT -p icmp -m nfacct --nfacct-name qaz --packet
> --quota 50000 --jump REJECT
> 
> 2)  Instrumented  "nfnl_acct_update" to look like this:
> 
> void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
> {
>          atomic64_inc(&nfacct->pkts);
>          printk(KERN_ALERT "PID: %d on %d updated packets: %lld with
> byte: %lld skb->len: %d\n",
>                                          current->pid, smp_processor_id(),
>                                          nfacct->pkts, nfacct->bytes, skb->len);
>          atomic64_add(skb->len, &nfacct->bytes);
>          printk(KERN_ALERT "PID: %d on %d updated bytes: %lld with
> packets: %lld skb->len: %d\n",
>                                          current->pid, smp_processor_id(),
>                                          nfacct->bytes, nfacct->pkts, skb->len);
> }
> 
> 
> 3) From the cmd line I started a "ping 192.168.1.1 > /dev/null &" that
> I bounded to each of my 5 CPUs.  As such I ping my gateway
> concurrently on each CPU.
> 
> 4) Here is the output:
> 
> 1   [  108.224602] PID: 3199 on 3 updated packets: 1 with byte: 0 skb->len: 84
> 2   [  108.224917] PID: 3195 on 4 updated packets: 2 with byte: 0 skb->len: 84
> 3   [  108.224921] PID: 3195 on 4 updated bytes: 84 with packets: 2 skb->len: 84
> 4   [  108.227378] PID: 3204 on 4 updated packets: 3 with byte: 84 skb->len: 84
> 5   [  108.227382] PID: 3204 on 4 updated bytes: 168 with packets: 3
> skb->len: 84
> 6   [  108.229297] PID: 3202 on 4 updated packets: 4 with byte: 168 skb->len: 84
> 7   [  108.229300] PID: 3202 on 4 updated bytes: 252 with packets: 4
> skb->len: 84
> 8   [  108.232075] PID: 3196 on 4 updated packets: 5 with byte: 252 skb->len: 84
> 9   [  108.232079] PID: 3196 on 4 updated bytes: 336 with packets: 5
> skb->len: 84
> 10 [  108.233988] PID: 3194 on 4 updated packets: 6 with byte: 336 skb->len: 84
> 11 [  108.233992] PID: 3194 on 4 updated bytes: 420 with packets: 6 skb->len: 84
> 12 [  108.236324] PID: 3198 on 4 updated packets: 7 with byte: 420 skb->len: 84
> 13 [  108.236328] PID: 3198 on 4 updated bytes: 504 with packets: 7 skb->len: 84
> 14 [  108.238648] PID: 3197 on 4 updated packets: 8 with byte: 504 skb->len: 84
> 15 [  108.238652] PID: 3197 on 4 updated bytes: 588 with packets: 8 skb->len: 84
> 16 [  108.240593] PID: 3203 on 4 updated packets: 9 with byte: 588 skb->len: 84
> 17 [  108.240596] PID: 3203 on 4 updated bytes: 672 with packets: 9 skb->len: 84
> 18 [  108.242973] PID: 3200 on 4 updated packets: 10 with byte: 672 skb->len: 84
> 19 [  108.242977] PID: 3200 on 4 updated bytes: 756 with packets: 10
> skb->len: 84
> 20 [  108.245329] PID: 3201 on 4 updated packets: 11 with byte: 756 skb->len: 84
> 21 [  108.245333] PID: 3201 on 4 updated bytes: 840 with packets: 11
> skb->len: 84
> 22 [  108.248056] PID: 3205 on 4 updated packets: 12 with byte: 840 skb->len: 84
> 23 [  108.248060] PID: 3205 on 4 updated bytes: 924 with packets: 12
> skb->len: 84
> 24 [  108.687297] PID: 3199 on 3 updated bytes: 1008 with packets: 12
> skb->len: 84
> 25 [  109.211928] PID: 3195 on 4 updated packets: 13 with byte: 1008
> skb->len: 84
> 26 [  109.232575] PID: 3195 on 4 updated bytes: 1092 with packets: 13
> skb->len: 84
> 
> A concurrency issue can be observed on line two where CPU4 is reading
> a byte count of 0 when it should really be 84 since CPU3 should have
> had time to complete the byte increment.  On line 3 the byte count is
> at 84 when it should be at 168.  The count between packets and byte is
> kept out of sync until line 24 where PID 3199 finally has a chance of
> upgrading its byte count.  This is just an example - there were many
> other cases...

I can see that packet and byte counters are not in sync, but I don't
see why that should be a problem for your quota extension. Your
accounting is based on packet *OR* byte counters. Moreover, if you
inspect the result of the counter update via atomic_inc_return /
atomic_add_return, you can ensure that packets running out of the
quota limit will always match.
