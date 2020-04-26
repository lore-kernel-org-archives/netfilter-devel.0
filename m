Return-Path: <SRS0=Hoda=6K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1996C54FCB
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Apr 2020 21:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A255E20700
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Apr 2020 21:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgDZVxh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Apr 2020 17:53:37 -0400
Received: from correo.us.es ([193.147.175.20]:54184 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgDZVxh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Apr 2020 17:53:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 372B41022A2
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 23:53:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23CE5DA7B2
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 23:53:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 18F5DDA736; Sun, 26 Apr 2020 23:53:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E961FBAAA1;
        Sun, 26 Apr 2020 23:53:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 26 Apr 2020 23:53:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CC23142EF4E0;
        Sun, 26 Apr 2020 23:53:32 +0200 (CEST)
Date:   Sun, 26 Apr 2020 23:53:32 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Bodong Wang <bodong@mellanox.com>
Cc:     netfilter-devel@vger.kernel.org, ozsh@mellanox.com,
        paulb@mellanox.com
Subject: Re: [nf-next V2] netfilter: nf_conntrack, add IPS_HW_OFFLOAD status
 bit
Message-ID: <20200426215332.GA2330@salvia>
References: <20200421150416.19151-1-bodong@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20200421150416.19151-1-bodong@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 21, 2020 at 10:04:16AM -0500, Bodong Wang wrote:
> This bit indicates that the conntrack entry is offloaded to hardware
> flow table. nf_conntrack entry will be tagged with [HW_OFFLOAD] if
> it's offload to hardware.
> 
> cat /proc/net/nf_conntrack
> 	ipv4 2 tcp 6 \
> 	src=1.1.1.17 dst=1.1.1.16 sport=56394 dport=5001 \
> 	src=1.1.1.16 dst=1.1.1.17 sport=5001 dport=56394 [HW_OFFLOAD] \
> 	mark=0 zone=0 use=3
> 
> Note that HW_OFFLOAD/OFFLOAD/ASSURED are mutually exclusive.

Applied, thanks.

Could you also test the following userspace patches for
libnetfilter_conntrack and the conntrack-tools to get the netlink
tools in feature parity? If they work fine there, I'll formally submit
them.

Thanks.

--OXfL5xGRrasGEqWY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="libnetfilter_conntrack.patch"

diff --git a/include/libnetfilter_conntrack/linux_nf_conntrack_common.h b/include/libnetfilter_conntrack/linux_nf_conntrack_common.h
index 32efa357c8db..131ca258a904 100644
--- a/include/libnetfilter_conntrack/linux_nf_conntrack_common.h
+++ b/include/libnetfilter_conntrack/linux_nf_conntrack_common.h
@@ -102,6 +102,15 @@ enum ip_conntrack_status {
 	IPS_UNTRACKED_BIT = 12,
 	IPS_UNTRACKED = (1 << IPS_UNTRACKED_BIT),
 
+#ifdef __KERNEL__
+	/* Re-purposed for in-kernel use:
+	 * Tags a conntrack entry that clashed with an existing entry
+	 * on insert.
+	 */
+	IPS_NAT_CLASH_BIT = IPS_UNTRACKED_BIT,
+	IPS_NAT_CLASH = IPS_UNTRACKED,
+#endif
+
 	/* Conntrack got a helper explicitly attached via CT target. */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
@@ -110,14 +119,19 @@ enum ip_conntrack_status {
 	IPS_OFFLOAD_BIT = 14,
 	IPS_OFFLOAD = (1 << IPS_OFFLOAD_BIT),
 
+	/* Conntrack has been offloaded to hardware. */
+	IPS_HW_OFFLOAD_BIT = 15,
+	IPS_HW_OFFLOAD = (1 << IPS_HW_OFFLOAD_BIT),
+
 	/* Be careful here, modifying these bits can make things messy,
 	 * so don't let users modify them directly.
 	 */
 	IPS_UNCHANGEABLE_MASK = (IPS_NAT_DONE_MASK | IPS_NAT_MASK |
 				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING |
-				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_OFFLOAD),
+				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_UNTRACKED |
+				 IPS_OFFLOAD | IPS_HW_OFFLOAD),
 
-	__IPS_MAX_BIT = 15,
+	__IPS_MAX_BIT = 16,
 };
 
 /* Connection tracking event types */
diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index 765ce726ea7d..2f2f91864d39 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -184,7 +184,9 @@ static int __snprintf_status_assured(char *buf,
 {
 	int size = 0;
 
-	if (ct->status & IPS_OFFLOAD)
+	if (ct->status & IPS_HW_OFFLOAD)
+		size = snprintf(buf, len, "[HW_OFFLOAD] ");
+	else if (ct->status & IPS_OFFLOAD)
 		size = snprintf(buf, len, "[OFFLOAD] ");
 	else if (ct->status & IPS_ASSURED)
 		size = snprintf(buf, len, "[ASSURED] ");

--OXfL5xGRrasGEqWY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="conntrack-tools.patch"

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 8023e5b6572f..16d20a3b2ff0 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -97,6 +97,15 @@ enum ip_conntrack_status {
 	IPS_UNTRACKED_BIT = 12,
 	IPS_UNTRACKED = (1 << IPS_UNTRACKED_BIT),
 
+#ifdef __KERNEL__
+	/* Re-purposed for in-kernel use:
+	 * Tags a conntrack entry that clashed with an existing entry
+	 * on insert.
+	 */
+	IPS_NAT_CLASH_BIT = IPS_UNTRACKED_BIT,
+	IPS_NAT_CLASH = IPS_UNTRACKED,
+#endif
+
 	/* Conntrack got a helper explicitly attached via CT target. */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
@@ -105,14 +114,19 @@ enum ip_conntrack_status {
 	IPS_OFFLOAD_BIT = 14,
 	IPS_OFFLOAD = (1 << IPS_OFFLOAD_BIT),
 
+	/* Conntrack has been offloaded to hardware. */
+	IPS_HW_OFFLOAD_BIT = 15,
+	IPS_HW_OFFLOAD = (1 << IPS_HW_OFFLOAD_BIT),
+
 	/* Be careful here, modifying these bits can make things messy,
 	 * so don't let users modify them directly.
 	 */
 	IPS_UNCHANGEABLE_MASK = (IPS_NAT_DONE_MASK | IPS_NAT_MASK |
 				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING |
-				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_OFFLOAD),
+				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_UNTRACKED |
+				 IPS_OFFLOAD | IPS_HW_OFFLOAD),
 
-	__IPS_MAX_BIT = 15,
+	__IPS_MAX_BIT = 16,
 };
 
 /* Connection tracking event types */
diff --git a/src/conntrack.c b/src/conntrack.c
index f65926b298ad..fb4e5be86ed8 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -870,8 +870,8 @@ static struct parse_parameter {
 	size_t  size;
 	unsigned int value[8];
 } parse_array[PARSE_MAX] = {
-	{ {"ASSURED", "SEEN_REPLY", "UNSET", "FIXED_TIMEOUT", "EXPECTED", "OFFLOAD"}, 6,
-	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, IPS_FIXED_TIMEOUT, IPS_EXPECTED, IPS_OFFLOAD} },
+	{ {"ASSURED", "SEEN_REPLY", "UNSET", "FIXED_TIMEOUT", "EXPECTED", "OFFLOAD", "HW_OFFLOAD"}, 7,
+	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, IPS_FIXED_TIMEOUT, IPS_EXPECTED, IPS_OFFLOAD, IPS_HW_OFFLOAD} },
 	{ {"ALL", "NEW", "UPDATES", "DESTROY"}, 4,
 	  { CT_EVENT_F_ALL, CT_EVENT_F_NEW, CT_EVENT_F_UPD, CT_EVENT_F_DEL } },
 	{ {"xml", "extended", "timestamp", "id", "ktimestamp", "labels", "userspace" }, 7,

--OXfL5xGRrasGEqWY--
