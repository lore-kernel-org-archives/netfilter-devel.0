From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/02]: ipt_recent: sanity check hit count
Date: Thu, 20 Mar 2008 15:07:27 -0700 (PDT)
Message-ID: <20080320.150727.14026735.davem@davemloft.net>
References: <47E2A507.6070409@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44736
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758920AbYCTWHK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:07:10 -0400
In-Reply-To: <47E2A507.6070409@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 20 Mar 2008 18:55:19 +0100

> [NETFILTER]: ipt_recent: sanity check hit count
> 
> If a rule using ipt_recent is created with a hit count greater than
> ip_pkt_list_tot, the rule will never match as it cannot keep track
> of enough timestamps. This patch makes ipt_recent refuse to create such
> rules.
> 
> With ip_pkt_list_tot's default value of 20, the following can be used
> to reproduce the problem.
> 
> nc -u -l 0.0.0.0 1234 &
> for i in `seq 1 100`; do echo $i | nc -w 1 -u 127.0.0.1 1234; done
> 
> This limits it to 20 packets:
> iptables -A OUTPUT -p udp --dport 1234 -m recent --set --name test \
>          --rsource
> iptables -A OUTPUT -p udp --dport 1234 -m recent --update --seconds \
>          60 --hitcount 20 --name test --rsource -j DROP
> 
> While this is unlimited:
> iptables -A OUTPUT -p udp --dport 1234 -m recent --set --name test \
>          --rsource
> iptables -A OUTPUT -p udp --dport 1234 -m recent --update --seconds \
>          60 --hitcount 21 --name test --rsource -j DROP
> 
> With the patch the second rule-set will throw an EINVAL.
> 
> Reported-by: Sean Kennedy <skennedy@vcn.com>
> Signed-off-by: Daniel Hokka Zakrisson <daniel@hozac.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks.
