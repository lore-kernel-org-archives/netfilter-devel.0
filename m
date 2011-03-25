From: Mark Montague <mark@catseye.org>
Subject: Problem getting IPv6 port numbers
Date: Fri, 25 Mar 2011 07:27:28 -0400
Message-ID: <4D8C7C20.8090500@catseye.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57123 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab1CYL13 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:27:29 -0400
Received: from compute2.internal (compute2.nyi.mail.srv.osa [10.202.2.42])
	by gateway1.messagingengine.com (Postfix) with ESMTP id 2C99220A07
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2011 07:27:29 -0400 (EDT)
Received: from asura.catseye.org (unknown [198.111.179.55])
	by mail.messagingengine.com (Postfix) with ESMTPSA id B8312441D1D
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2011 07:27:28 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  I'm writing a netfilter match extension (xtables-addons 1.33, kernel 
2.6.35, .family=NFPROTO_UNSPEC) that needs to examine the source and 
destination port numbers of all packets.  The following code 
successfully gets the port numbers for IPv4 TCP and UDP packets:

static bool xt_mymatch_mt(const struct sk_buff *skb,
                           struct xt_action_param *par)
{
         const __be16 *pptr;
         __be16 _ports[2];
         int sport = 0;
         int dport = 0;

         if (par->fragoff == 0) {
                 pptr = skb_header_pointer(skb, par->thoff,
                         sizeof(_ports), _ports);
                 if (pptr != NULL) {
                         sport = ntohs(pptr[0]);
                         dport = ntohs(pptr[1]);
                 }
         }
         /* ...remaining code omitted... */
}

However, when I test this with "telnet ::1 1234", it does not work for 
IPv6 TCP packets (I have not tried with IPv6 UDP packets yet).  By 
adding printk() statements, I've determined that par->fragoff is never 0 
for my IPv6 TCP packets -- instead, it is large numbers such as 
33569744, 2164528116, or 2164412871.  However, par->in and par->out are 
both correct.  par->matchinfo, ipv6_hdr(skb)->saddr, and 
ipv6_hdr(skb)->daddr are also all correct.

What am I doing wrong?

Thanks in advance for any help.

--
   Mark Montague
   mark@catseye.org

