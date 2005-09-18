From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Sun, 18 Sep 2005 16:26:09 +0200
Message-ID: <432D7901.1080609@trash.net>
References: <20050915145406.GC17121@rama.de.gnumonks.org>
	<4329F94E.4060107@trash.net>
	<20050916091548.GO5034@sunbeam.de.gnumonks.org>
	<20050916.154556.116608678.davem@davemloft.net>
	<20050916225131.GS8413@sunbeam.de.gnumonks.org>
	<432C443C.5010101@trash.net> <432C563D.7050607@trash.net>
	<20050918132837.GI8413@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050918132837.GI8413@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Sat, Sep 17, 2005 at 07:45:33PM +0200, Patrick McHardy wrote:
> 
>>First, wouldn't it make sense to make ip_{conntrack,nat}_proto_gre
>>usable without pptp as well?
> 
> That's how all helpers up to kernel 2.6.12 looked like.  However,  you
> cannot track GRE without some higher-level module. The reason is that
> GRE (if at all) uses a single KEY instead of source destination port.
> 
> In netfilter-speak, the "key" is part of tuple.dst.u, and if
> pkt_to_tuple() has to resolve the full tuple.  Without some higher level
> module (such as pptp) telling the GRE tracking code which key belongs to
> the key in the opposite direction, there is no way it could work.
> 
> Since a lot of GRE applications (such as ip-over-gre) don't even use the
> optional key, you're back to the good old "generic" conntrack, and you
> can't distinguish multiple sessions between two IP's.
> 
> Since for PPTP the "four modules" approach caused many user problems,
> and there was no other sensible use of the GRE code in sight, I dropped
> that idea.

Thanks for the explanation.

>>diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c 
>>b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
>>new file mode 100644
>>--- /dev/null
>>+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
>>
>>I would prefer the name ip_conntrack_pptp.c for consisteny with
>>other helpers. Same for ip_nat_helper_pptp.c.
> 
> AFAIK, that's not possible, since the resulting module is called
> ip_conntrack_pptp.ko , but it is a multi-object module.  Again, this
> change was only introduced in the 2.6.13 version when gre and pptp files
> were linked together for a single kernel module.
> 
> I don't think that consistency in soucre file naming is a valid reason
> to abandon this combination, though.
 >
> And if at all, I would argue that the existing code is inconsistently
> named and that we should introduce _helper into the existing ones [like
> we have _proto for protocoks] ;)

That would make even more sense, but would cause incompatiblities.
I agree its not important, so lets just leave it for now.

>>+static int timeout_ct_or_exp(const struct ip_conntrack_tuple *t)
>>+{
>>+    struct ip_conntrack_tuple_hash *h;
>>+    struct ip_conntrack_expect *exp;
>>+
>>+    DEBUGP("trying to timeout ct or exp for tuple ");
>>+    DUMP_TUPLE(t);
>>+
>>+    h = __ip_conntrack_find(t, NULL);
>>+    if (h)  {
>>+        struct ip_conntrack *sibling = tuplehash_to_ctrack(h);
>>+        DEBUGP("setting timeout of conntrack %p to 0\n", sibling);
>>+        sibling->proto.gre.timeout = 0;
>>+        sibling->proto.gre.stream_timeout = 0;
>>+        /* refresh_acct will not modify counters if skb == NULL */
>>+        ip_ct_refresh_acct(sibling, 0, NULL, 0);
>>
>>The regular way of doing this (del_timer, call ct->timeout.function)
>>seems cleaner too me.
> 
> ok, no problem with that. I thought it was better to not expose
> conntrack details into the helper, but I'll change it.

As a cleanup for other helpers as well we can put this in a function.

>>+void __exit ip_ct_proto_gre_fini(void)
>>+{
>>+    struct list_head *pos, *n;
>>+
>>+    /* delete all keymap entries */
>>+    write_lock_bh(&ip_ct_gre_lock);
>>+    list_for_each_safe(pos, n, &gre_keymap_list) {
>>+        DEBUGP("deleting keymap %p at module unload time\n", pos);
>>+        list_del(pos);
>>+        kfree(pos);
>>
>>break;
>>
>>+    }
>>+    write_unlock_bh(&ip_ct_gre_lock);
>  
> Why would you want to have a break statement?  We really want to iterate
> over the list and delete all (for some strange reason) not yet kfree'd
> keymaps at module unload time.

Sorry, that was a misunderstanding, I somehow thought it wanted
to clean up a single entry. The break is wrong of course.

> I originally added the code during development to notify me of (and
> clean up) any keymap memory leaks.   I don't know of any such leaks
> being left for quite some time, so we could make the whole block #ifdef
> DEBUG_PPTP.   However, it doesn't hurt to make sure by leaving it in.
> What do you think?

Maybe a BUG_ON(!list_empty(&gre_keymap_list)) then?

> The resulting code is now in my netfilter-2.6.14 tree.  I'll submit
> later today.

Great, nice to finally see this going in.
