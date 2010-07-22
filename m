From: Dan Carpenter <error27@gmail.com>
Subject: re: netfilter: nfnetlink_log: send complete hardware header
Date: Thu, 22 Jul 2010 13:50:53 +0200
Message-ID: <20100722115053.GF17585@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60722 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0GVLvL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:51:11 -0400
Received: by fxm14 with SMTP id 14so4206917fxm.19
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jul 2010 04:51:10 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Smatch complains abbout 72961ecf84d67d6 "netfilter: nfnetlink_log: send
complete hardware header" which is net-next.
    
   462          if (indev && skb->dev) {
                             ^^^^^^^^
	skb->dev can be NULL here.

   463                  struct nfulnl_msg_packet_hw phw;
   464                  int len = dev_parse_header(skb, phw.hw_addr);
   465                  if (len > 0) {
   466                          phw.hw_addrlen = htons(len);
   467                          NLA_PUT(inst->skb, NFULA_HWADDR, sizeof(phw), &phw);
   468                  }
   469          }
   470  
   471          if (indev && skb_mac_header_was_set(skb)) {
   472                  NLA_PUT_BE16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type));
                                                                    ^^^^^^^^
	It's dereferenced here.

   473                  NLA_PUT_BE16(inst->skb, NFULA_HWLEN,
   474                               htons(skb->dev->hard_header_len));

I'm not sure how you want to deal with this.

regards,
dan carpenter
