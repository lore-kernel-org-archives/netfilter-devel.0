From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: "random" syn packets dropped
Date: Tue, 8 Nov 2016 11:35:30 +0100
Message-ID: <CAJO99TnMCZdROCNV9-3xcURbGZVw7X-wKwf-vkUc5Lc3R_QT9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:36423 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752372AbcKHKnV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 05:43:21 -0500
Received: by mail-yb0-f176.google.com with SMTP id v78so65220522ybe.3
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Nov 2016 02:43:21 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reposted from netfilter:

I am not sure if this is nftables related, but I post this issue here,
and see if any of you can come up with a clue to what might be
going on here.

Problem description:

When I create multiple tcp connections from the same client to
multiple dst hosts at the same time, the n'th syn packet is just
discarded by "something" in the kernel.

If I reorder the list of dst hosts, a different dst host will hang in SYN_SENT
on the client. This setup has been running for about a month, and we have
no changed that can explain this behavior.

What I am seeing on the firewall running kernel 4.8.1 is the following:

* the syn packet enters through the eth1.700 interface (tcdump)
* nft trace monitoring shows the packet beeing accepted on eth1.300 in
postrouting.
* tcpdump on the eth1.300 interface does not show the packet.
* rp_filter etc should not be kicking in here, (and also, "random"
hosts are dropped)
* conntrack table is not full
* this issue seem to suddenly appeared, is this a known bug?
* hint? All connections from the client is established from the same
source port.

-- 
Bj(/)rnar
