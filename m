From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] nfacct 1.0.2 release
Date: Mon, 22 Aug 2016 13:31:48 +0200
Message-ID: <20160822113148.GA12801@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Cc: lwn@lwn.net
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38314 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752112AbcHVLbx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 07:31:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E037A1878B9
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 13:31:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D11E2FF2C8
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 13:31:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8FA6DFF2FD
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 13:31:49 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project presents:

        nfacct 1.0.2

nfacct is the command line tool to create/retrieve/delete accounting
objects.

See ChangeLog that comes attached to this email for more details.

You can download it from:

ftp://ftp.netfilter.org/pub/nfacct/
http://www.netfilter.org/projects/nfacct/downloads.html

Have fun!

P.S: I'm updating the website at this moment, so first link to FTP
allows you a quick fetch of the package.

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-nfacct-1.0.2.txt"

Alexey Perevalov (2):
      nfacct: check cmd line argument for singleness
      nfacct: add filter in to the list operation

Felix Janda (1):
      include: Sync with kernel headers

Gustavo Zacarias (1):
      configure: uclinux is also linux

Harald Welte (1):
      Add JSON output formatting to nfacct utility

Mathieu Poirier (2):
      nfacct: adding quota capabilities
      src: remove unnecessary end of line check

Pablo Neira Ayuso (3):
      nfacct: fix packet and bytes counters length in restore operation
      nfacct: simplify nfacct_cmd_monitor
      build: bump version to 1.0.2

Thomas Jarosch (1):
      nfacct: Improve 'flush' man page entry


--huq684BweRXVnRxX--
