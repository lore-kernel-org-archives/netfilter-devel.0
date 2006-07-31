From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/8][CTNETLINK] Fix race condition on conntrack creation
Date: Mon, 31 Jul 2006 13:15:01 +0200
Message-ID: <44CDE635.9060101@netfilter.org>
References: <44C61A2E.3060102@netfilter.org>
	<200607281316.k6SDGBVP001926@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200607281316.k6SDGBVP001926@toshiba.co.jp>
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

Hi Yasuyuki,

Yasuyuki KOZAKAI wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Tue, 25 Jul 2006 15:18:38 +0200
> 
> 
>> - rework get_features facility to avoid a softlockup
> 
> 
> This looks nice cleanup, but __nf_conntrack_alloc() cannot
> be called while holding nf_conntrack_lock, because it may call
> early_drop(), which holds nf_contrack_lock and also may call
> nf_ct_put().
> 
> 
>> static struct nf_conn *
>> __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
>> 		     const struct nf_conntrack_tuple *repl,
>>-		     const struct nf_conntrack_l3proto *l3proto)
>>+		     const struct nf_conntrack_l3proto *l3proto,
>>+		     u_int32_t features)
>> {
> 
> 
> You've moved "features = l3proto->get_features(orig);" out of
> this function, then the argument 'l3proto' isn't necessary.

Indeed, I also detected another problem related with the NAT code in
ip_conntrack_netlink, so this patch needs to be dropped.

I'm questioning the usefulness of this patch since nfnetlink
serializes the creation of two new conntracks.

> BTW, I think this race is similar situation in init_conntrack().
> It doesn't care about race and __nf_conntrack_confirm() does it
> instead.
> 
> One more my concern is recent Patrick's proposal.
> 
> https://lists.netfilter.org/pipermail/netfilter-devel/2006-July/025107.html
> 
> 
>>- change conntrack to always put connections in the hash immediately
>>  and remove them again if the connection is dropped before beeing
>>  confirmed.
> 
> If we do this, we need to solve the same issue in init_conntrack().
> It might be time to consider to organize processing of hash and lock.

About the implementation, we can play around with refcounting, set 
refcount to 1 if the conntrack is unconfirmed and increase it to 2 once 
it gets confirmed.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
