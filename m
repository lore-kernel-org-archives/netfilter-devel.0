From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 1.0.6 release
Date: Mon, 22 Aug 2016 13:02:43 +0200
Message-ID: <20160822110243.GA29021@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Cc: lwn@lwn.net
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57360 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755150AbcHVLC5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 07:02:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5282E186ADC
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 13:02:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 428EF100A6F
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 13:02:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E173D100A65
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 13:02:51 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project presents:

        libnetfilter_conntrack 1.0.6

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table. The
library libnetfilter_conntrack has been previously known as
libnfnetlink_conntrack and libctnetlink. This library is currently used
by conntrack-tools among many other applications.

See ChangeLog that comes attached to this email for more details.

You can download it from:

ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/
http://www.netfilter.org/projects/libnetfilter_conntrack/downloads.html

Have fun!

P.S: I'm updating the website at this moment, so first link to FTP
allows you a quick fetch of the package.

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnetfilter_conntrack-1.0.6.txt"

Arturo Borrero (3):
      src: add support for IPv6 to struct __nfct_nat
      src: add support for IPv6 NAT
      qa: update test_api with IPv6 NAT

Daniel Borkmann (1):
      conntrack: add zone attribute to tuple

Florian Westphal (2):
      setter: don't touch snat.max_ip in set_attr_dnat_ipv4
      conntrack: labels: add function to fetch default config file location

Kevin Cernekee (1):
      src: Make the library compile under clang

Pablo Neira Ayuso (1):
      build: bump version to 1.0.6


--0F1p//8PRICkK4MW--
