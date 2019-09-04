Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EA1C3A5A8
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 19:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95FFF208E4
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 19:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387993AbfIDTFk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 15:05:40 -0400
Received: from correo.us.es ([193.147.175.20]:33386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731832AbfIDTFk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 15:05:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2C4EF303D02
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 21:05:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FDA2CA0F3
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 21:05:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 13D1DD2B1E; Wed,  4 Sep 2019 21:05:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 043EDDA4CA;
        Wed,  4 Sep 2019 21:05:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Sep 2019 21:05:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D6B3742EE38E;
        Wed,  4 Sep 2019 21:05:33 +0200 (CEST)
Date:   Wed, 4 Sep 2019 21:05:35 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v2 00/30] Add config option checks to netfilter
 headers.
Message-ID: <20190904190535.7dslwytvpff567mt@salvia>
References: <20190902230650.14621-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902230650.14621-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

Thanks for working on this.

Could you squash a few of these patches to get a smaller patchset?

My suggestions:

* Squash 01/30, 02/30 and 03/30, call this something like: "netfilter: add
  missing include guard". Just document that the chunk for the
  flowtable is fixing up a comment.

* For 04/30, since this is about SPDX, I would suggest you leave this
  behind and we wait for someone to make a whole pass over the netfilter
  headers to check for missing SPDX tags? Not a deal breaker, you can
  keep it in this batch if you like.

* Squash 05/30, 06/30 and 07/30, call this I'd suggest: "netfilter:
  fix coding style errors", document the stray semi-colons, the
  Kconfig missing indent and the trailing whitespaces.

* Squash 09/30, 10/30, 11/30, 12/30 and 12/30. They all refer to
  #include updates, could you squash and document these updates?

* 14/30, "netfilter: remove superfluous header" I'd suggest you rename
  this to "netfilter: remove nf_conntrack_icmpv6.h header".

* 15/30 and 16/30 LGTM.

* 17/30 I don't think struct nf_bridge_frag_data qualifies for the
  global netfilter.h header.

* 19/30 LGTM.

* With 20/30 gets more ifdef pollution to optimize a case where kernel
  is compiled without this trackers. I would prefer you keep this
  back.

* Please, squash 21/30 and 22/30.

* 24/30 nft_set_pktinfo_ipv6_validate() definition already
  deals with this in the right way.

* 25/30 nf_conntrack_zones_common.h only makes sense if NF_CONNTRACK
  is enabled, I don't understand.

* 27/30 identation is not correct, not using tabs.

* 26/30 is adding more #ifdef CONFIG_NETFILTER to the netfilter.h
  header. They make sense to make this new infra to compile headers,
  but from developer perspective is confusing.

* 30/30 very similar to 26/30...

--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -7,6 +7,10 @@ 
 #ifndef _IP_SET_H
 #define _IP_SET_H
 
+#include <uapi/linux/netfilter/ipset/ip_set.h>
+
+#if IS_ENABLED(CONFIG_IP_SET)
...

Shouldn't probably the CONFIG_HEADER_TEST infrastructure check if the
Kconfig option is set on before blindy compiling headers?
