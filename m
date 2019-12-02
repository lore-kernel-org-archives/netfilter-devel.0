Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC95C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 14:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C131206F0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 14:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfLBOZ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 09:25:29 -0500
Received: from correo.us.es ([193.147.175.20]:42892 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbfLBOZ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 09:25:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93BFFE34CF
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 15:25:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81572DA713
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 15:25:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 76BECDA70D; Mon,  2 Dec 2019 15:25:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50942DA70D;
        Mon,  2 Dec 2019 15:25:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 15:25:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2D66D4265A5A;
        Mon,  2 Dec 2019 15:25:23 +0100 (CET)
Date:   Mon, 2 Dec 2019 15:25:24 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] arptables 0.0.5 release
Message-ID: <20191202142524.sxyhei4w7vzmi62k@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2rczdurehllifc6v"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--2rczdurehllifc6v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project presents:

        arptables 0.0.5

arptables is the userspace command line program used to configure the
Linux 2.4.x and later ARP packet filtering ruleset. It is targeted
towards system administrators.

NOTE: This is a release of legacy software. Patches may still be
accepted and pushed out to the git repository, which will remain active
and accessible as usual although support for this software might be
discontinued at some point.

We are thankful to all the contributors of arptables over time and we
also acknowledge it is time to move on.

See ChangeLog that comes attached to this email for more details.

You can download it from:

ftp://ftp.netfilter.org/pub/arptables/

Happy firewalling.

--2rczdurehllifc6v
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-arptables-0.0.5.txt"
Content-Transfer-Encoding: 8bit

Arturo Borrero Gonzalez (2):
      arptables: cleanup sysvinit script
      arptables: legacy renaming

Bart De Schuymer (2):
      add GPL text
      arptables: fix potential buffer overflow (author: dcb)

Felix Janda (2):
      src: Use stdint types
      src: Remove support for libc5

Gustavo Zacarias (1):
      arptables: remove dead dynamic hooks code

Jaromír Končický (2):
      make static analysis tool happy (false positive)
      fix potential buffer overflows reported by static analysis

Jesper Dangaard Brouer (3):
      Add man pages for arptables-{save,restore}
      arptables: install man pages
      arptables: add missing long option --set-counters and update documentation

Jonh Wendell (1):
      build an libarptc.a archive

Pablo Neira Ayuso (3):
      src: cache in tree and use x_tables.h
      src: fix compilation warning
      arptables 0.0.5 release

Phil Sutter (3):
      Add .gitignore
      Eliminate compiler warning about size passed to strncmp()
      libarptc: Simplify alloc_handle by using calloc()

Zhang Chunyu (2):
      arptables: Add revision field for arptables userspace
      arptables: Add MARK target


--2rczdurehllifc6v--
