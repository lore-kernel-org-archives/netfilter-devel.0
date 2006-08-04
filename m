From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 4/8][CTNETLINK] Fix race condition on conntrack creation
Date: Fri, 04 Aug 2006 15:43:01 +0100
Message-ID: <44D35CF5.1090502@ufomechanic.net>
References: <44C61A2E.3060102@netfilter.org>	<200607281316.k6SDGBVP001926@toshiba.co.jp>
	<44CDE635.9060101@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44CDE635.9060101@netfilter.org>
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

* Pablo Neira Ayuso wrote, On 31/07/06 12:15:
> Hi Yasuyuki,
> 
> Yasuyuki KOZAKAI wrote:
>> From: Pablo Neira Ayuso <pablo@netfilter.org>
>> Date: Tue, 25 Jul 2006 15:18:38 +0200
>>
>>
>>> - rework get_features facility to avoid a softlockup
>>
>>
>> This looks nice cleanup, but __nf_conntrack_alloc() cannot
>> be called while holding nf_conntrack_lock, because it may call
>> early_drop(), which holds nf_contrack_lock and also may call
>> nf_ct_put().
>>
>>
>>> static struct nf_conn *
>>> __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
>>>              const struct nf_conntrack_tuple *repl,
>>> -             const struct nf_conntrack_l3proto *l3proto)
>>> +             const struct nf_conntrack_l3proto *l3proto,
>>> +             u_int32_t features)
>>> {
>>
>>
>> You've moved "features = l3proto->get_features(orig);" out of
>> this function, then the argument 'l3proto' isn't necessary.
> 
> Indeed, I also detected another problem related with the NAT code in
> ip_conntrack_netlink, so this patch needs to be dropped.
> 
> I'm questioning the usefulness of this patch since nfnetlink
> serializes the creation of two new conntracks.


I'm finding it hard to drop this patch from the series, having trouble
applying patch 7 from the series without this patch.

I find it difficult to be comfortable with dropping some features of
this patch. In this fragment, the second chunk does what looks like an
important re-ordering of locking and conntrack creation; i.e. of course
the lock is retained till after conntrack creation.

So I don't think it is safe to entirely drop this patch; Pablo?


Index: linux-2.6.17.1/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ linux-2.6.17.1/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1212,13 +1212,9 @@ ctnetlink_create_conntrack(struct nfattr
                ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif

-       ct->helper = ip_conntrack_helper_find_get(rtuple);
-
-       add_timer(&ct->timeout);
+       ct->helper = ip_conntrack_helper_find(rtuple);
        ip_conntrack_hash_insert(ct);
-
-       if (ct->helper)
-               ip_conntrack_helper_put(ct->helper);
+       add_timer(&ct->timeout);

        DEBUGP("conntrack with id %u inserted\n", ct->id);
        return 0;
@@ -1260,11 +1256,11 @@ ctnetlink_new_conntrack(struct sock *ctn
                h = __ip_conntrack_find(&rtuple, NULL);

        if (h == NULL) {
-               write_unlock_bh(&ip_conntrack_lock);
                DEBUGP("no such conntrack, create new\n");
                err = -ENOENT;
                if (nlh->nlmsg_flags & NLM_F_CREATE)
                        err = ctnetlink_create_conntrack(cda, &otuple,
&rtuple);
+               write_unlock_bh(&ip_conntrack_lock);
                return err;
        }
        /* implicit 'else' */
