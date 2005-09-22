From: "David S. Miller" <davem@davemloft.net>
Subject: conntrack event cache deadlock
Date: Wed, 21 Sep 2005 20:33:50 -0700 (PDT)
Message-ID: <20050921.203350.72192577.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


We can try to take the ip_conntrack_lock as a writer twice, and thus
deadlock, via this code path:

ip_ct_refresh_acct()
{
...
		write_lock_bh(&ip_conntrack_lock);
		/* Need del_timer for race avoidance (may already be dying). */
		if (del_timer(&ct->timeout)) {
			ct->timeout.expires = jiffies + extra_jiffies;
			add_timer(&ct->timeout);
			/* FIXME: We loose some REFRESH events if this function
			 * is called without an skb.  I'll fix this later -HW */
			if (skb)
				ip_conntrack_event_cache(IPCT_REFRESH, skb);

ip_conntrack_event_cache()
{
...
		__ip_ct_event_cache_init(ct);

__ip_ct_event_cache_init()
{
...
		__ip_ct_deliver_cached_events(ecache);

ip_ct_deliver_cached_events()
{
...
		__ip_ct_deliver_cached_events(ecache);

__ip_ct_deliver_cached_events()
{
...
	ip_conntrack_put(ecache->ct);

ip_conntrack_put()
{
...
	nf_conntrack_put(&ct->ct_general);

nf_conntrack_put()
{
...
	if (nfct && atomic_dec_and_test(&nfct->use))
		nfct->destroy(nfct);

->destroy() is setup by:

	conntrack->ct_general.destroy = destroy_conntrack;

so we call:

destroy_conntrack()
{
...
	write_lock_bh(&ip_conntrack_lock);

and this is where we deadlock.

This was caught by Ingo's spinlock debugging code in
lib/spinlock_debug.c BTW :-)
