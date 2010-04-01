From: Robert SZABO <mstrfixit@rogers.com>
Subject: Netfilter queueing problems
Date: Thu, 1 Apr 2010 09:58:05 -0700 (PDT)
Message-ID: <137991.40070.qm@web88103.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n10.bullet.re3.yahoo.com ([68.142.237.123]:27599 "HELO
	n10.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754982Ab0DAQ6G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:58:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,


I have built a simple kernel module that listens on the interfaces defined in a bridge (Created using bridge-utils) and when it receives a particular packet in the tcp stream, the hook queues that packet to user space.  

In user space I then modify the payload, swap the source/destination ip addresses and ports, re-calculate the checksums and put it back out using 

     nfq_set_verdict_mark(q_handle , id, NF_ACCEPT, BOOMERANG_NFMARK, datagramSize, datagram);

I then have a hook that is invoked set as the last hook in the NF_IP_FORWARD chaing that checks the netfilter mark value and if correct, immediately, swaps source/destination mac address and the NIC assignments. The idea being that the modified packet is sent back to the client.


Here is the hook and the final packet manipulation:


unsigned int secondary_hook_cb(
    unsigned int hook,
    struct sk_buff **pskb,
    const struct net_device *indev,
    const struct net_device *outdev,
    int (*okfn)(struct sk_buff *))
{
    struct sk_buff *skb;
    skb= *pskb;

    // we skip all interogation and get out of the way
    if (skb && skb->nh.iph)
    {
        switch( (int) ntohl(skb->nfmark))
        {
            case  BOOMERANG_NFMARK:
                if (skb->nh.iph->protocol == IPPROTO_TCP)
                {
                    return swapAndQueuePacket(skb,ntohl(skb->nfmark));
                }
                break;
            default:
                break;
        }
    }
    return NF_ACCEPT;

}

int swapAndQueuePacket(struct sk_buff *skb, int mark)
{
    struct net_device *odev,*idev;
    struct ethhdr *ethdr;
    u_char tmp[6];


    odev = dev_get_by_name(getIngresIf());
    idev = dev_get_by_name(getEgresIf());

    ethdr = (struct ethhdr *)skb->mac.raw;
    if (ethdr != NULL)
    {
        skb->nfmark = htonl(mark);
        skb->dev=odev;
        skb->input_dev=idev;
        skb->pkt_type = PACKET_OTHERHOST;
        skb->protocol = __constant_htons(ETH_P_IP);
        skb->priority = 0;
        skb->csum = skb_checksum (skb, skb->nh.iph->ihl*4, skb->len - skb->nh.iph->ihl * 4, 0);

        memcpy(tmp,ethdr->h_dest,ETH_ALEN);
        memcpy (ethdr->h_dest, ethdr->h_source, ETH_ALEN);
        memcpy (ethdr->h_source, tmp, ETH_ALEN);
    }

    return NF_ACCEPT;
}


This works a treat, however, the issue I am running into is that I can pass hundreds of transactions throught the system and the throughput is high, then for some reason throughput drops to a grinding pace. A few seconds later its as fast a lightning and the whole thing repeats itself.

If I simpy use     nfq_set_verdict(q_handle , id, NF_ACCEPT, 0,NULL) and avoid not call this last hook, I do not see any performance issues, but obviously I do not get the desired result.


Any ideas would be greatly appreciated..


Cheers,

Bob


