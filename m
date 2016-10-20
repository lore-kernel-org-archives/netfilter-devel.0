From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [RFC nf-next PATCH] netfilter: nf_conntrack_proto_tcp: propagate
 IP_CT_TCP_FLAG_BE_LIBERAL
Date: Thu, 20 Oct 2016 11:00:49 +0200
Message-ID: <147695370184.31999.2434286995020619745.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54814 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754894AbcJTJAq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 05:00:46 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 5672951F2DA
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 09:00:43 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DOVGAT2VDRJ4 for <netfilter-devel@vger.kernel.org>;
        Thu, 20 Oct 2016 11:00:37 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 8CE8D51F2D7
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 11:00:37 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

According to Mathew Heard, the IP_CT_TCP_FLAG_BE_LIBERAL
is not being propagated properly while using userspace conntrackd to
replicate connections states in a firewall cluster.

This change modifies the behaviour of the engine to always be liberal in
the reply direction if we were liberal in the original direction as well.

More info in the Netfilter bugzilla:
 https://bugzilla.netfilter.org/show_bug.cgi?id=1087

Suggested-by: Mathew Heard <mat999@gmail.com>
Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
RFC: I don't fully understand this patch. Specifically, I don't understand
why this can't be done from userspace, in conntrackd, when creating/updating
synced conntracks. We could just set the new/updated conntrack with the flags
we want, don't we?

Also, I don't fully understand the consecuences of doing this flags change
in the middle of tcp_packet().

So, please, review the patch and give us comments.

 net/netfilter/nf_conntrack_proto_tcp.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 69f6877..ed16acf 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -835,6 +835,13 @@ static int tcp_packet(struct nf_conn *ct,
 	new_state = tcp_conntracks[dir][index][old_state];
 	tuple = &ct->tuplehash[dir].tuple;
 
+	/* if we are liberal in one direction, so be it in the other */
+	if (ct->proto.tcp.seen[IP_CT_DIR_ORIGINAL].flags &
+	    IP_CT_TCP_FLAG_BE_LIBERAL) {
+		ct->proto.tcp.seen[IP_CT_DIR_REPLY].flags |=
+			IP_CT_TCP_FLAG_BE_LIBERAL;
+	}
+
 	switch (new_state) {
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state < TCP_CONNTRACK_TIME_WAIT)

