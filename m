From: supercodeing35271 supercodeing35271 <supercodeing35271@gmail.com>
Subject: A illogical problem with the tcphdr->syn!
Date: Sun, 11 Apr 2010 20:56:40 +0800
Message-ID: <m2q28efc0211004110556m6a038e4eja3744246a7bdae24@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:56121 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0DKM4l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Apr 2010 08:56:41 -0400
Received: by iwn35 with SMTP id 35so337549iwn.21
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Apr 2010 05:56:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,i had written a kernel module with the netfilter.But i found a
problem when i judged the value of tcphdr->syn.This is the main code:

static unsigned int hook_func_in(unsigned int hooknum,
		       struct sk_buff *skb,
		       const struct net_device *in,
		       const struct net_device *out,
		       int (*okfn)(struct sk_buff *))
{
    struct tcphdr *tcp;
    struct icmphdr *icmp;
    struct udphdr *udp;
    struct iphdr *ip;
    char msgk_to_userspace[200];
    char *pointer_mtu;
    pointer_mtu = &msgk_to_userspace[0];

    if(skb == NULL)
    {
	return NF_DROP;
    }
    if(ip_hdr(skb))
    {
	ip = ip_hdr(skb);
	
    }
    else
    {
	return NF_DROP;
    }

    if((skb->dev != NULL) && (in != NULL))
    {
	if(skb->dev == in)
	{
	
	    if(ip->protocol == IPPROTO_TCP)
	    {
		tcp = tcp_hdr(skb);
		
		
		if(tcp->syn)
		{
		    printk("the syn flag is 1 \n");
		    /*here,when i send a tcp packet from other machine which had set
the syn flag by NMAP(command:nmap -sS myIP -p 6000),and i also used
wireshark to confirm that the packet had set the syn flag,but the
program didn't print "the syn flag is 1" to
var/log/message.Otherwise,when i changed the code
to"if(!(tcp->syn))","the syn flag is 1" could be print.Yes, it's
opposite!Then i could not thought	of why this happened........	    */
