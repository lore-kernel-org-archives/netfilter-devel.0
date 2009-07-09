From: Luca Pesce <pesce.luca@gmail.com>
Subject: xt_TCPMSS target dropping SYN packets with data: suggested mod
Date: Thu, 9 Jul 2009 15:41:01 +0200
Message-ID: <873dce860907090641n31254e30g48886aefbbc6474e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:44727 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760070AbZGINlD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:41:03 -0400
Received: by bwz25 with SMTP id 25so175975bwz.37
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jul 2009 06:41:01 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
   I have a question and a possible patch/mod for target TCPMSS (xt_TCPMSS.c).
At the very beginning of function tcpmss_mangle_packet(), the skb containing the
TCP SYN packet is checked to see if it is containing data (on a side note, SYN
with data is quite unusual...); if so, the packet is drastically dropped.
The reason is explained in RR's comment to the code, I am copy/pasting the
beginning of this function with the length check at the bottom of this mail.
RR says that we cannot change MSS on a packet which is already carrying data
(it would be too late): could we relax this check, seeing if the tcp payload is
less than the MSS we are about to set?
Something like:

if (tcplen > info->mss) {
      if (net_ratelimit())
         printk(KERN_ERR "xt_TCPMSS: bad length (%u bytes)\n",
                (*pskb)->len);
      return -1;
}

With such a mod, MSS clamping would happen even for TCP SYN with data
if the data
length (instead of dropping the packet) is not exceeding the MSS we want to set.
Thanks and regards,
Luca Pesce



static int
tcpmss_mangle_packet(struct sk_buff **pskb,
           const struct xt_tcpmss_info *info,
           unsigned int tcphoff,
           unsigned int minlen)
{
   struct tcphdr *tcph;
   unsigned int tcplen, i;
   __be16 oldval;
   u16 newmss;
   u8 *opt;

   if (!skb_make_writable(pskb, (*pskb)->len))
      return -1;

   tcplen = (*pskb)->len - tcphoff;
   tcph = (struct tcphdr *)((*pskb)->nh.raw + tcphoff);

   /* Since it passed flags test in tcp match, we know it is is
      not a fragment, and has data >= tcp header length.  SYN
      packets should not contain data: if they did, then we risk
      running over MTU, sending Frag Needed and breaking things
      badly. --RR */
   if (tcplen != tcph->doff*4) {
      if (net_ratelimit())
         printk(KERN_ERR "xt_TCPMSS: bad length (%u bytes)\n",
                (*pskb)->len);
      return -1;
   }

    [...]
