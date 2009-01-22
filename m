From: =?KOI8-R?B?68/C2czRztPLycog98zBxMnNydI=?= <kentlinux@yandex.ru>
Subject: Re: Re: TCP-packet with PUSH flag with wrong payload data in LOCAL_OUT
Date: Thu, 22 Jan 2009 16:53:36 +0300
Message-ID: <7031232632416@webmail11.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forwards1.yandex.ru ([77.88.60.125]:39276 "EHLO
	forwards1.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbZAVOAm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:00:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>  kent@lissi.ru
>>    SMTP error from remote mail server after end of data:
>>    host 194.84.136.194 [194.84.136.194]: 550 5.7.1 Message rejected.
>
>Should - have - known.

Oops. It is some troubles in our hoster DNS config. (something in MX records...)
Now I will post from current mail. Sorry.


>>
>>I see in my module 3 handshake packets - they all normal.
>>Then I see first packet with payload - it is TCP-packet with PSH and ACK
>>flags and it is not normal at all.
>
>It could be something in your code (which seem to be absent here).
>
>>In this packet in tcp-data area I MUST see such string:
>>"GET / HTTP/1.1..."
>>or in HEX
>>"4745 5420 2f20 4854 5450 2f31 2e31 ..."
>>BUT I see such data in it:
>>"0200 0100 0100 0000 0100 0000 0000 ....".
>
>Could be TCP options. Payload could be begin in a later packet maybe.
>Or somewhere in your code you have a wrong pointer.
>I don't read glass spheres so...


Sorry. 
There are my sources.
(As I undestood mail-list don't support attachments. Am I write?)

==============================================

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/netdevice.h>
#include <linux/inetdevice.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <net/route.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/spinlock_types.h>
#include <linux/in_route.h>
#include <net/ip.h>
#include <linux/etherdevice.h>
#include <linux/vmalloc.h>


#define SYSLOG_ID "my_fw"
# define IP_PRINTF(addr) ((addr) & 0xff), (((addr) >> 8) & 0xff), (((addr) >> 16) & 0xff), (((addr) >> 24) & 0xff)
#define info(format, arg...)\
		do {\
			printk(KERN_INFO "%s: %s(): " format "\n" , SYSLOG_ID, __FUNCTION__, ## arg);\
		} while (0)


static struct nf_hook_ops nfho;
static struct nf_hook_ops nfho_in;

int ip_packet_from_local_host(struct iphdr *iph)
{
	struct net_device *dev   = NULL;
	struct in_device *in_dev = NULL;
	struct in_ifaddr *ifaddr = NULL;
	
	for (dev = dev_base; dev; dev = dev->next)
	{
		if (!dev->ip_ptr)
		{
			continue;
		}
		in_dev = (struct in_device *)dev->ip_ptr;
		ifaddr = in_dev->ifa_list;
		while (ifaddr)
		{
			if (iph->saddr == ifaddr->ifa_address)
			{
				return 1;
			}
			ifaddr = ifaddr->ifa_next;
		}
	}
	
	return 0;
}

struct net_device* ip_packet_to_local_host(struct iphdr *iph)
{
	struct net_device *dev   = NULL;
	struct in_device *in_dev = NULL;
	struct in_ifaddr *ifaddr = NULL;
	
	for (dev = dev_base; dev; dev = dev->next)
	{
		if (!dev->ip_ptr)
		{
			continue;
		}
		in_dev = (struct in_device *)dev->ip_ptr;
		ifaddr = in_dev->ifa_list;
		while (ifaddr)
		{
			if (iph->daddr == ifaddr->ifa_address)
			{
				return dev;
			}
			ifaddr = ifaddr->ifa_next;
		}
	}
	return NULL;
}

static unsigned int check_packet(struct sk_buff	*skb, short in_out)
{
    if(skb->nh.iph->protocol == IPPROTO_TCP)
    {
	    struct tcphdr	*tcp;
	    char		*tcp_data=NULL;
	    char		tcp_flags[4];
	    unsigned int	tcp_data_off=0;
	    
	    tcp = (struct tcphdr *)((char*)skb->nh.iph + skb->nh.iph->ihl * 4);
	    tcp_data_off = (tcp->doff)*4;
	    tcp_data = (char *)tcp + tcp_data_off;
	    tcp_flags[0]=' ';
	    tcp_flags[1]=' ';
	    tcp_flags[2]=' ';
	    tcp_flags[3]='\0';

	    if(tcp->syn)
		    tcp_flags[0] = 'S';
	    if(tcp->ack)
		    tcp_flags[1] = 'A';
	    if(tcp->psh)
		    tcp_flags[2] = 'P';
	    info("=== HOOK_PACKET: packet src_addr=%u.%u.%u.%u:%u dst_addr=%u.%u.%u.%u:%u [%s] protocol=%u, IN_OUT=%d, DATA_OFF = %u",
			    IP_PRINTF(skb->nh.iph->saddr),ntohs(tcp->source),IP_PRINTF(skb->nh.iph->daddr),ntohs(tcp->dest), 
			    tcp_flags, skb->nh.iph->protocol, in_out, tcp_data_off);
	    if(tcp->psh && ntohs(tcp->dest) == 80)
	    {
		    info("=== HOOK_PACKET: DATA=%02x %02x %02x %02x %02x %02x", tcp_data[0],tcp_data[1],tcp_data[2],tcp_data[3],tcp_data[4],tcp_data[5]);
//		    return NF_DROP;
	    }
    }


    return NF_ACCEPT;
}

unsigned int hook_func(unsigned int hooknum,
                                struct sk_buff **pskb,
                                const struct net_device *in,
                                const struct net_device *out,
                                int (*okfn)(struct sk_buff *))
{
    struct sk_buff * skb = * pskb;
    int ret;
    if(skb == NULL){
	info("HOOK skb==NULL");
	return NF_DROP;
    }	
    ret = check_packet(skb, (short)1); //1 - out
    return(ret);
}

unsigned int hook_func_in(unsigned int hooknum,
                                struct sk_buff **pskb,
                                const struct net_device *in,
                                const struct net_device *out,
                                int (*okfn)(struct sk_buff *))
{
    struct sk_buff * skb = * pskb;
    int ret;
    if(skb == NULL){
	info("HOOK_IN skb==NULL");
	return NF_DROP;
    }	
    if(skb->pkt_type == PACKET_OUTGOING)  
        ret = check_packet(skb, (short)1); //1 - out
    else
	ret = check_packet(skb, (short)0); //0 - in
    return(ret);
}


static int __init fw_init(void)
{
    int ret;

    nfho.hook     	= hook_func;
    nfho.hooknum  	= NF_IP_LOCAL_OUT;
    nfho.pf       	= PF_INET;
    nfho.priority 	= NF_IP_PRI_FIRST;
    
    nfho_in.hook     	= hook_func_in;
    nfho_in.hooknum 	= NF_IP_PRE_ROUTING;
    nfho_in.pf       	= PF_INET;
    nfho_in.priority 	= NF_IP_PRI_FIRST;
  
    nf_register_hook(&nfho);
    nf_register_hook(&nfho_in);

    info("Driver my_fw started");	    
    return 0;
}
        
static void __exit fw_cleanup(void)
{
    nf_unregister_hook(&nfho);
    nf_unregister_hook(&nfho_in);
    info("Driver my_fw stoped");	    
}
MODULE_LICENSE("GPL");
MODULE_AUTHOR("KENTLINUX");
MODULE_DESCRIPTION("KENTLINUX");
module_init(fw_init);
module_exit(fw_cleanup);
==============================================================


And syslog:

====================================
Jan 22 11:35:52 FW_EXT kernel: my_fw: fw_init(): Driver my_fw started
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:41924 dst_addr=192.168.0.132:80 [S  ] protocol=6, IN_OUT=1, DATA_OFF = 40
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:41924 [SA ] protocol=6, IN_OUT=0, DATA_OFF = 40
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:41924 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:41924 dst_addr=192.168.0.132:80 [ AP] protocol=6, IN_OUT=1, DATA_OFF = 32
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: DATA=02 00 01 00 01 00
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:41924 [ A ] protocol=6, IN_OUT=0, DATA_OFF = 32
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:41924 [ AP] protocol=6, IN_OUT=0, DATA_OFF = 32
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:41924 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:41924 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:41924 [ A ] protocol=6, IN_OUT=0, DATA_OFF = 32
Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:41924 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32
Jan 22 11:36:01 FW_EXT kernel: my_fw: fw_cleanup(): Driver my_fw stoped

====================================

