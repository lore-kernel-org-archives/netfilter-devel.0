Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0758EC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 15:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D32022073C
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 15:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfLBPeD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 10:34:03 -0500
Received: from correo.us.es ([193.147.175.20]:36278 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727413AbfLBPeD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 10:34:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A50DE4FFE1B
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 16:33:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8AA1DDA78E
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 16:33:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7D34FDA713; Mon,  2 Dec 2019 16:33:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6A51DA707;
        Mon,  2 Dec 2019 16:33:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 16:33:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B6B704265A5A;
        Mon,  2 Dec 2019 16:33:55 +0100 (CET)
Date:   Mon, 2 Dec 2019 16:33:56 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] ebtables 2.0.11 release
Message-ID: <20191202153356.xowrrxn26jlm5v4f@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xu3xazvyeffwpblx"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--xu3xazvyeffwpblx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project presents:

        ebtables 2.0.11

ebtables is the userspace command line program used to configure the
Linux 2.4.x and bridge packet filtering ruleset. It is targeted
towards system administrators.

NOTE: This is a release of legacy software. Patches may still be
accepted and pushed out to the git repository, which will remain active
and accessible as usual although support for this software might be
discontinued at some point.

We are thankful to all the contributors of ebtables over time and we
also acknowledge it is time to move on.

See ChangeLog that comes attached to this email for more details.

You can download it from:

ftp://ftp.netfilter.org/pub/ebtables/

Happy firewalling.

--xu3xazvyeffwpblx
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-ebtables-2.0.11.txt"
Content-Transfer-Encoding: 8bit

Alin Năstac (1):
      ebtables: Allow RETURN target rules in user defined chains

Arturo Borrero Gonzalez (3):
      ebtables: legacy renaming
      ebtables: drop .spec file
      ebtables: drop sysvinit script

Bart De Schuymer (4):
      add RARP and update iana url
      add info about -Wl,-no-as-needed
      remove ebtables-restore binary from repository
      don't print IPv6 mask if it's all ones (based on patch by Mariusz Mazur <mmazur at axeos.com>)

Baruch Siach (1):
      include: Fix musl libc compatibility

Bernie Harris (1):
      extensions: Add string filter to ebtables

Duncan Roe (2):
      ebtables: Fix build errors and warnings
      extensions: ebt_string: take action if snprintf discards data

Felix Janda (2):
      extensions: Use stdint types
      ethernetdb.h: Remove C++ specific compiler hint macro _THROW

Florian Westphal (2):
      extensions: fix build failure on fc28
      ebtablesd: avoid build warning

Gargi Sharma (1):
      ebtables: extensions: Constify option struct

Jan Engelhardt (7):
      build: update ebtables.h from kernel and drop local unused copy
      build: drop install -o/-g root
      build: rename sed source files to .in
      build: use autoconf-style placeholders in sed-ed files
      extensions: use __attribute__((constructor)) for autoregistration
      Add .gitignore
      build: move to automake

Luis Fernando (1):
      workaround for kernel regression bug: IPv6 source/destination addresses are potentially not matched correctly

Matthias Schiffer (4):
      include: sync linux/netfilter_bridge/ebt_ip.h with kernel
      Move ICMP type handling functions from ebt_ip6 to useful_functions.c
      ebt_ip: add support for matching ICMP type and code
      ebt_ip: add support for matching IGMP type

Pablo Neira Ayuso (1):
      build: ebtables 2.0.11 release

Pedro Alvarez (1):
      Add kernel headers needed from v3.16

Petri Gynther (1):
      fix compilation warning

Phil Sutter (11):
      Use flock() for --concurrent option
      Fix locking if LOCKDIR does not exist
      extensions: among: Fix bitmask check
      Print IPv6 prefixes in CIDR notation
      Adjust .gitignore to renamed files
      extensions: Drop Makefile
      Allow customizing lockfile location at configure time
      extensions: Add AUDIT target
      Fix segfault with missing lockfile directory
      Fix incorrect IPv6 prefix formatting
      Drop ebtables-config from repository

Sanket Shah (1):
      Add --noflush command line support for ebtables-restore


--xu3xazvyeffwpblx--
