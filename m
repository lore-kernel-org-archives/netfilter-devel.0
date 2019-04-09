Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D934C282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 06:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D48E20880
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 06:56:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YAGurzXJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfDIG4R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 02:56:17 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38571 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfDIG4Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 02:56:16 -0400
Received: by mail-io1-f66.google.com with SMTP id v4so13330995ioj.5;
        Mon, 08 Apr 2019 23:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g1CAhrs+XKcnO04tYd62P5aQHE9n2UfoCEcN1al9wbA=;
        b=YAGurzXJeGj/1GBjBd/jXslO4S7jXu0drLCwWbSl4Ff23U1myJ7lbxVYPXe3LVJCYR
         d37tlQLgTOzRzJMVfutOUWE+Hb87UpqZofmQOYHFw5YqBr0gAsRbuzRJB6nkRtjxqjYL
         rYjUs+AB9OXE81tj4uGMh67fa2wyy5TgGkHFrbkpzdLl7VShiZ2X+Vwjaz+SaDNM/Zz3
         zJtFMhjWJJ1vsXD+LwECxFwAVlJkwEVAv9PvQqvkDEc2dJg4Lu/fqHW4vN1sHRlLo27w
         p5DtyY9wcYPeIcIe9GBxgRA/mAkNz/fg0Dn2yLKoWBwE943JLYvJPjDA0w6mESIRbLcN
         U91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g1CAhrs+XKcnO04tYd62P5aQHE9n2UfoCEcN1al9wbA=;
        b=CcLgawnl8yBNa2tYCH+BtCByAuQvepeCVaFiXi+Br12SrmW586UI7qiG03UppnLfng
         l4OiIbblgkZflFeXQuon5zVH+ojP3P49hl8buZHOxgb2Wo+u/sg9TVrDdpPQwhqtL9XI
         oOz6cmX/rmlNR4+UrI0Eo7OtlEFXyCv0JRVumDtkiTC87e6/yTWfumVud0kKTAWMqLCL
         az/1FyLs8IesRSCTiBkgdILOnVBQ756wiR0xhQ2pxFCeJPgem6Lp6pU32YJE5birdNDh
         efS0HIFEd0c+o4OShaXRZzZ1QDJeXsMRAF9+3eKolhdbLZj8gEArBOWyKEV/iJ96vuK6
         ivRw==
X-Gm-Message-State: APjAAAWt5vEi7glIioBdjUlQqa0fqyogcnL6aXMdMk3by1f2mM/GPxQd
        0DvWmu5avSHzBAQc9gNtpmKYcVjXLyF4
X-Google-Smtp-Source: APXvYqx5SqQVG+mYJ3/E0eGJivWLVRr47VWTZ+/p6n4K3DQVuc3HU7TsnLCdRVJmcegVu+yUO5lALw==
X-Received: by 2002:a6b:6509:: with SMTP id z9mr23954838iob.43.1554792976033;
        Mon, 08 Apr 2019 23:56:16 -0700 (PDT)
Received: from ip-172-31-35-247.us-east-2.compute.internal (ec2-52-15-165-154.us-east-2.compute.amazonaws.com. [52.15.165.154])
        by smtp.gmail.com with ESMTPSA id 65sm6644927itw.1.2019.04.08.23.56.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 23:56:15 -0700 (PDT)
From:   Rundong Ge <rdong.ge@gmail.com>
To:     pablo@netfilter.org
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdong.ge@gmail.com
Subject: [PATCH] netfilter: fix dangling pointer access of fake_rtable
Date:   Tue,  9 Apr 2019 06:56:12 +0000
Message-Id: <20190409065612.32652-1-rdong.ge@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With  bridge-nf-call-iptables enabeled, Skbs go through the bridge
and enqueued between  <NF_BR_PRE_ROUTING,NF_BR_PRI_BRNF> and
<NF_BR_FORWARD,NF_BR_PRI_BRNF - 1> won't be flushed when bridge is
down. Then _skb_refdst of skbs in the nfqueue become dangling pointer.

Reproduce steps:
1.Create a bridge on the box.
2.echo 1 >/proc/sys/net/bridge/bridge-nf-call-iptables
3.Add a netfilter hook function to queue the packets to nfqueuenum 0.
  The hook point must between <NF_BR_PRE_ROUTING,NF_BR_PRI_BRNF> and
  <NF_BR_FORWARD,NF_BR_PRI_BRNF - 1>.
4.Add a userspace process "nfqueue_rcv" to continuously read and
  set_verdict "NF_ACCEPT" to packets from queue 0.
5.Continuosly ping client1 from client0
6.Send "Ctrl + Z" to pause the "nfqueue_rcv" to simulate the queue
  congestion.
7.Using "ifconfig br0 down&&brctl delbr br0" to delete the bridge.
8.At this time the _skb_refdst of skbs in the nfqueue become dangling
  pointer. If we send "fg" to resume the "nfqueue_rcv", the kernel
  may try to access the freed memory.

Debug log:
Here I add debug logs in "netdev_freemem" and "dst_release" to prove
the freed memory access. As the log shows, the "dst_release" accessed
bridge's fake_rtable after the bridge was freed.

Apr  8 22:25:14 raydon kernel: [62139.005062] netdev_freemem name:br0,
fake_rtable:000000009d76cef0

Apr  8 22:25:21 raydon kernel: [62145.967133] dst_release
dst:000000009d76cef0 dst->dev->name: řKU¡TH

Apr  8 22:25:21 raydon kernel: [62145.967154] dst_release
dst:000000009d76cef0 dst->dev->name: řKU¡TH

Apr  8 22:25:21 raydon kernel: [62145.967180] dst_release
dst:000000009d76cef0 dst->dev->name: řKU¡TH

Apr  8 22:25:21 raydon kernel: [62145.967197] dst_release
dst:000000009d76cef0 dst->dev->name: řKU¡TH

The reason why the hook point should be after <NF_BR_PRE_ROUTING,
NF_BR_PRI_BRNF> is skbs reference bridge's fake_rtable in
"br_nf_pre_routing_finish" hooked at <NF_BR_PRE_ROUTING,NF_BR_PRI_BRNF>.

And the reason why the hook point should be before <NF_BR_FORWARD,
NF_BR_PRI_BRNF - 1> is "br_nf_forward_ip" will set the state.out to
bridge dev. After this hook point, the "nfqnl_dev_drop" triggered by
the bridge's NETDEV_DOWN event can flush the queued skbs before
bridge's memory is freed, because the state.out now matches the
bridge's dev.

Signed-off-by: Rundong Ge <rdong.ge@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 0dcc359..57eb02d 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -905,13 +905,25 @@ static void free_entry(struct nf_queue_entry *entry)
 dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	int physinif, physoutif;
+	struct net_device *physindev, *physoutdev;
+	struct net_bridge_port *port;
 
-	physinif = nf_bridge_get_physinif(entry->skb);
-	physoutif = nf_bridge_get_physoutif(entry->skb);
-
-	if (physinif == ifindex || physoutif == ifindex)
-		return 1;
+	physindev = nf_bridge_get_physindev(entry->skb);
+	physoutdev = nf_bridge_get_physoutdev(entry->skb);
+	if (physindev) {
+		if (physindev->ifindex == ifindex)
+			return 1;
+		port = br_port_get_rcu(physindev);
+		if (port && port->br->dev->ifindex == ifindex)
+			return 1;
+	}
+	if (physoutdev) {
+		if (physoutdev->ifindex == ifindex)
+			return 1;
+		port = br_port_get_rcu(physoutdev);
+		if (port && port->br->dev->ifindex == ifindex)
+			return 1;
+	}
 #endif
 	if (entry->state.in)
 		if (entry->state.in->ifindex == ifindex)
-- 
1.8.3.1

