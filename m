From: Michael StJohns <mstjohns@mindspring.com>
Subject: Re: ip_queue.c inefficiencies?
Date: Thu, 03 Feb 2005 16:15:23 -0500
Message-ID: <6.2.0.14.2.20050203160902.02ead150@pop.mindspring.com>
References: <6.2.0.14.2.20050118185904.047393e0@pop.mindspring.com>
	<20050201131128.GF6878@sunbeam.de.gnumonks.org>
	<4200EF2C.1030808@trash.net>
	<6.2.0.14.2.20050202105005.05278940@pop.mindspring.com>
	<42026FF0.2060602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42026FF0.2060602@trash.net>
References: <6.2.0.14.2.20050118185904.047393e0@pop.mindspring.com>
	<20050201131128.GF6878@sunbeam.de.gnumonks.org>
	<4200EF2C.1030808@trash.net>
	<6.2.0.14.2.20050202105005.05278940@pop.mindspring.com>
	<42026FF0.2060602@trash.net>
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

At 01:39 PM 2/3/2005, Patrick McHardy wrote:
>Michael StJohns wrote:
>
>>The original patch was against the ip_queue.c 1.10 version - which was 
>>2.4.21 Kernel.  (RHEL3).  Below is a version against the ip_queue.c 1.20 
>>version for the 2.6 kernel which seems to be the current version in bk.
>
>Thanks, I've added it to my 2.6.12 tree with one small change.
>We hold queue_lock in your new check for queue_total >= queue_maxlen,
>so the similar check in __ipq_enqueue_entry will never be true.
>Therefore I removed it.

Makes sense.  I had left it in because I wasn't sure if anyone else was 
calling it (__ipq_enqueue_entry).  Given the changes, it might actually 
make sense to eliminate __ipq_enqueue_entry by moving the last two lines of 
code into ipq_enqueue_entry



>>Do you want a version of this against net/ipv6/netfilter/ip6_queue.c as 
>>well?  It has the same inefficiency issue.
>
>Yes, please.

Will do.


>Regards
>Patrick
>
>BTW: Please add a Signed-off-by: line when you send a patch.

You're looking for "Signed-off-by: Mike StJohns <stjohns@nominum.com>" line 
in the patch file?  No problems - I'll provide one for the ip6_queue.c 
change.  I'm actually generating these by hand rather than through 
BitKeeper but will add appropriate text.

Thanks - Mike


># This is a BitKeeper generated diff -Nru style patch.
>#
># ChangeSet
>#   2005/02/03 19:33:24+01:00 mstjohns@mindspring.com
>#   [NETFILTER]: fix ip_queue inefficiencies
>#
>#   Check if packet exceeds max queue length before netlink_unicast(),
>#   add drop statistics.
>#
>#   Signed-off-by: Patrick McHardy <kaber@trash.net>
>#
># net/ipv4/netfilter/ip_queue.c
>#   2005/02/03 19:33:13+01:00 mstjohns@mindspring.com +27 -15
>#   [NETFILTER]: fix ip_queue inefficiencies
>#
>#   Check if packet exceeds max queue length before netlink_unicast(),
>#   add drop statistics.
>#
>#   Signed-off-by: Patrick McHardy <kaber@trash.net>
>#
>diff -Nru a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
>--- a/net/ipv4/netfilter/ip_queue.c     2005-02-03 19:34:12 +01:00
>+++ b/net/ipv4/netfilter/ip_queue.c     2005-02-03 19:34:12 +01:00
>@@ -14,6 +14,9 @@
>   *             Zander).
>   * 2000-08-01: Added Nick Williams' MAC support.
>   * 2002-06-25: Code cleanup.
>+ * 2005-01-10: Added /proc counter for dropped packets; fixed so
>+ *             packets aren't delivered to user space if they're going
>+ *             to be dropped.
>   *
>   */
>  #include <linux/module.h>
>@@ -59,6 +62,8 @@
>  static int peer_pid;
>  static unsigned int copy_range;
>  static unsigned int queue_total;
>+static unsigned int queue_dropped = 0;
>+static unsigned int queue_user_dropped = 0;
>  static struct sock *ipqnl;
>  static LIST_HEAD(queue_list);
>  static DECLARE_MUTEX(ipqnl_sem);
>@@ -70,18 +75,11 @@
>         kfree(entry);
>  }
>
>-static inline int
>+static inline void
>  __ipq_enqueue_entry(struct ipq_queue_entry *entry)
>  {
>-       if (queue_total >= queue_maxlen) {
>-               if (net_ratelimit())
>-                       printk(KERN_WARNING "ip_queue: full at %d entries, "
>-                              "dropping packet(s).\n", queue_total);
>-               return -ENOSPC;
>-       }
>         list_add(&entry->list, &queue_list);
>         queue_total++;
>-       return 0;
>  }
>
>  /*
>@@ -308,14 +306,24 @@
>         if (!peer_pid)
>                 goto err_out_free_nskb;
>
>+       if (queue_total >= queue_maxlen) {
>+                queue_dropped++;
>+               status = -ENOSPC;
>+               if (net_ratelimit())
>+                         printk (KERN_WARNING "ip_queue: full at %d 
>entries, "
>+                                 "dropping packets(s). Dropped: %d\n", 
>queue_total,
>+                                 queue_dropped);
>+               goto err_out_free_nskb;
>+       }
>+
>         /* netlink_unicast will either free the nskb or attach it to a 
> socket */
>         status = netlink_unicast(ipqnl, nskb, peer_pid, MSG_DONTWAIT);
>-       if (status < 0)
>-               goto err_out_unlock;
>-
>-       status = __ipq_enqueue_entry(entry);
>-       if (status < 0)
>+       if (status < 0) {
>+               queue_user_dropped++;
>                 goto err_out_unlock;
>+       }
>+
>+       __ipq_enqueue_entry(entry);
>
>         write_unlock_bh(&queue_lock);
>         return status;
>@@ -637,12 +645,16 @@
>                       "Copy mode         : %hu\n"
>                       "Copy range        : %u\n"
>                       "Queue length      : %u\n"
>-                     "Queue max. length : %u\n",
>+                     "Queue max. length : %u\n"
>+                     "Queue dropped     : %u\n"
>+                     "Netlink dropped   : %u\n",
>                       peer_pid,
>                       copy_mode,
>                       copy_range,
>                       queue_total,
>-                     queue_maxlen);
>+                     queue_maxlen,
>+                     queue_dropped,
>+                     queue_user_dropped);
>
>         read_unlock_bh(&queue_lock);
>
