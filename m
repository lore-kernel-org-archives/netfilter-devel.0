From: Philipp =?iso-8859-1?q?G=FChring?= <mailinglists@futureware.at>
Subject: New logging module
Date: Mon, 25 Aug 2003 14:59:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308251459.03014.mailinglists@futureware.at>
Reply-To: pg@futureware.at
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WggS/0Ell+kB286"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_WggS/0Ell+kB286
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I developed a Netfilter module, that collects and logs the traffic of all I=
P=20
addresses of several subnets, and dumps the traffic log regulary in a simil=
ar=20
format as ipt_LOG, so that it can transparently replace the normal logging=
=20
module.

It was developed to enhance the speed of our traffic analysis software, by=
=20
filtering and aggregating the packets directly in the kernel instead of the=
=20
userspace.

The license is GPL.

Many greetings,
Philipp G=FChring





--Boundary-00=_WggS/0Ell+kB286
Content-Type: text/x-csrc;
  charset="us-ascii";
  name="ipt_REGIONET.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="ipt_REGIONET.c"

/*
 * This is a module which is logging the regionet_traffic of IPs of whole subnets.
 */
#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/spinlock.h>
#include <linux/vmalloc.h>
#include <net/icmp.h>
#include <net/udp.h>
#include <net/tcp.h>
#include <linux/netfilter_ipv4/ip_tables.h>

struct in_device;
#include <net/route.h>
#include <linux/netfilter_ipv4/ipt_LOG.h>

#if 1
#define DEBUGP printk
#else
#define DEBUGP(format, args...)
#endif

/* Use lock to serialize, so printks don't overlap */
static spinlock_t regionet_lock = SPIN_LOCK_UNLOCKED;

static u_int32_t regionet_network[10];
static u_int32_t regionet_netmask[10];
static long regionet_netsize[10];
static int *regionet_traffic[10];
static int regionet_networks;
static unsigned int regionet_counter;
static int regionet_traffic1[256*256*4];
static int regionet_traffic2[256*4];
static int regionet_traffic3[32*4];

static unsigned int
ipt_regionet_target(struct sk_buff **pskb,
	       unsigned int hooknum,
	       const struct net_device *in,
	       const struct net_device *out,
	       const void *targinfo,
	       void *userinfo)
{
	struct iphdr *iph = (*pskb)->nh.iph;
	const struct ipt_log_info *loginfo = targinfo;
	char level_string[4] = "< >";


        int i;

        regionet_counter++;
 
        //printk("saddr: %u\n",ntohl(iph->saddr));
        for(i=0;i<regionet_networks;i++)
        {
          if((ntohl(iph->saddr) & regionet_netmask[i])==regionet_network[i])
          {
            //printk("Incoming Traffic from Network %u ...\n",i);
            (regionet_traffic[i])[ntohl(iph->saddr) - regionet_network[i]] += ntohs(iph->tot_len);
          }
          if((ntohl(iph->daddr) & regionet_netmask[i])==regionet_network[i])
          {
            (regionet_traffic[i])[ntohl(iph->daddr) - regionet_network[i]] += ntohs(iph->tot_len);
          }
          if(regionet_counter>10000)
          {
            printk("Neue Traffic Liste:\n");
 
            unsigned int j=0;
            for(j=0;j<regionet_netsize[i];j++)
            {
              if((regionet_traffic[i])[j])
              {
                int myip=regionet_network[i]+j;
                level_string[1] = '0' + (loginfo->level % 8);
                spin_lock_bh(&regionet_lock);
                printk(level_string);
                printk("SRC=%u.%u.%u.%u LEN=%u\n",HIPQUAD(myip),(regionet_traffic[i])[j]);
	        spin_unlock_bh(&regionet_lock);
              }
            }
          }
        }
       
        if(regionet_counter>10000)
        {
          regionet_counter=0;
        }

	return IPT_CONTINUE;
}

static int ipt_regionet_checkentry(const char *tablename,
			      const struct ipt_entry *e,
			      void *targinfo,
			      unsigned int targinfosize,
			      unsigned int hook_mask)
{
	const struct ipt_log_info *loginfo = targinfo;

	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_log_info))) {
		DEBUGP("LOG: targinfosize %u != %u\n",
		       targinfosize, IPT_ALIGN(sizeof(struct ipt_log_info)));
		return 0;
	}

	if (loginfo->level >= 8) {
		DEBUGP("LOG: level %u >= 8\n", loginfo->level);
		return 0;
	}

	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
		DEBUGP("LOG: prefix term %i\n",
		       loginfo->prefix[sizeof(loginfo->prefix)-1]);
		return 0;
	}

	return 1;
}

static struct ipt_target ipt_regionet_reg
= { { NULL, NULL }, "LOG", ipt_regionet_target, ipt_regionet_checkentry, NULL, 
    THIS_MODULE };

static int __init init(void)
{
	regionet_counter=0;
        regionet_networks=0;

#if 1
        regionet_network[regionet_networks]=0xAC1A0000; // 172.26.0.0
        regionet_netmask[regionet_networks]=0xFFFF0000; // 255.255.0.0
        regionet_netsize[regionet_networks]=256*256;
        regionet_traffic[regionet_networks]=regionet_traffic1;
        if(regionet_traffic[regionet_networks]!=NULL)
        {
          memset(regionet_traffic[regionet_networks],0,regionet_netsize[0]*sizeof(int));
          regionet_networks++;
        }
#endif

#if 0
        regionet_network[regionet_networks]=0xC0A80100; // 192.168.1.0
        regionet_netmask[regionet_networks]=0xFFFFFF00; // 255.255.255.0
        regionet_netsize[regionet_networks]=256;
        regionet_traffic[regionet_networks]=regionet_traffic2;
        if(regionet_traffic[regionet_networks]!=NULL)
        {
          memset(regionet_traffic[regionet_networks],0,regionet_netsize[0]*sizeof(int));
          regionet_networks++;
        }
#endif

        regionet_network[regionet_networks]=0xC36ED680; // 195.110.214.128
        regionet_netmask[regionet_networks]=0xFFFFFFE0; // 255.255.255.0
        regionet_netsize[regionet_networks]=32;
        regionet_traffic[regionet_networks]=regionet_traffic3;
        if(regionet_traffic[regionet_networks]!=NULL)
        {
          memset(regionet_traffic[regionet_networks],0,regionet_netsize[0]*sizeof(int));
          regionet_networks++;
        }

      	DEBUGP("REGIONET: Number of monitoring regionet_networks: %u\n", regionet_networks);
	
	if (ipt_register_target(&ipt_regionet_reg))
		return -EINVAL;

	return 0;
}

static void __exit fini(void)
{
	ipt_unregister_target(&ipt_regionet_reg);
}

module_init(init);
module_exit(fini);
MODULE_LICENSE("GPL");


--Boundary-00=_WggS/0Ell+kB286
Content-Type: text/x-makefile;
  charset="us-ascii";
  name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="Makefile"

all: ipt_REGIONET.o

ipt_REGIONET.o: ipt_REGIONET.c
	gcc -D__KERNEL__ -I/usr/src/linux-2.4.20.SuSE/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -Wno-sign-compare -finline-limit=2000 -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=athlon  -DMODULE  -nostdinc -iwithprefix include -DKBUILD_BASENAME=ipt_REGIONET  -c -o ipt_REGIONET.o ipt_REGIONET.c


test:	ipt_REGIONET.o
	/etc/rc.d/SuSEfirewall2_setup stop	
	rmmod ipt_REGIONET || true
	insmod ipt_REGIONET.o
	/etc/rc.d/SuSEfirewall2_setup start
	/etc/rc.d/SuSEfirewall2_final start

--Boundary-00=_WggS/0Ell+kB286--
