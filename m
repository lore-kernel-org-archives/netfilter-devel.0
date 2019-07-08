Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B98C606A7
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 927B020651
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbfGHKHn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 06:07:43 -0400
Received: from mail.us.es ([193.147.175.20]:45702 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfGHKHn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 06:07:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72DB0C04A2
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:07:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6274D114D8C
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:07:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 57D11114D71; Mon,  8 Jul 2019 12:07:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 242E6DA732;
        Mon,  8 Jul 2019 12:07:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:07:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 041504265A32;
        Mon,  8 Jul 2019 12:07:37 +0200 (CEST)
Date:   Mon, 8 Jul 2019 12:07:37 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Update obsolete comments referring to
 ip_conntrack
Message-ID: <20190708100737.fo42wf5sgkpsgvar@salvia>
References: <20190705085156.GA14117@jong.localdomain>
 <20190706222824.29550-1-yon.goldschmidt@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gd6x7bboqz642wos"
Content-Disposition: inline
In-Reply-To: <20190706222824.29550-1-yon.goldschmidt@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--gd6x7bboqz642wos
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 07, 2019 at 01:28:24AM +0300, Yonatan Goldschmidt wrote:
> In 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.") the new
> generic nf_conntrack was introduced, and it came to supersede the
> old ip_conntrack.
> This change updates (some) of the obsolete comments referring to old
> file/function names of the ip_conntrack mechanism, as well as removes
> a few self-referencing comments that we shouldn't maintain anymore.
> 
> I did not update any comments referring to historical actions (e.g,
> comments like "this file was derived from ..." were left untouched,
> even if the referenced file is no longer here).

A few more changes in net/netfilter/Kconfig, I'd suggest

--gd6x7bboqz642wos
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d59742408d9b..d7b166e38e99 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -223,8 +223,6 @@ config NF_CONNTRACK_FTP
 	  of Network Address Translation on them.
 
 	  This is FTP support on Layer 3 independent connection tracking.
-	  Layer 3 independent connection tracking is experimental scheme
-	  which generalize ip_conntrack to support other layer 3 protocols.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
@@ -338,7 +336,7 @@ config NF_CONNTRACK_SIP
 	help
 	  SIP is an application-layer control protocol that can establish,
 	  modify, and terminate multimedia sessions (conferences) such as
-	  Internet telephony calls. With the ip_conntrack_sip and
+	  Internet telephony calls. With the nf_conntrack_sip and
 	  the nf_nat_sip modules you can support the protocol on a connection
 	  tracking/NATing firewall.
 
@@ -1313,7 +1311,7 @@ config NETFILTER_XT_MATCH_HELPER
 	depends on NETFILTER_ADVANCED
 	help
 	  Helper matching allows you to match packets in dynamic connections
-	  tracked by a conntrack-helper, ie. ip_conntrack_ftp
+	  tracked by a conntrack-helper, ie. nf_conntrack_ftp
 
 	  To compile it as a module, choose M here.  If unsure, say Y.
 

--gd6x7bboqz642wos--
