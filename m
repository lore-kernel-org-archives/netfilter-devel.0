From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: New match ipt_geoip
Date: Thu, 04 Nov 2004 19:57:06 -0500
Message-ID: <418ACFE2.8030605@cookinglinux.org>
References: <41899D17.7060800@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000504090305090009090301"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <41899D17.7060800@cookinglinux.org>
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

This is a multi-part message in MIME format.
--------------000504090305090009090301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

*Doh!*

Am sorry guys, I've made an error. Just before posting, I've changed 
something without testing again.  But that change introduced a 
segmentation fault.

Here's the fixed file, and I also attached the fixed pomng package.
Hope you won't beat me :-)

Samuel


--------------000504090305090009090301
Content-Type: text/x-csrc;
 name="ipt_geoip.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_geoip.c"

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/skbuff.h>
#include <linux/netdevice.h>
#include <asm/uaccess.h>
#include <asm/atomic.h>

#include <linux/netfilter_ipv4/ipt_geoip.h>
#include <linux/netfilter_ipv4/ip_tables.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Samuel Jean, Nicolas Bouliane");
MODULE_DESCRIPTION("iptables/netfilter's geoip match");

struct geoip_info *head = NULL;
static spinlock_t geoip_lock = SPIN_LOCK_UNLOCKED;

static struct geoip_info *add_node(struct geoip_info *memcpy)
{
   struct geoip_info *p =
      (struct geoip_info *)kmalloc(sizeof(struct geoip_info), GFP_KERNEL);

   struct geoip_subnet *s;

   if ((p == NULL) || (copy_from_user(p, memcpy, sizeof(struct geoip_info)) != 0))
      return NULL;

   s = (struct geoip_subnet *)kmalloc(p->count * sizeof(struct geoip_subnet), GFP_KERNEL);
   if ((s == NULL) || (copy_from_user(s, p->subnets, p->count * sizeof(struct geoip_subnet)) != 0))
      return NULL;
  
   spin_lock_bh(&geoip_lock);

   p->subnets = s;
   p->ref = 1;
   p->next = head;
   p->prev = NULL;
   if (p->next) p->next->prev = p;
   head = p;

   spin_unlock_bh(&geoip_lock);
   return p;
}

static void remove_node(struct geoip_info *p)
 {
   spin_lock_bh(&geoip_lock);
   
   if (p->next) { /* Am I following a node ? */
      p->next->prev = p->prev;
      if (p->prev) p->prev->next = p->next; /* Is there a node behind me ? */
      else head = p->next; /* No? Then I was the head */
   }
   
   else 
      if (p->prev) /* Is there a node behind me ? */
         p->prev->next = NULL;
      else
         head = NULL; /* No, we're alone */

   /* So now am unlinked or the only one alive, right ?
    * What are you waiting ? Free up some memory!
    */

   kfree(p->subnets);
   kfree(p);
   
   spin_unlock_bh(&geoip_lock);   
   return;
}

static struct geoip_info *find_node(u_int16_t cc)
{
   struct geoip_info *p = head;
   spin_lock_bh(&geoip_lock);
   
   while (p) {
      if (p->cc == cc) {
         spin_unlock_bh(&geoip_lock);         
         return p;
      }
      p = p->next;
   }
   spin_unlock_bh(&geoip_lock);
   return NULL;
}

static int match(const struct sk_buff *skb,
                 const struct net_device *in,
                 const struct net_device *out,
                 const void *matchinfo,
                 int offset,
                 const void *hdr,
                 u_int16_t datalen,
                 int *hotdrop)
{
   const struct ipt_geoip_info *info = matchinfo;
   const struct geoip_info *node; /* This keeps the code sexy */
   const struct iphdr *iph = skb->nh.iph;
   u_int32_t ip, j;
   u_int8_t i;

   if (info->flags & IPT_GEOIP_SRC)
      ip = ntohl(iph->saddr);
   else
      ip = ntohl(iph->daddr);

   spin_lock_bh(&geoip_lock);
   for (i = 0; i < info->count; i++) {
      if ((node = info->mem[i]) == NULL) {
         printk(KERN_ERR "ipt_geoip: what the hell ?? '%c%c' isn't loaded into memory... skip it!\n",
               COUNTRY(info->cc[i]));
         
         continue;
      }

      for (j = 0; j < node->count; j++)
         if ((ip > node->subnets[j].begin) && (ip < node->subnets[j].end)) {
            spin_unlock_bh(&geoip_lock);
            return (info->flags & IPT_GEOIP_INV) ? 0 : 1;
         }
   }
   
   spin_unlock_bh(&geoip_lock);
   return (info->flags & IPT_GEOIP_INV) ? 1 : 0;
}

static int geoip_checkentry(const char *tablename,
                             const struct ipt_ip *ip,
                             void *matchinfo,
                             unsigned int matchsize,
                             unsigned int hook_mask)
{
   struct ipt_geoip_info *info = matchinfo;
   struct geoip_info *node;
   u_int8_t i;
   
   /* FIXME:   Call a function to free userspace allocated memory.
    *          As Martin J. said; this match might eat lot of memory
    *          if commited with iptables-restore --noflush
   void (*gfree)(struct geoip_info *oldmem);
   gfree = info->fini;
   */

   if (matchsize != IPT_ALIGN(sizeof(struct ipt_geoip_info))) {
      printk(KERN_ERR "ipt_geoip: matchsize differ, you may have forgotten to recompile me\n");
      return 0;
   }

   /* If info->refcount isn't NULL, then
    * it means that checkentry() already
    * initialized this entry. Increase a
    * refcount to prevent destroy() of
    * this entry. */
   if (info->refcount != NULL) {
      atomic_inc((atomic_t *)info->refcount);
      return 1;
   }
   
  
   for (i = 0; i < info->count; i++) {
     
      if ((node = find_node(info->cc[i])) != NULL)
            atomic_inc((atomic_t *)&node->ref);   //increase the reference
      else
         if ((node = add_node(info->mem[i])) == NULL) {
            printk(KERN_ERR
                  "ipt_geoip: unable to load '%c%c' into memory\n",
                  COUNTRY(info->cc[i]));
            return 0;
         }

      /* Free userspace allocated memory for that country.
       * FIXME:   It's a bit odd to call this function everytime
       *          we process a country.  Would be nice to call
       *          it once after all countries've been processed.
       *          - SJ
       * *not implemented for now*
      gfree(info->mem[i]);
      */

      /* Overwrite the now-useless pointer info->mem[i] with
       * a pointer to the node's kernelspace structure.
       * This avoids searching for a node in the match() and
       * destroy() functions.
       */
      info->mem[i] = node;
   }

   /* We allocate some memory and give info->refcount a pointer
    * to this memory.  This prevents checkentry() from increasing a refcount
    * different from the one used by destroy().
    * For explanation, see http://www.mail-archive.com/netfilter-devel@lists.samba.org/msg00625.html
    */
   info->refcount = kmalloc(sizeof(u_int8_t), GFP_KERNEL);
   if (info->refcount == NULL) {
      printk(KERN_ERR "ipt_geoip: failed to allocate `refcount' memory\n");
      return 0;
   }
   *(info->refcount) = 1;
   
   return 1;
}

static void geoip_destroy(void *matchinfo, unsigned int matchsize)
{
   struct ipt_geoip_info *info = matchinfo;
   struct geoip_info *node; /* this keeps the code sexy */
   u_int8_t i;
   
   /* Decrease the previously increased refcount in checkentry()
    * If it's equal to 1, we know this entry is just moving
    * but not removed. We simply return to avoid useless destroy()
    * processing.
    */
   atomic_dec((atomic_t *)info->refcount);
   if (*info->refcount)
      return;
   
   /* This entry has been removed from the table so
    * decrease the refcount of all countries it is
    * using.
    */
  
   for (i = 0; i < info->count; i++)
      if ((node = info->mem[i]) != NULL) {
         atomic_dec((atomic_t *)&node->ref);

         /* Free up some memory if that node isn't used
          * anymore. */
         if (node->ref < 1)
            remove_node(node);
      }
      else
         /* Something strange happened. There's no memory allocated for this
          * country.  Please send this bug to the mailing list. */
         printk(KERN_ERR
               "ipt_geoip: What happened peejix ? What happened acidmen ?\n"
               "ipt_geoip: please report this bug to the maintainers\n");
   return;
}

static struct ipt_match geoip_match
= { { NULL, NULL }, "geoip", &match, &geoip_checkentry, &geoip_destroy, THIS_MODULE };

static int __init init(void)
{
   return ipt_register_match(&geoip_match);
}

static void __exit fini(void)
{
  ipt_unregister_match(&geoip_match);
  return;
}

module_init(init);
module_exit(fini);

--------------000504090305090009090301
Content-Type: application/x-gzip;
 name="geoip-pomng-20041104-1.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="geoip-pomng-20041104-1.tar.gz"

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
--------------000504090305090009090301--
