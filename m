From: =?UTF-8?B?7J206re87IiY?= <kslee109@gmail.com>
Subject: I encounterd kernel panic when I modified ip_queue.
Date: Mon, 7 May 2007 20:32:55 +0900
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAOw1YRArdYhAk8LmXFnnvB7CgAAAEAAAACC1UyejeIBDsI3ARe7CfA4BAAAAAA==@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: kslee109@gmail.com
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Well. I would modify ip_queue that the packet could bypass when ip_queue =
was full.
If ip_queue was full, then I set kernel timer and the packet could =
bypass during one seconds.
But, I encountered kernel pacnic when called add_timer().
Is there anyone who tell me the reason why I encountered kernel panic?

The below is added and modified source code.

static void
ipq_packet_bypass(struct ipq_queue_entry *b_entry)
{
	ipq_issue_verdict(b_entry, NF_ACCEPT);
}

static void ipq_bypass_timeout(unsigned long ptr)
{
	bypass_flag =3D 0;
	del_timer_sync(&bypass_timer);			/* delete bypass_timer */
}

static void ipq_bypass_add_timer(){
	init_timer(&bypass_timer);					/* init the timer structure */
=09
	bypass_timer.expires =3D jiffies + HZ;			/* one second */
	bypass_timer.data =3D 1;
	bypass_timer.function =3D ipq_bypass_timeout;	/* put timer call =
function */

	add_timer(&bypass_timer);
}

static int
ipq_enqueue_packet(struct sk_buff *skb, struct nf_info *info, void =
*data)
{
	int status =3D -EINVAL;
	struct sk_buff *nskb;
	struct ipq_queue_entry *entry;

	if (copy_mode =3D=3D IPQ_COPY_NONE)
		return -EAGAIN;

	entry =3D kmalloc(sizeof(*entry), GFP_ATOMIC);
	if (entry =3D=3D NULL) {
		printk(KERN_ERR "Safezone queue: OOM in ipq_enqueue_packet()\n");
		return -ENOMEM;
	}

	entry->info =3D info;
	entry->skb =3D skb;

	if (entry->info->hook =3D=3D NF_IP_LOCAL_OUT) {
		struct iphdr *iph =3D skb->nh.iph;

		entry->rt_info.tos =3D iph->tos;
		entry->rt_info.daddr =3D iph->daddr;
		entry->rt_info.saddr =3D iph->saddr;
	}


	nskb =3D ipq_build_packet_message(entry, &status);
	if (nskb =3D=3D NULL)
		goto err_out_free;
	=09
	write_lock_bh(&queue_lock);
=09
	if(bypass_flag) {
		ipq_packet_bypass(entry);
		goto err_out_free_nskb;
	}

	if (!peer_pid)
		goto err_out_free_nskb;=20

	if (queue_total >=3D queue_maxlen) {
		queue_dropped++;
		status =3D -ENOSPC;
		if (net_ratelimit())
			printk (KERN_WARNING "ip queue : full at %d entries, "
				"the packets are %s mode during 1 seconds. \n", queue_total,
				"BYPASS");
		ip_queueu_full_alert(nskb);
		bypass_flag =3D 1;
		ipq_bypass_add_timer();
		goto err_out_free_skb_bypass;
       }
                       =20
 	/* netlink_unicast will either free the nskb or attach it to a socket =
*/=20
	status =3D netlink_unicast(ipqnl, nskb, peer_pid, MSG_DONTWAIT);
	if (status < 0) {
              queue_user_dropped++;
		goto err_out_unlock;
	}

	__ipq_enqueue_entry(entry);

	write_unlock_bh(&queue_lock);
	return status;

err_out_free_skb_bypass:
	ipq_packet_bypass(entry);
	write_unlock_bh(&queue_lock);
	return 0;

err_out_free_nskb:
	kfree_skb(nskb);
=09
err_out_unlock:
	write_unlock_bh(&queue_lock);

err_out_free:
	kfree(entry);
	return status;
}

-------------------------------------------------------------
Kun-soo Lee=20
kslee109@gmail.com
-------------------------------------------------------------
