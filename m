From: Eugene Strulyov <eugene.strulyov@gmail.com>
Subject: NFQUEUE filtering strategy
Date: Thu, 24 Sep 2015 17:33:33 -0700
Message-ID: <CAKEqNmnNGC2COOox+dN1uY8q27VBSZnjBjo_R1tK62QsYg+uLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35595 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbbIYAde (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2015 20:33:34 -0400
Received: by oiww128 with SMTP id w128so50693728oiw.2
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2015 17:33:33 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am writing a custom filter using libnetfilter_queue. This library
supports NF_ACCEPT and NF_DROP verdicts, but I also need to be able to
REJECT and REDIRECT. So what I'm planning to do instead is to use
NFQUEUE to mark packets in the mangle table, then post-process them
with iptables in the nat and filter tables. Something like this:

iptables -t mangle -A PREROUTING -p tcp --dport 1234 -j NFQUEUE
--queue-balance 1:10
# all packets NF_ACCEPT'ed but marked appropriately

iptables -t nat -A PREROUTING -p tcp -m mark --mark 4 -j REDIRECT
iptables -t filter -A FORWARD -p tcp -m mark --mark 1 -j ACCEPT
iptables -t filter -A FORWARD -p tcp -m mark --mark 2 -j REJECT
iptables -t filter -A FORWARD -p tcp -m mark --mark 3 -j DROP

Does this sound like a reasonable approach?

thanks,

Eugene
