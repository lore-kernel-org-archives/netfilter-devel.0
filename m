From: Robert SZABO <mstrfixit@rogers.com>
Subject: NF_IP_POST ROUTING - Send packet back out on same interface it came in on
Date: Tue, 16 Mar 2010 12:10:03 -0700 (PDT)
Message-ID: <331511.32921.qm@web88108.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n9.bullet.mail.ac4.yahoo.com ([76.13.13.237]:29250 "HELO
	n9.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751136Ab0CPTKK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:10:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Hi all,

I am working on a kernel module that would allow me to send a packet
back out on the interface it came in on. (i.e. a simple heartbeat
response, where I have no control over the server as its not mine
to play with.



I have currently configured a bridge using bridge-utils for eth0 and
eth1 called br0.

I then created a netfilter kernel module with 2 hooks, one for
NF_IP_FORWARD which intercepts the packet on the bridge and
queues it, and the second one for NF_IP_POST_ROUTING to handle
the altered payload.


A user space program manipulates the queued packets and rebuilds
the ip and tcp sections including the checksum calculations,
ip address and port manipulation and  then passes it back in
the verdict.


The post routing hook then needs to detect that packet and send
it back on the same interface the original request it was sent on.
I have a simple routine that I was hoping would work to alter the
mac addresses and input/output devices and put the response back
on the queue but it fails to show up in tcpdump.


int swapAndQueuePacket(struct sk_buff *skb)
{
    u_char tmp[6];
    struct net_device *odev,*idev;
    struct ethhdr *ethdr;
    int rc = NOT_OK;


    odev = dev_get_by_name(getIngresIf());
    idev = dev_get_by_name(getEgresIf());

    ethdr = (struct ethhdr *)skb->mac.raw;
    if (ethdr != NULL)
        goto swap_finish;


 skb->dev=odev;
    skb->input_dev=idev;
    skb->pkt_type = PACKET_OTHERHOST;
    skb->protocol = __constant_htons(ETH_P_IP);
    skb->priority = 0;
    skb->csum = skb_checksum (skb,
 skb->nh.iph->ihl*4, skb->len - skb->nh.iph->ihl * 4, 0);

    memcpy(tmp,ethdr->h_dest,ETH_ALEN);
    memcpy (ethdr->h_dest, ethdr->h_source, ETH_ALEN);
    memcpy (ethdr->h_source, tmp, ETH_ALEN);
    if (0 > dev_queue_xmit(skb)) goto swap_out;
    goto swap_finish;

swap_out:
  rc = OK;

swap_finish:
    return rc;
}

Note: I am leery to rebuild the Ethernet header as I may have many
QinQ vlan tags to consider.

The code that engineers the IP/TCP payload is sound as that code
I have tested in my other bridge implementation which was
completely done in user space. Bridge in User Space is incredibly slow..
thus the reason for keeping the
 bridge contained at kernel level.

Any help/pointers is greatly appreciated.

