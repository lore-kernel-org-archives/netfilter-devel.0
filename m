Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F5BC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 16:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F309623AC8
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 16:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730521AbgLHQkL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 11:40:11 -0500
Received: from correo.us.es ([193.147.175.20]:39406 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730518AbgLHQkL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 11:40:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D00E7117726
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 17:39:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEF4CDA73F
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 17:39:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B485ADA73D; Tue,  8 Dec 2020 17:39:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 717EFDA730;
        Tue,  8 Dec 2020 17:39:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Dec 2020 17:39:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 55EE84265A5A;
        Tue,  8 Dec 2020 17:39:18 +0100 (CET)
Date:   Tue, 8 Dec 2020 17:39:26 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Andreas Sundstrom <sunkan@zappa.cx>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Remove IP_NF_IPTABLES dependency for NET_ACT_CONNMARK
Message-ID: <20201208163926.GA10267@salvia>
References: <c9657e87-731c-3219-62eb-0cc15b0ff4cd@zappa.cx>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <c9657e87-731c-3219-62eb-0cc15b0ff4cd@zappa.cx>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Andreas,

On Tue, Dec 08, 2020 at 12:55:30PM +0100, Andreas Sundstrom wrote:
> IP_NF_IPTABLES is a superfluous dependency
> 
> To be able to select NET_ACT_CONNMARK when iptables has not been
> enabled this dependency needs to be removed.

I just looked at other dependencies in the Kconfig file, these need to
be adjusted too.

NET_ACT_IPT actually depends on NETFILTER_XTABLES.

Is the patch I'm attaching looking good to you?

Thanks.

--UlVJffcvxoiEqYs2
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800e..d762e89ab74f 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -813,7 +813,7 @@ config NET_ACT_SAMPLE
 
 config NET_ACT_IPT
 	tristate "IPtables targets"
-	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NET_CLS_ACT && NETFILTER && NETFILTER_XTABLES
 	help
 	  Say Y here to be able to invoke iptables targets after successful
 	  classification.
@@ -912,7 +912,7 @@ config NET_ACT_BPF
 
 config NET_ACT_CONNMARK
 	tristate "Netfilter Connection Mark Retriever"
-	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NET_CLS_ACT && NETFILTER
 	depends on NF_CONNTRACK && NF_CONNTRACK_MARK
 	help
 	  Say Y here to allow retrieving of conn mark
@@ -924,7 +924,7 @@ config NET_ACT_CONNMARK
 
 config NET_ACT_CTINFO
 	tristate "Netfilter Connection Mark Actions"
-	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NET_CLS_ACT && NETFILTER
 	depends on NF_CONNTRACK && NF_CONNTRACK_MARK
 	help
 	  Say Y here to allow transfer of a connmark stored information.

--UlVJffcvxoiEqYs2--
