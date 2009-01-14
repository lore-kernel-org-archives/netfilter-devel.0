From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnfnetlink 0.0.40 release
Date: Wed, 14 Jan 2009 11:56:20 +0100
Message-ID: <496DC4D4.6060106@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070306060509090701090507"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39679 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753709AbZANK4b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:56:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070306060509090701090507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents:

  * libnfnetlink-0.0.40

libnfnetlink is the low-level library for netfilter related
kernel/userspace communication. It provides a generic messaging
infrastructure for in-kernel netfilter subsystems (such as
nfnetlink_log, nfnetlink_queue, nfnetlink_conntrack) and their
respective users and/or management tools in userspace.

This release includes a couple of updates for the interface2index
infrastructure one bugfix. See ChangeLog for more details.

You can download it from:

http://www.netfilter.org/projects/libnfnetlink/downloads.html
ftp://ftp.netfilter.org/pub/libnfnetlink/

Enjoy,
Pablo - on behalf of the Netfilter Project.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------070306060509090701090507
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

Eric Leblond (1):
      Suppress iftable_up function which is not used.

Jan Engelhardt (1):
      libnfnetlink: mark functions as extern C

Pablo Neira Ayuso (5):
      bump version to 0.0.39
      conditional compilation of testsuite utils
      nlif: fix possible re-insertion in the list of interfaces
      iftable: add nlif_get_ifflags to get the network interface flags
      configure: bump version to 0.0.40


--------------070306060509090701090507--
