From: Pablo Neira <pablo@eurodev.net>
Subject: [RFC] [PATCH] ctnetlink updates
Date: Mon, 28 Mar 2005 01:55:15 +0200
Message-ID: <424747E3.7000300@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

I've ported nfnetlink-ctnetlink to 2.6 ip_conntrack to make the 
transition easier. So my intentions are porting it to nfconntrack once 
it gets pushed forward. My work is done on top of the ct-event-API.

There are some issues I'd like to discuss:

o Declaring ID as unsigned int. I think it's just fine.

	- A conntrack must be identified with one of the tuples (original or 
reply) and its id. That way it can be uniquely identified.

	- Using u_int64_t just reduces the possibility of the wrapping around 
but such possible problem is still there.

o dump_table() has problems once wrapping around happens.

	- The ordered list isn't ordered anymore once id wrapping around 
happens. New conntracks with low id's are inserted at the end. While 
dumping the table, the branch that compares that ct->id <= cb->args[0] 
returns true and those new conntracks aren't dumped.

I've introduced a function that inserts conntrack ordered by id in the 
buckets.

static inline void
list_insert_ordered(struct list_head *head,
                     struct ip_conntrack *ct,
                     enum ip_conntrack_dir dir)
{
         struct list_head *i;
         struct ip_conntrack *cur;

         ASSERT_WRITE_LOCK(head);
         list_for_each(i, head) {
                 cur = (struct ip_conntrack *) i;
                 if (ct->id <= cur->id) {
                         list_add_tail(&ct->tuplehash[dir].list, i);
                         return;
                 }
         }
         list_add_tail(&ct->tuplehash[dir].list, head);
}

--
Pablo
