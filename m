From: Thomas Mader <thezema@gmail.com>
Subject: switch from ip_conntrack to nf_conntrack
Date: Wed, 21 Feb 2007 08:58:35 +0100
Message-ID: <20070221085835.173c691b@Golgotha>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_wj8P8J/MbGDPuJY.m/U+Xpp"
To: netfilter-devel@lists.netfilter.org
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

--MP_wj8P8J/MbGDPuJY.m/U+Xpp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello everybody,

we wrote a kernelspace module which uses the now deprecated
ip_conntrack API and we are trying to switch to the new nf_conntrack
but this seems to be a little bit more problematic than we thought
first.
What we want is to build a nf_conntrack_tuple to get the hash for an
existing connection and finally the id of the connection.
Everything worked fine with the old ip_conntrack stuff but now we don't
get any matching tuples any more.
We also managed to find out that /proc/net/nf_conntrack only has
entries when we load nf_conntrack_ipv4 before, but even if we load it,
the problem is not solved by that.
Maybe someone can help us with this, I will attach the code of our
module for better clarification.

thanks and best regards,
Thomas
--MP_wj8P8J/MbGDPuJY.m/U+Xpp
Content-Type: text/x-csrc; name=ipt_piggyback.c
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ipt_piggyback.c

/*
 * ipt_piggyback.c
 * detects bursts and calculates the round trip time by using ICMP packets
 *
 * Copyright (C) 2006  Helmut Duregger <helmutduregger@gmail.com>
 * Copyright (C) 2006  Thomas Mader <thezema@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/in.h>
#include <linux/udp.h>
#include <linux/icmp.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/time.h>
#include <linux/proc_fs.h>

#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_piggyback.h>

#include <net/ip.h>
#include <net/icmp.h>
#include <net/sock.h>

#include <net/netfilter/nf_conntrack.h>
#include <net/netfilter/nf_conntrack_core.h>
#include <net/netfilter/nf_conntrack_tuple.h>
#include <net/netfilter/nf_conntrack_l3proto.h>
#include <net/netfilter/nf_conntrack_ecache.h>

#include <asm/div64.h>

/* struct holding information about the data streams we watch */
struct ipt_pbc {

	unsigned int id;
	u_int32_t src_ip, dst_ip;        /* src and dst address of this stream */
	u_int16_t src_port, dst_port;    /* src and dst port of this stream */

	int blength;                     /* current burst length for this id */

	struct timespec tstamp;
	struct timespec sum;             /* sum of time differences */

	struct list_head elem;

	int echo_request_count;          /* number of ICMP echo requests sent */
	int echo_reply_count;            /* number of ICMP echo replies received */
};

/* list head of all our stream information structs */
static LIST_HEAD(list); 
/* temporal threshold that two successive packets
 * need to fall short of to add 1 to the blength of
 * that stream
 */          
static struct timespec threshold = { 1, 0 };
static unsigned int burst_length = 5;                             
                                      
static void set_normalized_timespec2(struct timespec *ts, time_t sec, long nsec)
{
        while (nsec >= NSEC_PER_SEC) {
                nsec -= NSEC_PER_SEC;
                ++sec;
        }
        while (nsec < 0) {
                nsec += NSEC_PER_SEC;
                --sec;
        }
        ts->tv_sec = sec;
        ts->tv_nsec = nsec;
}                                      
                                      

/*
 * from R. Stevens's Network Programming
 * http://www.koders.com/c/fid257CD7A223E72DDA44DBDD4939BC87F3AEE2098C.aspx?s=cksum
 * NOTE: Some checksum algorithms only work on an even number of bytes.
 *       We have an even number here, so this is not too important.
 */
static __u16 in_cksum(__u16 *buf, int nbytes)
{
	__u32 sum;
	__u16 oddbyte;

	sum = 0;
	while (nbytes > 1) {
		sum += *buf++;
		nbytes -= 2;
	}

	if (nbytes == 1) {
		oddbyte = 0;
		*((__u16 *) &oddbyte) = *(__u16 *) buf;
		sum += oddbyte;
	}

	sum = (sum >> 16) + (sum & 0xffff);
	sum += (sum >> 16);

	return (__u16) ~sum;
}


/* begin -- from iputils_ping tool but heavily modified
 *
 * Our ICMP part consists of the 8 bytes ICMP header plus
 * 2 long int values from the struct timespec (16 bytes)
 * which makes 24 bytes in total for the ICMP header + data.
 */
#define DATA_LEN 24

static struct {
	struct cmsghdr cm;
	struct in_pktinfo ipi;
} cmsg = { { sizeof(struct cmsghdr) + sizeof(struct in_pktinfo),
             SOL_IP, IP_PKTINFO }, { 0, } };
static u_char              outpack[DATA_LEN];
static struct socket       *sock;
static int                 cmsg_len = sizeof(cmsg);
static struct sockaddr_in  source;
static struct sockaddr_in  destination;

static int send_probe(u_int32_t target, unsigned int id)
{	
	static struct iovec   iov = {outpack, 0};
	static struct msghdr  m = { &destination, sizeof(destination), &iov, 1,
	                            &cmsg, 0, 0 };
	struct icmphdr      *icp;
	struct timespec     ts;

	memset(&outpack, 0, DATA_LEN);

	if (!sock) {
		printk(KERN_ERR "ipt_piggyback: ICMP socket is NULL!\n");
		return -1;
	}

	memset((char *)&destination,0, sizeof(destination));
	destination.sin_family = AF_INET;
	destination.sin_addr.s_addr = target;
	
	icp = (struct icmphdr *)outpack;
	icp->type = ICMP_ECHO;
	icp->code = 0;
	icp->checksum = 0;
	icp->un.echo.sequence = 0;
	icp->un.echo.id = id;
	
	/* copy current time to data of packet */
	
	getnstimeofday(&ts);
	printk(KERN_DEBUG "ipt_piggyback: [%li.%.9li] writing tstamp to ICMP echo request.\n",
	       ts.tv_sec, ts.tv_nsec);
	memcpy(icp+1, &ts, sizeof(struct timespec));

	/* compute ICMP checksum here */
	icp->checksum = in_cksum((u_short *)icp, DATA_LEN);

	m.msg_controllen = cmsg_len;
	iov.iov_len = DATA_LEN;
	


	
	return kernel_sendmsg(sock, &m, (struct kvec*)&iov, 1, DATA_LEN);

}
/* end -- from iputils_ping tool but heavily modified */



static void deal_with_icmp(const struct sk_buff *skb) {

	struct timespec  incoming_time, current_time, diff;
	u_int16_t  id;
	u_char     type;
	u_char     code;

	// TODO check if ICMP reply is really one of ours (random key?)

	/* NOTE: we are using skb_copy_bits instead of direct pointer
	 *       reference here because that returned totally random
	 *       values when testing.
	 */
	 
	/* check if ICMP packet is an echo reply */
	skb_copy_bits(skb, sizeof(struct iphdr), &type, 1);
	skb_copy_bits(skb, sizeof(struct iphdr)+1, &code, 1);
	if ( type || code ) {
		return;
	}

	/* retrieve time from ICMP data */
	memset(&incoming_time, 0, sizeof(struct timespec)); 
	skb_copy_bits(skb, sizeof(struct iphdr)+sizeof(struct icmphdr),
	              &incoming_time, sizeof(struct timespec));

	
	/* retrieve id from ICMP header */
	skb_copy_bits(skb, sizeof(struct iphdr)+4, &id, 2);

	/* compute round-trip-time */
	getnstimeofday(&current_time);
	set_normalized_timespec2(&diff, current_time.tv_sec - incoming_time.tv_sec,
	                                current_time.tv_nsec - incoming_time.tv_nsec);

	/* check if we have an entry with this id and add echo reply and RTT */
	if(!list_empty(&list)) {
		struct ipt_pbc *p;
		list_for_each_entry(p, &list, elem) {
			
			if( id == p->id) {
				p->echo_reply_count++;
				set_normalized_timespec2(&p->sum, p->sum.tv_sec + diff.tv_sec,
				                         p->sum.tv_nsec + diff.tv_nsec);
				break;
			}
		}
	}
}



static int find_id_set_values_send_icmp(struct timespec time, unsigned int id,
                                        struct nf_conntrack_tuple tuple)
{
	int found_id = 0;

	if(!list_empty(&list)) {
		struct ipt_pbc *p;

		list_for_each_entry(p, &list, elem) {
			/* found the id */
			if (id == p->id) {
				struct timespec diff;
				
				found_id = 1;
				set_normalized_timespec2(&diff,
				                         time.tv_sec - p->tstamp.tv_sec,
				                         time.tv_nsec - p->tstamp.tv_nsec);
				
				/* diff > threshold */
				if ( timespec_compare(&diff, &threshold) > 0 ) {
					if ( p->blength > 0 ) {
						p->blength = 0;
					}
				}

				/* the burst reaches the max burst length */
				if(p->blength >= burst_length) {

					printk(KERN_DEBUG "ipt_piggyback: Sending ICMP echo request.\n");
					if (send_probe(tuple.dst.u3.ip, p->id) < 0) {
						printk(KERN_WARNING "ipt_piggyback: Failed to send ICMP echo request.\n");
					} else {
						p->echo_request_count++;
					}
					p->blength = 0;
				}				
								
				/* diff <= threshold */
				if ( timespec_compare(&diff, &threshold) <= 0 ) {
					p->blength++;
				}

				p->tstamp = time;

				printk(KERN_DEBUG "ipt_piggyback: new tstamp added to already existing id %d.\n", p->id);
				break;
			}
		}
	}
	return found_id;	
}



static int allocate_add_pbc(unsigned int id, struct timespec time,
                            struct nf_conntrack_tuple tuple)
{
	struct ipt_pbc* new = (struct ipt_pbc*)kmalloc(sizeof(struct ipt_pbc),
	                                               GFP_ATOMIC);
	
	if(!new) {
		return -1;
	}
	
	new->id = id;
	INIT_LIST_HEAD(&new->elem);
	list_add_tail(&new->elem, &list);
	
	new->tstamp = time;
	new->sum.tv_sec = 0;
	new->sum.tv_nsec = 0;
	new->blength = 0;
	new->echo_request_count = 0;
	new->echo_reply_count = 0;
	new->src_ip = tuple.src.u3.ip;
	new->src_port = tuple.src.u.udp.port;
	new->dst_ip = tuple.dst.u3.ip;
	new->dst_port = tuple.dst.u.udp.port;
	return 0;
}


static int match(const struct sk_buff     *skb,
                 const struct net_device  *in,
                 const struct net_device  *out,
                 const struct xt_match    *match,
                 const void               *matchinfo,
                 int                      offset,
                 unsigned int             protoff,
                 int                      *hotdrop)
{
	struct nf_conntrack_tuple       tuple;
	struct nf_conntrack_tuple_hash  *h = NULL;
	struct nf_conntrack_l3proto     *proto = NULL;
	struct timeval                  stamp;
	struct timespec                 time;
	struct nf_conn                  *ipct = NULL;

	/* Skip protocols we do not deal with */
	if (skb->nh.iph->protocol != IPPROTO_UDP
	    && skb->nh.iph->protocol != IPPROTO_ICMP)
	{
		return 0;
	/* Deal with ICMP */
	} else if (skb->nh.iph->protocol == IPPROTO_ICMP) {
		deal_with_icmp(skb);
		return 0;
	}

	/*
	 * Deal with UDP packets
	 */

	/* if timestamp is not set, set it */
    if (skb->tstamp.off_sec == 0) {
      	__net_timestamp((struct sk_buff *)skb);
	}

	/* retrieve the time stamp from the sk_buff */
	skb_get_timestamp(skb, &stamp);
	time.tv_sec = stamp.tv_sec;
	time.tv_nsec = stamp.tv_usec * NSEC_PER_USEC;
	
	/**
     *     A conntrack entry consists of an ip_conntrack struct that
     *     has a tuplehash array with 2 tuplehash entries corresponding
     *     to the directions. Each tuplehash entry has a tuple which
     *     makes up the info for this connection.
	 *
     *     ip_conntrack--ip_conntrack_tuple_hash--ip_conntrack_tuple
     *                 `-ip_conntrack_tuple_hash--ip_conntrack_tuple
	 *
	 *     We now create a tuple for this packet and then search for an
	 *     entry in conntrack that has the same tuple, which is unique for
	 *     a connection. We synchronize our connection list with that of
	 *     conntrack and use the id as unique identifier.
     */

	proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
	if (!proto) {
		printk(KERN_WARNING "ipt_piggyback: Could not find the protocol for this sk_buff.\n");
	} else {

		/* create a ip_conntrack_tuple for this packet */
		struct {
			struct udphdr udp;
			struct iphdr ip;
		}_in, *inside;
		
		int offset1 = skb->nh.iph->ihl*4 + sizeof(struct udphdr);
		int offset2 = offset1 + skb->nh.iph->ihl*4;	
		inside = skb_header_pointer(skb, skb->nh.iph->ihl*4, sizeof(_in), &_in);

		if (!nf_ct_get_tuple(skb, offset1, offset2,
		                     (u_int16_t)AF_INET, inside->ip.protocol/*IPPROTO_UDP*/, &tuple,
				     proto, nf_ct_l4proto_find_get((u_int16_t)PF_INET, inside->ip.protocol)/*&proto4*/)) {
		
			printk(KERN_WARNING "ipt_piggyback: Could not get a ip_conntrack_tuple for this packet.\n");

		} else {

			/*
			 *   Get the ip_conntrack_tuple_hash for this tuple.
			 *   NOTE: This increases the usage count for the conntrack of this
			 *         tuple hash if the tuple hash was found (not NULL).
			 *         The usage count must be zero for the conntrack to be
			 *         deleted on timeout though.
			 */
			h = nf_conntrack_find_get(&tuple, NULL);

			if (!h) {
				printk(KERN_WARNING "ipt_piggyback: Could not find the ip_conntrack_tuple_hash for this ip_conntrack_tuple.\n");
			} else {
				/* get the ip_conntrack for this tuplehash */
				ipct = nf_ct_tuplehash_to_ctrack(h);
				
				if (!ipct) {
					printk(KERN_WARNING "ipt_piggyback: Could not find the ip_conntrack for this ip_conntrack_tuple_hash.\n");
				} else {
					int found_id;
			
					/* search our list of connections for existing connection with this id 
					 * and send ICMP if necessary
					 */
					found_id = find_id_set_values_send_icmp(time, ipct->id, tuple);

					/* create a new connection if not found */
					if(!found_id) {
						if (allocate_add_pbc(ipct->id, time, tuple) < 0)
						{
							printk(KERN_WARNING "ipt_piggyback: Could not create new connection entry for id %d.\n", ipct->id);
						} else {
							printk(KERN_DEBUG "ipt_piggyback: New tstamp added to new created id %d.\n", ipct->id);
						}
					}
				}
				/* decrease the usage count for this conntrack
				 * because we don't need it any longer
				 */
				nf_ct_put(ipct);
			}
		}
	}

   return 0;
}


/*
static int piggyback_checkentry(const char *tablename,
                                const void *ip,
                                const struct xt_match *match,
                                void *matchinfo,
                                unsigned int matchsize,
                                unsigned int hook_mask)
{
	if (matchsize != IPT_ALIGN(sizeof(struct ipt_piggyback_info))) {
		printk(KERN_ERR "ipt_piggyback: Matchsize differs! Have you forgotten to recompile me? Aborting.\n");
		return 0;
	}
	

	printk(KERN_INFO "ipt_piggyback: Registered with hook mask 0x%x into the %s table.\n",
	       hook_mask, tablename);
	return 1;
}
*/ //TODO

static struct ipt_match ipt_piggyback_match = {
	.list       = { NULL, NULL },
	.name       = "piggyback",
	.match      = match,
	.checkentry	= NULL, // piggyback_checkentry,
	.destroy    = NULL,
	.me         = THIS_MODULE,
	.matchsize  = sizeof(struct ipt_piggyback_info)
};



static int piggyback_conntrack_event(struct notifier_block *this,
                                     unsigned long events,
                                     void *ptr)
{
	struct nf_conn *ct = (struct nf_conn *)ptr;

	if (events & IPCT_DESTROY) {
		struct ipt_pbc *p;

		if(!list_empty(&list)) {
			list_for_each_entry(p, &list, elem) {
				if (ct->id == p->id) {
					list_del(&p->elem);
					kfree(p);
					printk(KERN_DEBUG "ipt_piggyback: Connection %d was deleted from list.\n", ct->id);
					break;
				}
			}
		}
	}

	return 0;
}



#ifdef CONFIG_PROC_FS
static int show_piggyback(char* buffer, char** start,
                          off_t offset, int length)
{
	int size;
	s64 tmp;
	unsigned long mod;
	struct ipt_pbc *p = NULL;

	memset(buffer, 0, length);

	if(!list_empty(&list)) {
		list_for_each_entry(p, &list, elem) {
			tmp = timespec_to_ns(&p->sum);
			/* mod is remainder and the result is in tmp */
			if(p->echo_reply_count > 0)
				mod = do_div(tmp, p->echo_reply_count);
			else
				tmp = 0;

			sprintf(buffer,
			        "%s[%d] %u.%u.%u.%u:%hu -> %u.%u.%u.%u:%hu reqs:%d reps:%d mean:%lldns\n",
			        buffer,
			        p->id,
			        NIPQUAD(p->src_ip), ntohs(p->src_port),
			        NIPQUAD(p->dst_ip), ntohs(p->dst_port),
			        p->echo_request_count,
			        p->echo_reply_count,
			        tmp);
		}
	}
	size = sprintf(buffer, "%s\n", buffer);
	*start = buffer + offset;
	size -= offset;
	return (size > length) ? length : (size > 0) ? size : 0;
}



static int show_piggyback_threshold(char* buffer, char** start,
                                    off_t offset, int length)
{
	int size;
	
	size = sprintf(buffer, "threshold (in nanoseconds): %lu\n",
	               threshold.tv_sec*NSEC_PER_SEC + threshold.tv_nsec);
	*start = buffer + offset;
	size -= offset;
	return (size > length) ? length : (size > 0) ? size : 0;
}



static int show_piggyback_burst_length(char* buffer, char** start,
                                       off_t offset, int length)
{
	int size;
	
	size = sprintf(buffer, "burst_length: %u\n", burst_length);
	*start = buffer + offset;
	size -= offset;
	return (size > length) ? length : (size > 0) ? size : 0;
}



static int write_piggyback_threshold(struct file *file, const char *buffer,
                                     unsigned long count, void *data)
{
	long val = 0;
	char buf[21];  /* expecting at most 19 digits (signed long) + '-' + '\n' */
	char *endp;

	if (count > sizeof(buf)) {
		return -EINVAL;
	}
	if (copy_from_user(buf, buffer, count)) {
		return -EFAULT;
	}
	val = simple_strtol(buf, &endp, 10);
	if (*endp != '\n') {
		return -EINVAL;
	}
	if (val <= 0) {
		return -EINVAL;
	}
	set_normalized_timespec2(&threshold, 0, val); 
	return count;
}



static int write_piggyback_burst_length(struct file *file, const char *buffer,
                                        unsigned long count, void *data)
{
	unsigned int val = 0;
	char buf[11];  /* expecting at most 10 digits + '\n' */
	char *endp;

	if (count > sizeof(buf)) {
		return -EINVAL;
	}
	if (copy_from_user(buf, buffer, count)) {
		return -EFAULT;
	}
	val = (unsigned int)simple_strtoul(buf, &endp, 10);
	if (*endp != '\n') {
		return -EINVAL;
	}
	if (val == 0) {
		return -EINVAL;
	}
	burst_length = val;
	return count;
}
#endif /* CONFIG_PROC_FS */



static struct notifier_block ctnl_notifier = { 
	.notifier_call = piggyback_conntrack_event,
	.next = NULL,
	.priority = 1
}; 



static int __init init(void) {
	int ret, error;
#ifdef CONFIG_PROC_FS
	/* prepare proc entries */
	struct proc_dir_entry* proc_piggyback;
	struct proc_dir_entry* proc_piggyback_t;
	struct proc_dir_entry* proc_piggyback_b;

	proc_piggyback = create_proc_info_entry("net/ipt_piggyback",
	                                        0, 0, show_piggyback);
	if (!proc_piggyback) {
		printk(KERN_ERR "ipt_piggyback: Cannot create /proc/net/ipt_piggyback!\n");
		goto err_proc_piggyback;
	}
	
	proc_piggyback_t = create_proc_info_entry("net/ipt_piggyback_threshold",
	                                          0, 0, show_piggyback_threshold);
	if (!proc_piggyback_t) {
		printk(KERN_ERR "ipt_piggyback: Cannot create /proc/net/ipt_piggyback_threshold!\n");
		goto err_proc_threshold;
	}

	proc_piggyback_b = create_proc_info_entry("net/ipt_piggyback_burst_length",
	                                          0, 0, show_piggyback_burst_length);
	if (!proc_piggyback_b) {
		printk(KERN_ERR "ipt_piggyback: Cannot create /proc/net/ipt_piggyback_burst_length!\n");
		goto err_proc_burst_length;
	}
	
	proc_piggyback_t->write_proc = write_piggyback_threshold;
	proc_piggyback_b->write_proc = write_piggyback_burst_length;
#endif /* CONFIG_PROC_FS */
		
	/* this module needs conntrack to be loaded */
	need_conntrack();

	/* register a notifier so conntrack tells us if a connection is removed */
	ret = nf_conntrack_register_notifier(&ctnl_notifier);
	if (ret) {
		printk(KERN_ERR "ipt_piggyback: Cannot register conntrack notifier!\n");
		goto err_unreg_notifier;
	}
	
	/* create and bind socket for sending ICMP echo requests */
	error = sock_create_kern(PF_INET, SOCK_RAW, IPPROTO_ICMP, &sock);
	if (error) {
		printk(KERN_ERR "ipt_piggyback: Could not create socket!\n");
		goto err_sock;
	}
	memset(&source, 0, sizeof(source));
	source.sin_family = AF_INET;
	source.sin_addr.s_addr = INADDR_ANY;

	error = sock->ops->bind(sock, (struct sockaddr*)&source,
	                        sizeof(struct sockaddr_in));
	if (error) {
		printk(KERN_ERR "ipt_piggyback: Could not bind socket!\n");
		goto err_bind;
	}

	ret = ipt_register_match(&ipt_piggyback_match);
	if (ret) {
		printk(KERN_ERR "ipt_piggyback: Error registering match module!\n");
		goto err_match;
	}
	
	return ret;
	
err_match:
err_bind:
	sock_release(sock);
err_sock:
err_unreg_notifier:
	nf_conntrack_unregister_notifier(&ctnl_notifier);
#ifdef CONFIG_PROC_FS	
	remove_proc_entry("net/ipt_piggyback_burst_length", 0);
err_proc_burst_length:
	remove_proc_entry("net/ipt_piggyback_threshold", 0);
err_proc_threshold:
	remove_proc_entry("net/ipt_piggyback", 0);
err_proc_piggyback:
#endif /* CONFIG_PROC_FS */
	return -EINVAL;
}



static void __exit fini(void) {
	struct ipt_pbc *p, *n;
	
	/* clean up memory */
	list_for_each_entry_safe(p, n, &list, elem) {
		kfree(p);
	}

#ifdef CONFIG_PROC_FS
	remove_proc_entry("net/ipt_piggyback_burst_length", 0);	
	remove_proc_entry("net/ipt_piggyback_threshold", 0);
	remove_proc_entry("net/ipt_piggyback", 0);
#endif /* CONFIG_PROC_FS */

	if (sock) {
		sock_release(sock);
	}

	nf_conntrack_unregister_notifier(&ctnl_notifier);
	ipt_unregister_match(&ipt_piggyback_match);
	
	printk(KERN_INFO "ipt_piggyback: Module removed.\n");
}

module_init(init);
module_exit(fini);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Helmut Duregger && Thomas Mader");
MODULE_DESCRIPTION("iptables Burst-PiggyBack match module");

--MP_wj8P8J/MbGDPuJY.m/U+Xpp--
