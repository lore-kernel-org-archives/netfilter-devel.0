From: "David S. Miller" <davem@redhat.com>
Subject: Fw: [patch] tcp connection tracking 2.4.19
Date: Tue, 08 Oct 2002 15:00:30 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021008.150030.00574604.davem@redhat.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Tue_Oct__8_15:00:30_2002_305)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Tue_Oct__8_15:00:30_2002_305)--
Content-Type: Message/Rfc822
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Return-Path: <linux-kernel-owner+davem=40redhat.com@vger.kernel.org>
Received: from localhost (IDENT:davem@localhost.localdomain [127.0.0.1])
	by pizda.ninka.net (8.9.3/8.9.3) with ESMTP id OAA14167
	for <davem@localhost>; Tue, 8 Oct 2002 14:55:36 -0700
Received: from localhost
	by localhost with POP3 (fetchmail-5.3.1)
	for davem@localhost (single-drop); Tue, 08 Oct 2002 14:55:37 -0700 (PDT)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by devserv.devel.redhat.com (8.11.6/8.11.0) with ESMTP id g98M1P110974
	for <davem@devserv.devel.redhat.com>; Tue, 8 Oct 2002 18:01:25 -0400
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with SMTP id g98M1Of18900
	for <davem@redhat.com>; Tue, 8 Oct 2002 18:01:24 -0400
Received: from vger.kernel.org (vger.kernel.org [209.116.70.75])
	by mx1.redhat.com (8.11.6/8.11.6) with SMTP id g98LfiX17859
	for <davem@redhat.com>; Tue, 8 Oct 2002 17:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id <S263779AbSJHUrj>; Tue, 8 Oct 2002 16:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org
	id <S261457AbSJHUrA>; Tue, 8 Oct 2002 16:47:00 -0400
Received: from dclient217-162-64-94.hispeed.ch ([217.162.64.94]:56593 "EHLO
	wanze.haus") by vger.kernel.org with ESMTP id <S263776AbSJHUpP>;
	Tue, 8 Oct 2002 16:45:15 -0400
Received: from martin by wanze.haus with local (Exim 3.35 #1 (Debian))
	id 17z1Je-0000rw-00
	for <linux-kernel@vger.kernel.org>; Tue, 08 Oct 2002 22:50:54 +0200
Date: Tue, 8 Oct 2002 22:50:54 +0200
From: Martin Renold <martinxyz@gmx.ch>
To: linux-kernel@vger.kernel.org
Subject: [patch] tcp connection tracking 2.4.19
Message-ID: <20021008205053.GA2621@old.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Virus: Hi! I'm a header virus! Copy me into yours and join the fun!
Sender: linux-kernel-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

There is a bug in the stable 2.4.19 kernel in the ip_conntrack code that
allows the final ACK of a SYN - SYN/ACK - ACK tcp handshake to establish
an ASSURED connection even if it has a wrong sequence number. The current
code only checks the ACK number.

This allows a DoS attack that will make it impossible to establish *real*
connections for some days, once the maximum is reached. Somebody sent me
an exploit:

http://old.homeip.net/martin/cdos.tgz

So I wrote a simple patch against 2.4.19, but I must admit that I do not
really understand the code around it, especially why it does not mark
such a packet as invalid (I'm new to most things here).

diff -urN -X dontdiff kernel-source-2.4.19.origin/include/linux/netfilter_ipv4/ip_conntrack_tcp.h kernel-source-2.4.19.patch/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
--- kernel-source-2.4.19.origin/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	Fri Aug  4 22:07:24 2000
+++ kernel-source-2.4.19.patch/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	Sat Oct  5 19:07:44 2002
@@ -24,8 +24,9 @@
 {
 	enum tcp_conntrack state;
 
-	/* Poor man's window tracking: sequence number of valid ACK
-           handshake completion packet */
+	/* Poor man's window tracking: expected sequence and acknowledge 
+	   number of valid ACK handshake completion packet */
+	u_int32_t handshake_seq;
 	u_int32_t handshake_ack;
 };
 
diff -urN -X dontdiff kernel-source-2.4.19.origin/net/ipv4/netfilter/ip_conntrack_proto_tcp.c kernel-source-2.4.19.patch/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- kernel-source-2.4.19.origin/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Fri Oct  4 08:13:38 2002
+++ kernel-source-2.4.19.patch/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Sat Oct  5 20:45:49 2002
@@ -180,6 +180,8 @@
 	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
 	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
 	    && tcph->syn && tcph->ack)
+		conntrack->proto.tcp.handshake_seq
+			= tcph->ack_seq;
 		conntrack->proto.tcp.handshake_ack
 			= htonl(ntohl(tcph->seq) + 1);
 	WRITE_UNLOCK(&tcp_lock);
@@ -196,6 +198,7 @@
 		if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
 		    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
 		    && tcph->ack && !tcph->syn
+		    && tcph->seq == conntrack->proto.tcp.handshake_seq
 		    && tcph->ack_seq == conntrack->proto.tcp.handshake_ack)
 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
 
-- 
Thunder's just a noise, boys, lightnin' does the work
-- (Chad Brock/John Hadley/Kelly Garrett)
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


----Next_Part(Tue_Oct__8_15:00:30_2002_305)----
