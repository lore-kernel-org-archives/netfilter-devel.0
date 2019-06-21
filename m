Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E82CC48BE3
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 15:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5FFC206B7
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 15:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfFUPIn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 11:08:43 -0400
Received: from mail.us.es ([193.147.175.20]:43690 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfFUPIn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 11:08:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 564FAEB46C
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 17:08:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 430FDDA708
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 17:08:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3832EDA704; Fri, 21 Jun 2019 17:08:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21FACDA706;
        Fri, 21 Jun 2019 17:08:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Jun 2019 17:08:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 00AD94265A31;
        Fri, 21 Jun 2019 17:08:38 +0200 (CEST)
Date:   Fri, 21 Jun 2019 17:08:38 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: bridge: Fix non-untagged fragment
 packet
Message-ID: <20190621150838.en7rkykfq3vui4bd@salvia>
References: <1560954907-20071-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560954907-20071-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 19, 2019 at 10:35:07PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> ip netns exec ns1 ip a a dev eth0 10.0.0.7/24
> ip netns exec ns2 ip link a link eth0 name vlan type vlan id 200
> ip netns exec ns2 ip a a dev vlan 10.0.0.8/24
> 
> ip l add dev br0 type bridge vlan_filtering 1
> brctl addif br0 veth1
> brctl addif br0 veth2
> 
> bridge vlan add dev veth1 vid 200 pvid untagged
> bridge vlan add dev veth2 vid 200
> 
> A two fragment packets send from ns2 contained with vlan tag 200.
> In the bridge conntrack, packet will defrag to one skb with fraglist.
> When the packet forward to ns1 through veth1, the first skb vlan tag
> will be cleared for "untagged" flags. But the vlan tag in the second
> skb still tagged, which lead the second fragment send with tag 200 to
> ns1.
> So if the first fragment packet don't contain vlan tag, all of the
> remain should not contain vlan tag..

Applied, thanks for explaining.
