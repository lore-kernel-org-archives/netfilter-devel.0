From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] netfilter: nf_queue: Replace conntrack entry
Date: Mon, 7 May 2018 11:07:44 +0300
Message-ID: <20180507080744.pbdilayv6udlb6ru@mwanda>
References: <20180503140745.26588-1-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Kristian Evensen <kristian.evensen@gmail.com>, netdev@vger.kernel.org,
 Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
 coreteam@netfilter.org, netfilter-devel@vger.kernel.org, kbuild-all@01.org,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 "David S. Miller" <davem@davemloft.net>,
 Pablo Neira Ayuso <pablo@netfilter.org>
To: kbuild@01.org, Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20180503140745.26588-1-kristian.evensen@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
List-Id: netfilter-devel.vger.kernel.org

Hi Kristian,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]
[also build test WARNING on v4.17-rc3 next-20180504]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Kristian-Evensen/netfilter-nf_queue-Replace-conntrack-entry/20180504-051218
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master

smatch warnings:
net/netfilter/nfnetlink_queue.c:1141 nfqnl_recv_verdict_batch() warn: curly braces intended?

# https://github.com/0day-ci/linux/commit/8776e32a6c6e2ba0c6c8ce85e227672b81a1649d
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 8776e32a6c6e2ba0c6c8ce85e227672b81a1649d
vim +1141 net/netfilter/nfnetlink_queue.c

8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1093  
7b8002a1 net/netfilter/nfnetlink_queue.c      Pablo Neira Ayuso 2015-12-15  1094  static int nfqnl_recv_verdict_batch(struct net *net, struct sock *ctnl,
7b8002a1 net/netfilter/nfnetlink_queue.c      Pablo Neira Ayuso 2015-12-15  1095  				    struct sk_buff *skb,
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1096  				    const struct nlmsghdr *nlh,
04ba724b net/netfilter/nfnetlink_queue.c      Pablo Neira Ayuso 2017-06-19  1097  			            const struct nlattr * const nfqa[],
04ba724b net/netfilter/nfnetlink_queue.c      Pablo Neira Ayuso 2017-06-19  1098  				    struct netlink_ext_ack *extack)
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1099  {
3da07c0c net/netfilter/nfnetlink_queue_core.c David S. Miller   2012-06-26  1100  	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1101  	struct nf_queue_entry *entry, *tmp;
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1102  	unsigned int verdict, maxid;
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1103  	struct nfqnl_msg_verdict_hdr *vhdr;
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1104  	struct nfqnl_instance *queue;
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1105  	LIST_HEAD(batch_list);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1106  	u16 queue_num = ntohs(nfmsg->res_id);
e8179610 net/netfilter/nfnetlink_queue_core.c Gao feng          2013-03-24  1107  	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1108  	enum ip_conntrack_info ctinfo;
e8179610 net/netfilter/nfnetlink_queue_core.c Gao feng          2013-03-24  1109  
e8179610 net/netfilter/nfnetlink_queue_core.c Gao feng          2013-03-24  1110  	queue = verdict_instance_lookup(q, queue_num,
e8179610 net/netfilter/nfnetlink_queue_core.c Gao feng          2013-03-24  1111  					NETLINK_CB(skb).portid);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1112  	if (IS_ERR(queue))
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1113  		return PTR_ERR(queue);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1114  
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1115  	vhdr = verdicthdr_get(nfqa);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1116  	if (!vhdr)
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1117  		return -EINVAL;
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1118  
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1119  	verdict = ntohl(vhdr->verdict);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1120  	maxid = ntohl(vhdr->id);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1121  
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1122  	spin_lock_bh(&queue->lock);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1123  
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1124  	list_for_each_entry_safe(entry, tmp, &queue->queue_list, list) {
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1125  		if (nfq_id_after(entry->id, maxid))
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1126  			break;
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1127  		__dequeue_entry(queue, entry);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1128  		list_add_tail(&entry->list, &batch_list);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1129  	}
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1130  
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1131  	spin_unlock_bh(&queue->lock);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1132  
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1133  	if (list_empty(&batch_list))
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1134  		return -ENOENT;
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1135  
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1136  	list_for_each_entry_safe(entry, tmp, &batch_list, list) {
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1137  		if (nfqa[NFQA_MARK])
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1138  			entry->skb->mark = ntohl(nla_get_be32(nfqa[NFQA_MARK]));
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1139  
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1140  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03 @1141  			nf_ct_get(entry->skb, &ctinfo);
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1142  
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1143  			if (ctinfo == IP_CT_NEW && verdict != NF_STOLEN &&
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1144  			    verdict != NF_DROP) {
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1145  				nfqnl_update_ct(net, entry->skb);
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1146  			}
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1147  #endif
8776e32a net/netfilter/nfnetlink_queue.c      Kristian Evensen  2018-05-03  1148  
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1149  		nf_reinject(entry, verdict);
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1150  	}
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1151  	return 0;
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1152  }
97d32cf9 net/netfilter/nfnetlink_queue.c      Florian Westphal  2011-07-19  1153  
