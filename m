From: Wang Jian <lark@linux.net.cn>
Subject: double call to ip_conntrack_put() ?
Date: Mon, 18 Apr 2005 17:29:45 +0800
Message-ID: <20050418171657.0370.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
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

Hi,

death_by_timeout() calls ip_conntrack_put() before return. And
death_by_timeout() is called combined with ip_conntrack_put() in some
places, such as

in early_drop()

        if (del_timer(&ct->timeout)) {
                death_by_timeout((unsigned long)ct);
                dropped = 1;
                CONNTRACK_STAT_INC(early_drop);
        }
        ip_conntrack_put(ct);

and in ip_ct_iterate_cleanup()

        while ((h = get_next_corpse(iter, data, &bucket)) != NULL) {
                struct ip_conntrack *ct = tuplehash_to_ctrack(h);
                /* Time to push up daises... */
                if (del_timer(&ct->timeout))
                        death_by_timeout((unsigned long)ct);
                /* ... else the timer will get him soon. */

                ip_conntrack_put(ct);
        }

Is this intended or misuse?


-- 
  lark
