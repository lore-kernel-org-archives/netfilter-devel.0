From: Balazs Scheidler <bazsi@balabit.hu>
Subject: ip_ct_selective_cleanup algorithm
Date: Fri, 23 May 2003 14:31:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523123152.GA20538@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

While reading through the nfnetlink code, I've encountered the
ip_ct_selective_cleanup() function, which is used to delete entries from the
conntrack table selectively. A comment states that the algorithm is n^2, but
in fact it is even worse:

static struct ip_conntrack_tuple_hash *
get_next_corpse(int (*kill)(const struct ip_conntrack *i, void *data),
                void *data)
{
 	struct ip_conntrack_tuple_hash *h = NULL;
 	unsigned int i;

	READ_LOCK(&ip_conntrack_lock);
	for (i = 0; !h && i < ip_conntrack_htable_size; i++) {
	        h = LIST_FIND(&ip_conntrack_hash[i], do_kill, 
	                      struct ip_conntrack_tuple_hash *, kill, data);
	}
	if (h)
	        atomic_inc(&h->ctrack->ct_general.use);
	READ_UNLOCK(&ip_conntrack_lock);

	return h;
}

ip_ct_selective_cleanup(int (*kill)(const struct ip_conntrack *i, void *data),
                        void *data)
{
 	struct ip_conntrack_tuple_hash *h;

	/* This is order n^2, by the way. */
	while ((h = get_next_corpse(kill, data)) != NULL) {
	        /* Time to push up daises... */
	        if (del_timer(&h->ctrack->timeout))
	                death_by_timeout((unsigned long)h->ctrack);
	        /* ... else the timer will get him soon. */

		ip_conntrack_put(h->ctrack);
	}
}

get_next_corpse() restarts scanning the hash table every time it is called.
The reason seems to be to avoid races (as the hashtable might change while
this function is processing entries)

Currently this function is called from:
- masquerading, when an interface or IP address is removed
- from nlconntrack when a conntrack entry is removed
- from NAT when a helper is removed

Is it worth changing the behaviour to grab the lock once, traverse the whole
hashtable in one go, and then release the lock?

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
