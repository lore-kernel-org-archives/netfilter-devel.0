From: "Stanisalv V. Bogatyrev" <s.bogatyrev@kenjitsu.net>
Subject: ACC and port numers
Date: Wed, 26 Nov 2003 12:17:24 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FC46FA4.6060503@kenjitsu.net>
Reply-To: s.bogatyrev@kenjitsu.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090101090405080005050604"
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

This is a multi-part message in MIME format.
--------------090101090405080005050604
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hello, All!
	I need to add port and protocol accounting to ACC module.

http://lists.netfilter.org/pipermail/netfilter-devel/2001-March/000719.html
Original patch:
http://zzz.corg.ru/u/Members/dmitry/iptables-1.2-acc.patch/view

	I added some code, but I get broken port nubers on incoming traffic. 
I'm new in netfilter/iptables programming and can't find a mistake. Help 
me please, what do I need to correct to make it work?

Sources are attached to this letter.

ipacc output:

# 1069835594    1069835643      0       1
## Wed Nov 26 11:33:14 2003
## Wed Nov 26 11:34:03 2003
192.168.10.202 1920 216.180.243.82 20480 6 3 1 1177
216.180.243.82 69 192.168.10.202 15360 6 1 2 180
216.180.243.82 69 192.168.10.202 13312 6 1 2 624
216.180.243.82 69 192.168.10.202 23557 6 1 2 36000
216.180.243.82 69 192.168.10.202 2563 6 1 2 906
192.168.10.202 2176 216.180.243.82 20480 6 3 1 3718
216.180.243.82 69 192.168.10.202 18693 6 1 2 1481
216.180.243.82 69 192.168.10.202 18176 6 1 2 199
192.168.10.202 2432 216.180.243.82 20480 6 3 1 2218
216.180.243.82 69 192.168.10.202 24836 6 1 2 1249
216.180.243.82 69 192.168.10.202 15876 6 1 2 1086
216.180.243.82 69 192.168.10.202 24580 6 1 2 1248
216.180.243.82 69 192.168.10.202 31490 6 1 2 635
216.180.243.82 69 192.168.10.202 6402 6 1 2 537
216.180.243.82 69 192.168.10.202 5889 6 1 2 279
216.180.243.82 69 192.168.10.202 1537 6 1 2 262
216.180.243.82 69 192.168.10.202 13316 6 1 2 1076
216.180.243.82 69 192.168.10.202 25604 6 1 2 2504
216.180.243.82 69 192.168.10.202 22273 6 1 2 471
192.168.10.202 2688 207.171.179.30 20480 6 3 1 814
207.171.179.30 69 192.168.10.202 15360 6 1 2 60
207.171.179.30 69 192.168.10.202 13312 6 1 2 52
207.171.179.30 69 192.168.10.202 23557 6 1 2 1500
207.171.179.30 69 192.168.10.202 1027 6 1 2 900
192.168.10.202 2944 207.171.183.19 20480 6 3 1 886
192.168.10.202 3200 207.171.183.19 20480 6 3 1 784
207.171.183.19 69 192.168.10.202 15360 6 1 2 120
207.171.183.19 69 192.168.10.202 13312 6 1 2 104
207.171.183.19 69 192.168.10.202 23557 6 1 2 4500
207.171.183.19 69 192.168.10.202 30468 6 1 2 1271
207.171.183.19 69 192.168.10.202 15105 6 1 2 315
207.171.183.19 69 192.168.10.202 24324 6 1 2 1119


-- 
Stanislav Bogatyrev
Kenjitsu
mailto: s.bogatyrev@kenjitsu.net

--------------090101090405080005050604
Content-Type: text/plain;
 name="ipacc.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipacc.c"

#include <stdio.h>
#include <errno.h>
#include <time.h>
#include <getopt.h>
#include <arpa/inet.h>
#include <asm/types.h>
#include <linux/netfilter_ipv4/ipt_ACC.h>

static int	fd = -1;
static int	op;
static int	hash_size = 1;
static int	mem_limit = 16;


static void usage(char *msg)
{
	if (msg) fprintf(stderr, "ERROR: %s\n", msg);
	fprintf(stderr,"Usage: ipacc [-LFsm]\n");
	exit(1);
}

static void error(int err,char *msg)
{
	fprintf(stderr," %s %s\n",msg,strerror(err));
	exit(1);
}

inline void dotted(__u32 addr)
{
	unsigned char	*c = (unsigned char *) &addr;
	printf("%d.%d.%d.%d ",c[0],c[1],c[2],c[3]);
}

static void printblock(struct ip_acc_get_block *blk)
{
	int i;
	struct	acc_entry	*e;
	for(i=0;i<ACC_ENTRIES_PER_BLOCK;i++) {
		e= &blk->bl[i];
		if(e->count == 0)
			break;
    		dotted(e->src);
		printf("%d ",e->sprt);
		dotted(e->dst);
		printf("%d ",e->dprt);
		printf("%d ",e->proto);
		printf("%d ",e->hooknum);
		printf("%d %llu\n",e->mark,e->count);
	}
}

static void do_list()
{
	int	i;
	struct ip_acc_get_info	info;
	struct ip_acc_get_block	req;
	int	info_len=sizeof(info);
	int	req_len=sizeof(req);

	if (0 > getsockopt(fd, SOL_IP, SO_IP_ACC_INFO, &info, &info_len))
		error(errno," failed: ");
	printf("# %lu\t%lu\t%llu\t%d\n",info.time_on.tv_sec,
		info.time_off.tv_sec,info.lost,info.blocks);
	printf("## %s",ctime(&info.time_on.tv_sec));
	printf("## %s",ctime(&info.time_off.tv_sec));
	for(i=0;i < info.blocks; i++ ) {
		req.block=i;
		if (0 > getsockopt(fd, SOL_IP, SO_IP_ACC_BLOCK, &req, &req_len))
			error(errno," failed:");
		printblock(&req);
	}
	printf("\n");
}

static void do_flush()
{
	struct ip_acc_set_rq req;
	int reqlen = sizeof(req);

	req.op = op & ( IP_ACC_SET_FLUSH | IP_ACC_SET_HASH | IP_ACC_SET_LIMIT );
	req.hash_size = hash_size;
	req.mem_limit = mem_limit;
	if (0 > setsockopt(fd, SOL_IP, SO_IP_ACC, &req, sizeof(req)) )
		error(errno," failed:");
}


int main(int argc, char **argv)
{
	int	opt;
	fd = socket(AF_INET, SOCK_DGRAM, 0);
	if (fd < 0) 
		error(errno,"cannot get DGRAM socket:");

	op = IP_ACC_SET_NONE;

	while (EOF != (opt=getopt( argc, argv, "hLFs:m:")))
	switch(opt) {
		case 'F':
			op |= IP_ACC_SET_FLUSH;
			break;
		case 'L':
			op |= IP_ACC_GET_LIST;
			break;
		case 's':
			op |= IP_ACC_SET_HASH;
			hash_size=atoi(optarg);
			switch(hash_size) {
				case 1:
				case 4:
				case 16:
					break;
				default:
					usage("hash size should be 1,4 or 16 blocks");
			}
			break;
		case 'm':
			op |= IP_ACC_SET_LIMIT;
			mem_limit=atoi(optarg);
			if( mem_limit < 16 || mem_limit > 1024 )
				usage("memory limit only from 16 to 1024 allowed");
			break;
		case 'h':
			usage(0);
		default:
			usage("bad option");
	}
	if (op == IP_ACC_SET_NONE)
		usage("no operation specified");
	if (op & IP_ACC_SET_FLUSH)
		do_flush();
	if (op & IP_ACC_GET_LIST)
		do_list();
	return 0;
}

--------------090101090405080005050604
Content-Type: text/plain;
 name="ipt_ACC.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_ACC.c"

#include	<linux/module.h>
#include	<linux/skbuff.h>
#include	<linux/ip.h>
#include        <linux/in.h>
#include	<asm/uaccess.h>
#include	<linux/mm.h>
#include	<linux/time.h>

/* Include all protocols we supposed to know headers of */
#include <linux/tcp.h>
#include <linux/udp.h>
#include <linux/icmp.h>

#ifndef CONFIG_NETFILTER
#define CONFIG_NETFILTER
#endif

#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_ACC.h>
#include <linux/netfilter_ipv4/lockhelp.h>

static DECLARE_RWLOCK(acc_lock);

static	struct acc_ctrl		main_table;
static	struct acc_ctrl		back_table;
static	int	hash_size = 4096;
static	int	hash_module = 1021;
static	int	mem_limit = 16;


static void free_table(struct acc_ctrl *table)
{
	struct acc_block	*blk;
	while( (blk=table->heap) ) {
		table->heap=blk->next;
		kfree(blk);
	}
	if(table->hash)
		kfree(table->hash);
	memset(table,0,sizeof(struct acc_ctrl));
}

static void init_table(struct acc_ctrl *tbl)
{
	memset(tbl,0,sizeof(struct acc_ctrl));
	tbl->hash_size=hash_size;
	tbl->hash_module=hash_module;
	if( (tbl->hash=kmalloc(tbl->hash_size,GFP_KERNEL)) == 0 ) {
		printk("ACC: hash allocation failure\n");
	} else
		memset(tbl->hash,0,tbl->hash_size);
	tbl->last_heap = tbl->heap = kmalloc(ACC_HEAP_BLK_SZ,GFP_KERNEL);
	if( tbl->heap != 0) {
		memset(tbl->heap,0,ACC_HEAP_BLK_SZ);
		tbl->blocks_count=1;
		tbl->free_count=ACC_ENTRIES_PER_BLOCK;
	}
}

inline void backup_table(void)
{
	struct acc_ctrl tmp;
	struct	timeval	t;
	free_table(&back_table);
	init_table(&tmp);
	do_gettimeofday(&t);
	WRITE_LOCK(&acc_lock);
	memcpy(&back_table,&main_table,sizeof(struct acc_ctrl));
	memcpy(&main_table,&tmp,sizeof(struct acc_ctrl));
	memcpy(&back_table.time_off,&t,sizeof(struct timeval));
	memcpy(&main_table.time_on,&t,sizeof(struct timeval));
	WRITE_UNLOCK(&acc_lock);
}

inline int add_heap_blk(void)
{
	struct acc_block *blk;
	if( main_table.blocks_count >= mem_limit || (blk=kmalloc(ACC_HEAP_BLK_SZ,GFP_ATOMIC)) == 0)
		return 0;
	memset(blk,0,ACC_HEAP_BLK_SZ);
	if( ! main_table.heap )
		main_table.heap = blk;
	else if( main_table.last_heap )
		main_table.last_heap->next = blk;
	main_table.last_heap = blk;
	// skip  blk->next = NULL because blk is already zeroed
	main_table.free_count = ACC_ENTRIES_PER_BLOCK;
	main_table.blocks_count++;
	return 1;
}

//FIXME: Write a better hash function for use with protoz and ports
inline int hash_func_acc(__u32 src,__u32 dst,__u32 mark)
{
	return (
		( (src % 4073) << 20) + ( (dst % 4079) << 8 ) +
		(mark % 251) ) % main_table.hash_module;
}

inline struct acc_entry *new_entry(__u32 src, __u16 sprt, __u32 dst, __u16 dprt, __u32 mark,__u32 count, __u8 proto, __u8 hooknum)
{
	struct acc_entry        *e;
	if( main_table.free_count == 0 && add_heap_blk() == 0)
		return NULL;
	e = &main_table.last_heap->bl[ACC_ENTRIES_PER_BLOCK-main_table.free_count--];
	e->src=src;
	e->sprt=sprt;
	e->dst=dst;
	e->dprt=dprt;
	e->mark=mark;
	e->count=count;
	e->proto=proto;
	e->hooknum=hooknum;
	// e->next already zeroed by add_heap_blk
	return e;
}

inline __u64 lost(__u32 count) { return main_table.lost += count;}

static __u64 new_packet(__u32 src, __u16 sprt, __u32 dst, __u16 dprt, __u32 mark,__u32 count, __u8 proto, __u8 hooknum)
{
	int	h;
	struct acc_entry	*e;
	if( main_table.hash == 0)
		return lost(count);
	h=hash_func_acc(src,dst,mark);
	for(e = main_table.hash[h]; e ;e=e->next )
		if( e->src == src && e->sprt==sprt && e->dst == dst && e->dprt==dprt && e->mark == mark && e->proto == proto && e->hooknum == hooknum)
				return e->count += count;
		else if( e->next == 0 ) {
			if( (e->next=new_entry(src,sprt, dst, dprt, mark,count,proto,hooknum)) == 0)
				return lost(count);
			return 0;
		}
	if( (main_table.hash[h] = new_entry(src,sprt,dst, dprt,mark,count,proto,hooknum)) == 0)
		return lost(count);
	return 0;
}

static int set_acc_ctl(struct sock *sk, int cmd, void *user, unsigned int len)
{

	struct ip_acc_set_rq req;
	if (!capable(CAP_NET_ADMIN))
		return -EPERM;
	if (cmd != SO_IP_ACC)
		return -EBADF;
	if (len != sizeof(req))
		return -EINVAL;
	if (copy_from_user(&req, user, sizeof(req)) != 0)
		return -EFAULT;
	if ( req.op & IP_ACC_SET_HASH )
		switch ( req.hash_size ) {
			case 1:
				hash_size = 4096;
				hash_module = 1021;
				break;
			case 4:
				hash_size = 16384;
				hash_module = 4093;
				break;
			case 16:
				hash_size = 65536;
				hash_module = 16381;
				break;
			default:
				return -EINVAL;
		}
	if( req.op & IP_ACC_SET_LIMIT ) {
		if( req.mem_limit >= 16 && req.mem_limit <= 1024 )
			mem_limit = req.mem_limit;
		else
			return -EINVAL;
	}
	if( req.op & IP_ACC_SET_FLUSH )
		backup_table();
	return 0;
}

static int get_acc_ctl(struct sock *sk, int cmd, void *user, int *len)
{
	struct acc_block *blk;
	int	nblk;
	struct ip_acc_get_info	info;
	if (!capable(CAP_NET_ADMIN))
		return -EPERM;
	if (cmd == SO_IP_ACC_INFO) {
		if(*len != sizeof(info))
			return -EINVAL;
		info.blocks = back_table.blocks_count;
		memcpy(&info.time_on,&back_table.time_on,sizeof(struct timeval));
		memcpy(&info.time_off,&back_table.time_off,sizeof(struct timeval));
		info.lost = back_table.lost;
		if (copy_to_user(user,&info,sizeof(info)) != 0)
			return -EFAULT;
		return 0;
	}
	else if (cmd == SO_IP_ACC_BLOCK) {
		if(*len != sizeof(struct acc_block))
			return -EINVAL;
		copy_from_user(&nblk,user,sizeof(int));
		if( nblk < 0 || nblk >= back_table.blocks_count )
			return -EINVAL;
		for( blk = back_table.heap; blk ; blk=blk->next,nblk-- ) {
			if( nblk == 0 ) {
				copy_to_user(user,blk,sizeof(struct acc_block));
				return 0;
			}
		}
		return -EINVAL;
	}
	return -EBADF;
}

static unsigned int
target(struct sk_buff **pskb,
       unsigned int hooknum,
       const struct net_device *in,
       const struct net_device *out,
       const void *targinfo,
       void *userinfo)
{ 
	const struct ipt_acc_target_info *accinfo = targinfo;
	struct iphdr *iph = (*pskb)->nh.iph;
	
	struct icmphdr *icmp_hdr;
	//	struct igmphdr *igmp_hdr;
	struct tcphdr *tcp_hdr;
	struct udphdr *udp_hdr;

	__u16 sport=0;
	__u16 dport=0;

	//FIXME: Rewrite this uglu pointers to smart and pretty new one :)
	switch(iph->protocol)
	  {
	  case IPPROTO_ICMP: 
	    icmp_hdr = (*pskb)->h.icmph;
	    sport=icmp_hdr->type;
	    dport=icmp_hdr->code;
	    break;
	  
	  case IPPROTO_IGMP:
	    //FIXME: Add normal IGMP headers processing. ICMP has almost the same, so it works.
	    icmp_hdr = (*pskb)->h.icmph;
	    sport=icmp_hdr->type;
	    dport=icmp_hdr->code;
	    break;

	  case IPPROTO_TCP: 
	    tcp_hdr = (*pskb)->h.th;
	    //We don't do ntohs() here. In userspace we trust. So Don't forget to modify ipacc.c
	
	    sport=tcp_hdr->source;
	    dport=tcp_hdr->dest;	    

	    break;

	  case IPPROTO_UDP: 
	    udp_hdr = (*pskb)->h.uh;
	    sport=udp_hdr->source;
	    dport=udp_hdr->dest;
	    break;

	  default : break; //If we don't know portnumbers for that proto, it's 0 :)

	  }

	
	printk("%d: %d -> %d || %d -> %d \n",hooknum, sport, dport, ntohs(sport), ntohs(dport));
	WRITE_LOCK(&acc_lock);
		new_packet(iph->saddr, sport, iph->daddr, dport ,accinfo->mark,ntohs(iph->tot_len), iph->protocol, hooknum);
	WRITE_UNLOCK(&acc_lock);
	return IPT_CONTINUE;
}

static int
checkentry(const char *tablename,
	   const struct ipt_entry *e,
           void *targinfo,
           unsigned int targinfosize,
           unsigned int hook_mask)
{
	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_acc_target_info))) {
		printk(KERN_WARNING "ACC: targinfosize %u != %Zu\n",
		       targinfosize,
		       IPT_ALIGN(sizeof(struct ipt_acc_target_info)));
		return 0;
	}
	return 1;
}


static struct ipt_target ipt_acc_reg                                           
= { { NULL, NULL }, "ACC", target, checkentry, NULL, THIS_MODULE };            

static struct nf_sockopt_ops so_acc
= { { NULL, NULL }, PF_INET,
    SO_IP_ACC, SO_IP_ACC+1, &set_acc_ctl,
    SO_IP_ACC, SO_IP_ACC+2, &get_acc_ctl,
    0, NULL };


static int __init init(void)
{
	struct	timeval	t;
	if (ipt_register_target(&ipt_acc_reg))
		return -EINVAL;
	if( nf_register_sockopt(&so_acc) ) {
		ipt_unregister_target(&ipt_acc_reg);
		return -EINVAL;
	}
	memset(&back_table,0,sizeof(struct acc_ctrl));
	init_table(&main_table);
	do_gettimeofday(&t);
	memcpy(&main_table.time_on,&t,sizeof(struct timeval));
	return 0;
}

static void __exit fini(void)
{
	free_table(&main_table);
	free_table(&back_table);
	nf_unregister_sockopt(&so_acc);
	ipt_unregister_target(&ipt_acc_reg);
}

module_init(init);
module_exit(fini);

--------------090101090405080005050604
Content-Type: text/plain;
 name="ipt_ACC.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_ACC.h"

#ifndef _IPT_ACC_H_target
#define _IPT_ACC_H_target

#define SO_IP_ACC	82
#define SO_IP_ACC_INFO	SO_IP_ACC
#define SO_IP_ACC_BLOCK	SO_IP_ACC_INFO+1

#define	IP_ACC_SET_NONE		0
#define IP_ACC_SET_FLUSH	1
#define IP_ACC_SET_HASH		2
#define IP_ACC_SET_LIMIT	4
#define IP_ACC_GET_LIST		8

#define		ACC_BLK_SZ	4096
#define		ACC_HASH_SZ	4096
#define		ACC_HEAP_BLK_SZ	4096
#define		ACC_ENTRIES_PER_BLOCK	170
#define		ACC_HASH_MOD	1021


struct acc_entry
{
	__u32	src;
	__u16	sprt;
	__u32	dst;
	__u16	dprt;
	__u8	proto;
	__u32	mark;
	__u64	count;
	__u8	hooknum;
//	char dev[IFNAMSIZ]; // That's how we can add interface support
// 	Netfilter hooks are done similary, but mark is more flexible and doesn't require to write code :)
	struct acc_entry	*next;
};

struct acc_block
{
	struct acc_block	*next;
	int			fill[3];
	struct acc_entry	bl[ACC_ENTRIES_PER_BLOCK];
};

struct acc_ctrl
{
__u32	hash_size;
__u32	hash_module;
__u64	lost;
__u32	blocks_count;
__u32	free_count;
struct	timeval		time_on;
struct	timeval		time_off;
struct acc_entry	**hash;
struct acc_block	*heap;
struct acc_block	*last_heap;
};

struct ip_acc_set_rq {
int	op;
int	hash_size;
int	mem_limit;
};

struct ip_acc_get_info {
	struct	timeval	time_on;
	struct	timeval	time_off;
	__u32	blocks;
	__u64	lost;
};

struct ip_acc_get_block {
	int	block;
	int	fill[3];
	struct acc_entry	bl[170];
};


struct ipt_acc_target_info {
	unsigned long mark;
};


#endif /*_IPT_ACC_H_target*/

--------------090101090405080005050604
Content-Type: text/plain;
 name="libipt_ACC.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libipt_ACC.c"

#include <stdio.h>
#include <asm/types.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_ACC.h>

struct accinfo {
	struct ipt_entry_target t;
	struct ipt_acc_target_info mark;
};

/* Function which prints out usage message. */
static void
help(void)
{
	printf(
"ACC target v%s options:\n"
"  --mark value                   Set mark value\n"
"\n",
IPTABLES_VERSION);
}

static struct option opts[] = {
	{ "mark", 2, 0, '1' },
	{ 0 }
};

/* Initialize the target. */
static void
init(struct ipt_entry_target *t, unsigned int *nfcache)
{
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      struct ipt_entry_target **target)
{
	struct ipt_acc_target_info *accinfo
		= (struct ipt_acc_target_info *)(*target)->data;
	char	*end;
	if( c == '1' ) {
		accinfo->mark = strtoul(optarg, &end, 0);
		if (*end != '\0' || end == optarg)
			exit_error(PARAMETER_PROBLEM, "Bad mark value `%s'", optarg);
		if (*flags)
			exit_error(PARAMETER_PROBLEM,
				"ACC target: Can't specify --mark twice");
		*flags = 1;
		return 1;
	}
	return 0;
}

static void
final_check(unsigned int flags)
{
	if (!flags)
		exit_error(PARAMETER_PROBLEM,
		           "ACC target: Parameter --mark is required");
}

static void
print_mark(unsigned long mark, int numeric)
{
	printf("0x%lx ", mark);
}

/* Prints out the targinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_target *target,
      int numeric)
{
	const struct ipt_acc_target_info *accinfo =
		(const struct ipt_acc_target_info *)target->data;
	printf("MARK set ");
	print_mark(accinfo->mark, numeric);
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void
save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
{
	const struct ipt_acc_target_info *accinfo =
		(const struct ipt_acc_target_info *)target->data;

	printf("--mark 0x%lx ", accinfo->mark);
}

struct iptables_target acc
= { NULL,
    "ACC",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ipt_acc_target_info)),
    IPT_ALIGN(sizeof(struct ipt_acc_target_info)),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void _init(void)
{
	register_target(&acc);
}

--------------090101090405080005050604--
