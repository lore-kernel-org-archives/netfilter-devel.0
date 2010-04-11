From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: A illogical problem with the tcphdr->syn!
Date: Sun, 11 Apr 2010 16:08:09 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004111601410.15618@obet.zrqbmnf.qr>
References: <m2q28efc0211004110556m6a038e4eja3744246a7bdae24@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: supercodeing35271 supercodeing35271 <supercodeing35271@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57840 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab0DKOIK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Apr 2010 10:08:10 -0400
In-Reply-To: <m2q28efc0211004110556m6a038e4eja3744246a7bdae24@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-04-11 14:56, supercodeing35271 supercodeing35271 wrote:

>Hi,i had written a kernel module with the netfilter.But i found a
>problem when i judged the value of tcphdr->syn.This is the main code:
>
>static unsigned int hook_func_in(unsigned int hooknum,
>		       struct sk_buff *skb,
>		       const struct net_device *in,
>		       const struct net_device *out,
>		       int (*okfn)(struct sk_buff *))
>{
>    struct tcphdr *tcp;
>    struct icmphdr *icmp;
>    struct udphdr *udp;
>    struct iphdr *ip;
>    char msgk_to_userspace[200];
>    char *pointer_mtu;
>    pointer_mtu = &msgk_to_userspace[0];
>
>    if(skb == NULL)
>    {
>	return NF_DROP;
>    }

Pointless check, skb is never NULL.

>    if(ip_hdr(skb))
>    {
>	ip = ip_hdr(skb);
>	
>    }

Pointless check, ip_hdr won't usually return NULL either.

>    else
>    {
>	return NF_DROP;
>    }
>
>    if((skb->dev != NULL) && (in != NULL))
>    {
>	if(skb->dev == in)
>	{

Redundant check. in is the interface.

>	    if(ip->protocol == IPPROTO_TCP)
>	    {
>		tcp = tcp_hdr(skb);
>		
>		
>		if(tcp->syn)

Must use skb_header_pointer to access parts that lie beyond skb->data.

>		{
>		    printk("the syn flag is 1 \n");
>		    /*here,when i send a tcp packet from other machine which had set
>the syn flag by NMAP(command:nmap -sS myIP -p 6000),and i also used
>wireshark to confirm that the packet had set the syn flag,but the
>program didn't print "the syn flag is 1" to
>var/log/message.Otherwise,when i changed the code
>to"if(!(tcp->syn))","the syn flag is 1" could be print.Yes, it's
>opposite!Then i could not thought	of why this happened........	    */
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

