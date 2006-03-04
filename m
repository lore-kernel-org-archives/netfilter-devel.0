From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_recent fix
Date: Sat, 04 Mar 2006 11:10:31 +0100
Message-ID: <44096797.7060203@trash.net>
References: <dt51lh$b63$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <dt51lh$b63$1@sea.gmane.org>
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

Amin Azez wrote:
> Here is a fix for ipt_recent.
> 
> The problem is that curr_table[x].hash_entry=0 (for all x)
> 
> So all pristine (never used) curr_table entries claim to have hash pos 0.
> 
> So when we add new items to the hash and do:
>  hash_table[r_list[location].hash_entry] = -1;
> to use the oldest (used or unused) location - if it is unused we trash
> anything that really has hash pos 0 already allocated.
> 
> This can be reproduced with this:
> 
> # iptables -A FORWARD -d 1.1.1.1 -m recent --name TEST1 --set
> # G=1 ; while test $G -lt 17 ; do echo $G ; echo 1.1.1.$G> \
>  /proc/net/ipt_recent/TEST1 ; G=$(($G+1)) ; dmesg -c ; cat \
>  /proc/net/ipt_recent/TEST1  | head ; done > x
> 
> the 13th item has hash of 0 and gets trashed when the 14th item is added
> without this patch.
> 
> We should only trash it then if we _know_ it has been used before and
> therefore is REALLY at the position it claims...
> 
> This patch makes sure that items claiming to have a hash entry really do
> have that hash entry before destroying that hash entry.
> 
> This patch also adds counting of the number of hash entries in
> preparation for conditions based on the number of entries in the recent
> table rule; patch for that to follow next week.
> 
> Any comments on this?
> 
> Sam
> 
> 
> ------------------------------------------------------------------------
> 
> --- ./net/ipv4/netfilter/ipt_recent.c.nolimit	2006-02-15 16:34:20.000000000 +0000
> +++ ./net/ipv4/netfilter/ipt_recent.c	2006-02-17 17:23:00.000000000 +0000
> @@ -70,7 +70,11 @@
>  /* Structure of our linked list of tables of recent lists. */
>  struct recent_ip_tables {
>  	char name[IPT_RECENT_NAME_LEN];
> +	/* number of entries in list *table */
> +	int entry_count;
> +	/* number of reference to this structure from iptables rules */
>  	int count;
> +	/* an index increased with each operation which maps time_info[x].position to a position in table */
>  	int time_pos;
>  	struct recent_ip_list *table;
>  	struct recent_ip_tables *next;
> @@ -139,6 +143,7 @@
>  	curr_table = (struct recent_ip_tables*) data;
>  
>  	spin_lock_bh(&curr_table->list_lock);
> +	len += sprintf(buffer+len,"count=%d\n",curr_table->entry_count);
>  	for(count = 0; count < ip_list_tot; count++) {
>  		if(!curr_table->table[count].addr) continue;
>  		last_len = len;

This changes the proc output format, which we shouldn't do without a
good reason to avoid breaking scripts parsing it. Can you seperate
the fix from the patch please and send that? If you think there is
a good reason to change the output format feel free to send a seperate
patch for that.
