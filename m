From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: New match ipt_geoip
Date: Wed, 03 Nov 2004 22:08:07 -0500
Message-ID: <41899D17.7060800@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040408020900060408060005"
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

This is a multi-part message in MIME format.
--------------040408020900060408060005
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi people,

We've been working on a way to match a packet based on its country.
We know it's not a 100% reliable way to filter, but it all
depends on the database one use.

This could be usefull for packets classification though.

Let's explain the concept.

First, you need a database - as specified below - which contains
field of the form :

"begin_subnet","end_subnet","bin_start","bin_end","ISO Code","Country"

exemple:
"2.6.190.56","2.6.190.63","33996344","33996351","GB","United Kingdom"

This is the MaxMind's GeoIP CSV db format. But we obviously don't need
all those values, so we've written a tool called csv2bin that converts
this database type to a smaller binary format.

csv2bin is available at www.cookinglinux.org/geoip/
People can get free MaxMind's GeoIP database at www.maxmind.com

This tools create 2 files, geoipdb.bin (the database)
and geoipdb.idx (the index file). Unfortunatelly, we need to move both
files in /var/geoip/ by default - unless someone rewrite the static path
in the shared library.

That's about all for this fuzzy extra requierement.

The match options look like :

          [!]   --src-cc, --source-country <country code>
          [!]   --dst-cc, --destination-country <country code>

             NOTE: The country is inputed by its ISO3166 code.

You can match up to 15 countries in a rule.

-A INPUT -m geoip --source-country ca,us,jp,de,a1,a2

The library loads subnets of specified countries into user-memory
and passes pointers to the module which copies it into kernelspace.

If a country is specified more than once, a reference count is increased
for that country. When there's no more ref count, that country is freed
from memory.

What would be great is a caching system. Going to implement it when
we'll have time.

It all works for both linux-2.4 and 2.6.

Well, that's enough for theory that you can all presume by reading the
source code, so here it is.

(I'll put source for linux-2.4 but 2.6 is also provided in the pom-ng
package)

We'd like to thank Martin Josefsson for the great help he gave us.

Comments are greatly welcome.

Nicolas Bouliane,
Samuel Jean
at cookinglinux.org


--------------040408020900060408060005
Content-Type: text/x-chdr;
 name="ipt_geoip.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_geoip.h"

#ifndef _IPT_GEOIP_H
#define _IPT_GEOIP_H

#define IPT_GEOIP_SRC         0x01     /* Perform check on Source IP */
#define IPT_GEOIP_DST         0x02     /* Perform check on Destination IP */
#define IPT_GEOIP_INV         0x04     /* Negate the condition */

#define IPT_GEOIP_MAX         15       /* Maximum of countries */

struct geoip_subnet {
   u_int32_t begin;
   u_int32_t end;
};

struct geoip_info {
   struct geoip_subnet *subnets;
   u_int32_t count;
   u_int32_t ref;
   u_int16_t cc;
   struct geoip_info *next;
   struct geoip_info *prev;
};

struct ipt_geoip_info {
   u_int8_t flags;
   u_int8_t count;
   u_int16_t cc[IPT_GEOIP_MAX];

   /* Used internally by the kernel */
   struct geoip_info *mem[IPT_GEOIP_MAX];
   u_int8_t *refcount;

   /* not implemented yet:
   void *fini;
   */
};

#define COUNTRY(cc) (cc >> 8), (cc & 0x00FF)

#endif



--------------040408020900060408060005
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

   struct geoip_subnet *s =
      (struct geoip_subnet *)kmalloc(p->count * sizeof(struct geoip_subnet), GFP_KERNEL);

   if ((p == NULL) || (copy_from_user(p, memcpy, sizeof(struct geoip_info)) != 0))
      return NULL;

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


--------------040408020900060408060005
Content-Type: text/x-csrc;
 name="libipt_geoip.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libipt_geoip.c"

/* Shared library add-on to iptables to add geoip match support.
 *
 * For comments, bugs or suggestions, please contact
 * Samuel Jean       <sjean at cookinglinux.org>
 * Nicolas Bouliane  <nib at cookinglinux.org>
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include <ctype.h>
#include <stddef.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <iptables.h>
#include <linux/netfilter_ipv4/ipt_geoip.h>

// We need it to verify inputed country code
// This shouldn't go in ipt_geoip.h because only this library needs it.
// Also, those country codes *MUST* stand in alphabetic order due to the
// algorithm used to seek through this list.
#define COUNTRYCOUNT    243      /* Always re-adjust this value when
                                    adding/removing a country */
#define COUNTRYCODESZ   2        // This value shouldn't be changed.
static char *cc_list[COUNTRYCOUNT] = {
"A1","A2", // Anonymous Proxies and Satellite Providers
"AD","AE","AF","AG","AI","AL","AM","AN","AO","AQ","AR","AS","AT","AU","AW","AZ",
"BA","BB","BD","BE","BF","BG","BH","BI","BJ","BM","BN","BO","BR","BS","BT","BV",
"BW","BY","BZ","CA","CC","CD","CF","CG","CH","CI","CK","CL","CM","CN","CO","CR",
"CU","CV","CX","CY","CZ","DE","DJ","DK","DM","DO","DZ","EC","EE","EG","EH","ER",
"ES","ET","FI","FJ","FK","FM","FO","FR","FX","GA","GB","GD","GE","GF","GH","GI",
"GL","GM","GN","GP","GQ","GR","GS","GT","GU","GW","GY","HK","HM","HN","HR","HT",
"HU","ID","IE","IL","IN","IO","IQ","IR","IS","IT","JM","JO","JP","KE","KG","KH",
"KI","KM","KN","KP","KR","KW","KY","KZ","LA","LB","LC","LI","LK","LR","LS","LT",
"LU","LV","LY","MA","MC","MD","MG","MH","MK","ML","MM","MN","MO","MP","MQ","MR",
"MS","MT","MU","MV","MW","MX","MY","MZ","NA","NC","NE","NF","NG","NI","NL","NO",
"NP","NR","NU","NZ","OM","PA","PE","PF","PG","PH","PK","PL","PM","PN","PR","PS",
"PT","PW","PY","QA","RE","RO","RU","RW","SA","SB","SC","SD","SE","SG","SH","SI",
"SJ","SK","SL","SM","SN","SO","SR","ST","SV","SY","SZ","TC","TD","TF","TG","TH",
"TJ","TK","TM","TN","TO","TP","TR","TT","TV","TW","TZ","UA","UG","UM","US","UY",
"UZ","VA","VC","VE","VG","VI","VN","VU","WF","WS","YE","YT","YU","ZA","ZM","ZR",
"ZW" };

static void help(void)
{
   printf (
            "GeoIP v%s options:\n"
            "        [!]   --src-cc, --source-country country[,country,country,...]\n"
            "                                                     Match packet coming from (one of)\n"
            "                                                     the specified country(ies)\n"
            "\n"
            "        [!]   --dst-cc, --destination-country country[,country,country,...]\n"
            "                                                     Match packet going to (one of)\n"
            "                                                     the specified country(ies)\n"
            "\n"
            "           NOTE: The country is inputed by its ISO3166 code.\n"
            "\n"
            "\n", IPTABLES_VERSION
         );
}

static struct option opts[] = {
   {  "dst-cc",  1, 0, '2'  }, /* Alias for --destination-country */
   {  "destination-country",   1, 0, '2'  },
   {  "src-cc",  1, 0, '1'  }, /* Alias for --source-country */
   {  "source-country",  1, 0, '1'  },
   {  0  }
};

static void 
init(struct ipt_entry_match *m, unsigned int *nfcache)
{
}

/* NOT IMPLEMENTED YET
static void geoip_free(struct geoip_info *oldmem)
{
}
*/

static u_int8_t
binary_search(const char *key, u_int8_t low, u_int8_t hi)
{
   u_int8_t mid = (hi-low)/2 + low;
   if (low >= hi)
      return strncmp(key, cc_list[mid], 2);
   if (!strncmp(key, cc_list[mid], 2))
      return 0;
   if (strncmp(key, cc_list[mid], 2) > 0)
      return binary_search(key, mid+1, hi);
   else
      return binary_search(key, low, mid);
}

struct geoip_index {
   u_int16_t cc;
   u_int32_t offset;
} __attribute__ ((packed));

struct geoip_subnet *
get_country_subnets(u_int16_t cc, u_int32_t *count)
{
   FILE *ixfd, *dbfd;
   struct geoip_subnet *subnets;
   struct geoip_index *index;
   struct stat buf;
  
   size_t idxsz;
   u_int16_t i;
   
   u_int16_t db_cc = 0;
   u_int16_t db_nsubnets = 0;

   if ((ixfd = fopen("/var/geoip/geoipdb.idx", "r")) == NULL) {
         perror("/var/geoip/geoipdb.idx");
         exit_error(OTHER_PROBLEM,
               "geoip match: cannot open geoip's database index file");               
   }
   
   stat("/var/geoip/geoipdb.idx", &buf);
   idxsz = buf.st_size/sizeof(struct geoip_index);
   index = (struct geoip_index *)malloc(buf.st_size);

   fread(index, buf.st_size, 1, ixfd);

   for (i = 0; i < idxsz; i++)
      if (cc == index[i].cc)
         break;
   
   if (cc != index[i].cc)
      exit_error(OTHER_PROBLEM,
            "geoip match: sorry, '%c%c' isn't in the database\n", COUNTRY(cc));

   fclose(ixfd);

   if ((dbfd = fopen("/var/geoip/geoipdb.bin", "r")) == NULL) {
      perror("/var/geoip/geoipdb.bin");
      exit_error(OTHER_PROBLEM,
            "geoip match: cannot open geoip's database file");
   }

   fseek(dbfd, index[i].offset, SEEK_SET);
   fread(&db_cc, sizeof(u_int16_t), 1, dbfd);

   if (db_cc != cc)
      exit_error(OTHER_PROBLEM,
            "geoip match: this shouldn't happened, the database might be corrupted, or there's a bug.\n"
            "you should contact maintainers");
            
   fread(&db_nsubnets, sizeof(u_int16_t), 1, dbfd);

   subnets = (struct geoip_subnet*)malloc(db_nsubnets * sizeof(struct geoip_subnet));

   if (!subnets)
      exit_error(OTHER_PROBLEM,
            "geoip match: insufficient memory available");
   
   fread(subnets, db_nsubnets * sizeof(struct geoip_subnet), 1, dbfd);
   
   fclose(dbfd);
   free(index);
   *count = db_nsubnets;
   return subnets;
}
 
static struct geoip_info *
load_geoip_cc(u_int16_t cc)
{
   static struct geoip_info *ginfo;
   ginfo = malloc(sizeof(struct geoip_info));

   if (!ginfo)
      return NULL;
   
   ginfo->subnets = get_country_subnets(cc, &ginfo->count);
   ginfo->cc = cc;
   
   return ginfo;
}

static u_int16_t
check_geoip_cc(char *cc, u_int16_t cc_used[], u_int8_t count)
{
   u_int8_t i;
   u_int16_t cc_int16;

   if (strlen(cc) != COUNTRYCODESZ) /* Country must be 2 chars long according
                                        to the ISO3166 standard */
    exit_error(PARAMETER_PROBLEM,
         "geoip match: invalid country code '%s'", cc);

   // Verification will fail if chars aren't uppercased.
   // Make sure they are..
   for (i = 0; i < COUNTRYCODESZ; i++)
      cc[i] = toupper(cc[i]);

   // Verify for a valid value against the country code list.
   if (binary_search(cc, 0, COUNTRYCOUNT-1) != 0)
   exit_error(PARAMETER_PROBLEM,
         "geoip match: invalid country code '%s'", cc);
 
   /* Convert chars into a single 16 bit integer.
    * FIXME:   This assumes that a country code is
    *          exactly 2 chars long. If this is
    *          going to change someday, this whole
    *          match will need to be rewritten, anyway.
    *                                  - SJ  */
   cc_int16 = (cc[0]<<8) + cc[1];

   // Check for presence of value in cc_used
   for (i = 0; i < count; i++)
      if (cc_int16 == cc_used[i])
         return 0; // Present, skip it!
   
   return cc_int16;
}

/* Based on libipt_multiport.c parsing code. */ 
static u_int8_t
parse_geoip_cc(const char *ccstr, u_int16_t *cc, struct geoip_info **mem)
{
   char *buffer, *cp, *next;
   u_int8_t i, count = 0;
   u_int16_t cctmp;

   buffer = strdup(ccstr);
   if (!buffer) exit_error(OTHER_PROBLEM,
         "geoip match: insufficient memory available");

   for (cp = buffer, i = 0; cp && i < IPT_GEOIP_MAX; cp = next, i++)
   {
      next = strchr(cp, ',');
      if (next) *next++ = '\0';
      
      if ((cctmp = check_geoip_cc(cp, cc, count)) != 0) {
         if ((mem[count++] = load_geoip_cc(cctmp)) == NULL)
            exit_error(OTHER_PROBLEM,
                  "geoip match: insufficient memory available");
         cc[count-1] = cctmp;
         }
   }
   
   if (cp) exit_error(PARAMETER_PROBLEM,
         "geoip match: too many countries specified");
   free(buffer);

   if (count == 0) exit_error(PARAMETER_PROBLEM,
         "geoip match: don't know what happened");
   
   return count;
}

static int 
parse(int c, char **argv, int invert, unsigned int *flags,
                 const struct ipt_entry *entry,
                 unsigned int *nfcache,
                 struct ipt_entry_match **match)
{
   struct ipt_geoip_info *info
      = (struct ipt_geoip_info *)(*match)->data;
  
    switch(c) {
      case '1':
         // Ensure that IPT_GEOIP_SRC *OR* IPT_GEOIP_DST haven't been used yet.
         if (*flags & (IPT_GEOIP_SRC | IPT_GEOIP_DST))
            exit_error(PARAMETER_PROBLEM,
                  "geoip match: only use --source-country *OR* --destination-country once!");
 
         *flags |= IPT_GEOIP_SRC;
         *nfcache |= NFC_IP_SRC;
         break;
         
      case '2':
         // Ensure that IPT_GEOIP_SRC *OR* IPT_GEOIP_DST haven't been used yet.
         if (*flags & (IPT_GEOIP_SRC | IPT_GEOIP_DST))
            exit_error(PARAMETER_PROBLEM,
                  "geoip match: only use --source-country *OR* --destination-country once!");
 
         *flags |= IPT_GEOIP_DST;
         *nfcache |= NFC_IP_DST;
         break;
      
      default:
         return 0;
    }
    
    if (invert)
       *flags |= IPT_GEOIP_INV;
   
    info->count = parse_geoip_cc(argv[optind-1], info->cc, info->mem);
    info->flags = *flags;
    info->refcount = NULL;
    //info->fini = &geoip_free;

    return 1;
}

static void 
final_check(unsigned int flags)
{
   if (!flags)
      exit_error(PARAMETER_PROBLEM,
            "geoip match: missing arguments");
}

static void 
print(const struct ipt_ip *ip,
                  const struct ipt_entry_match *match,
                  int numeric)
{
   const struct ipt_geoip_info *info
      = (const struct ipt_geoip_info *)match->data;
   
   u_int8_t i;
   
   if (info->flags & IPT_GEOIP_SRC)
      printf("Source ");
   else printf("Destination ");
   
   if (info->count > 1)
      printf("countries: ");
   else printf("country: ");
   
   if (info->flags & IPT_GEOIP_INV)
      printf("! ");
      
   for (i = 0; i < info->count; i++)
       printf("%s%c%c", i ? "," : "", COUNTRY(info->cc[i]));
}

static void 
save(const struct ipt_ip *ip,
                 const struct ipt_entry_match *match)
{
   const struct ipt_geoip_info *info
      = (const struct ipt_geoip_info *)match->data;
   u_int8_t i;

   if (info->flags & IPT_GEOIP_INV)
      printf("! ");
 
   if (info->flags & IPT_GEOIP_SRC)
      printf("--source-country ");
   else printf("--destination-country ");
      
   for (i = 0; i < info->count; i++)
      printf("%s%c%c", i ? "," : "", COUNTRY(info->cc[i]));
   
   printf(" ");
}

static struct iptables_match geoip = {
    .name            = "geoip",
    .version         = IPTABLES_VERSION,
    .size            = IPT_ALIGN(sizeof(struct ipt_geoip_info)),
    .userspacesize   = offsetof(struct ipt_geoip_info, mem),
    .help            = &help,
    .init            = &init,
    .parse           = &parse,
    .final_check     = &final_check,
    .print           = &print,
    .save            = &save,
    .extra_opts      = opts
};

void _init(void)
{
   register_match(&geoip);
}


--------------040408020900060408060005
Content-Type: application/x-gzip;
 name="geoip-pomng-20041103-1.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="geoip-pomng-20041103-1.tar.gz"

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
--------------040408020900060408060005--
