Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FC2C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 13:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB0DA206E1
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 13:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfLBN5t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 08:57:49 -0500
Received: from correo.us.es ([193.147.175.20]:53396 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbfLBN5t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 08:57:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD3CFFB371
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 14:57:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5C7CDA738
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 14:57:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A374FDA713; Mon,  2 Dec 2019 14:57:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C284DA7F8;
        Mon,  2 Dec 2019 14:57:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 14:57:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C42BC42EE38F;
        Mon,  2 Dec 2019 14:57:41 +0100 (CET)
Date:   Mon, 2 Dec 2019 14:57:42 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.1.5 release
Message-ID: <20191202135742.tdkuffglhefgzgnw@salvia>
References: <20190819110328.vnwmmox5ymabneib@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4qppecvfce6p6usk"
Content-Disposition: inline
In-Reply-To: <20190819110328.vnwmmox5ymabneib@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--4qppecvfce6p6usk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.1.5

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem. The
library libnftnl has been previously known as libnftables. This
library is currently used by nftables.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Happy firewalling.

--4qppecvfce6p6usk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnftnl-1.1.5.txt"

Ander Juaristi (2):
      expr: meta: Make NFT_META_TIME_{NS, DAY, HOUR} known
      expr: meta: Make NFT_DYNSET_OP_DELETE known

Eric Jallot (1):
      flowtable: add support for handle attribute

Fernando Fernandez Mancera (1):
      src: synproxy stateful object support

Manuel Messner (1):
      flowtable: Fix symbol export for clang

Pablo Neira Ayuso (4):
      flowtable: device array dynamic allocation
      chain: multi-device support
      flowtable: remove NFTA_FLOWTABLE_SIZE
      build: libnftnl 1.1.5 release

Phil Sutter (11):
      set: Export nftnl_set_list_lookup_byname()
      obj: ct_timeout: Check return code of mnl_attr_parse_nested()
      set_elem: Fix return code of nftnl_set_elem_set()
      obj/tunnel: Fix for undefined behaviour
      set: Don't bypass checks in nftnl_set_set_u{32,64}()
      obj/ct_timeout: Avoid array overrun in timeout_parse_attr_data()
      set_elem: Validate nftnl_set_elem_set() parameters
      obj/ct_timeout: Fix NFTA_CT_TIMEOUT_DATA parser
      libnftnl.map: Export nftnl_{obj,flowtable}_set_data()
      Deprecate untyped data setters
      utils: Define __visible even if not supported by compiler


--4qppecvfce6p6usk--
