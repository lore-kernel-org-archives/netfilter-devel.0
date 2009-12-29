From: Xiong Wu <xiong.wu1981@gmail.com>
Subject: Question about ipt_REJECT
Date: Tue, 29 Dec 2009 15:37:07 +0800
Message-ID: <c794cd670912282337v5a57508cwbc4c815cf53d363b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59306 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbZL2HhI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2009 02:37:08 -0500
Received: by ewy19 with SMTP id 19so2474115ewy.21
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2009 23:37:07 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

I found the TCP RST packet sent from ipt_REJECT target isn't able to
update related conntrack state.

I install a 2.6.30.10 kernel as a router and add a iptables rule with
REJECT target to reset specific connections.  However  I found  when
the packets is handled by the ipt_REJECT and the TCP RST packet is
sent, the related conntrack state isn't updated to CLOSE state.

Then I review the ipt_REJECT codes. I found the target attach the old
conntrack to RST packet as:
{
   nf_ct_attach(nskb, oldskb);
   ip_local_out(nskb);
}

Therefor the nf_conntrack_in() will ignore this RST packet due to the
nfct is valid in skb.
{
     if (skb->nfct) {
                    NF_CT_STAT_INC_ATOMIC(net, ignore);
                    return NF_ACCEPT;
     }
}


Is there any reason to attach the old conntrack to new RST skb?  I
think let the RST packet lookup and update related conntrack is
better.


Thanks,
Sean
