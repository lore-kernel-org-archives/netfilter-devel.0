From: Massimiliano Cuzzoli <mcuzzoli@mbigroup.it>
Subject: Re: Problem with extended-match deletion
Date: Tue, 19 Aug 2003 15:37:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F422834.3020702@mbigroup.it>
References: <20030819102424.16725.44717.Mailman@kashyyyk> <012a01c36651$0889f970$010f430a@elite.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sumit Pandya <sumit@elitecore.com>
In-Reply-To: <012a01c36651$0889f970$010f430a@elite.co.in>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Sumit,
I try to write a kernel module similar to ipt_limit.c:

-->>> My match structure is:
struct ipt_bwctrl_info {
   unsigned long rate;  /* in Kbit/sec */
   unsigned long mark;
   unsigned long burst; /* in Kbit */

   unsigned long old_tstamp;
   unsigned long bit_burst; /* in bit */
   unsigned long bit_bonus; /* in bit */
   unsigned long bit_per_jiffy; /* in bit */

   /* As master field of ipt_limit.h !!!! */
   struct ipt_bwctrl_info *original;
};

-->>> My check_entry function:
static int bwcontrol_checkentry(const char *tablename, const struct 
ipt_ip *ip,
				void *matchinfo, unsigned int matchsize,
				unsigned int hookmask) {

   struct ipt_bwctrl_info *bw_info;

   if (matchsize!=IPT_ALIGN(sizeof(struct ipt_bwctrl_info))) {
     return(0);
   }

   bw_info=(struct ipt_bwctrl_info *) matchinfo;

   /* Init *bw_info fields... */
   /* ........................*/

   bw_info->original=bw_info; /* for SMP */

   return(1);
}

-->>> My match function:
static int bwcontrol_match(const struct sk_buff *skb,
			   const struct net_device *in,
			   const struct net_device *out,
			   const void *matchinfo, int offset,
			   const void *hdr, u_int16_t datalen,
			   int *hotdrop) {

   struct ipt_bwctrl_info *bw_info;

   bw_info=((struct ipt_bwctrl_info *) matchinfo)->original; /*for SMP*/

   spin_lock_bh(&bwcontrol_lock); /* SMP lock */

   /* Match controls ......... */
   /* ........................ */

   spin_unlock_bh(&bwcontrol_lock); /* SMP unlock */

   return(1);
}

Regards.

Sumit Pandya has wrote:
>>Date: Mon, 18 Aug 2003 17:34:40 +0200
>>From: Massimiliano Cuzzoli <mcuzzoli@mbigroup.it>
>>
>>Hi all,
> 
> Hi
> 
>>I've wrote a new match for iptables 1.2.7a.
> 
> Will you write more details? Some of its intended purpose ;-)
> 
>>All features, that I've implemented in it, run very well but
>>there is a problem when I try to remove the rule with my match.
> 
> Are you sure you not changing (void*) matchinfo structure from matchentry
> function within kernel module?
> 
>>Can Anybody help me???
> 
> Hope this helps :-)
> -- Sumit
