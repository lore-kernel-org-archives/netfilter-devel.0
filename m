From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnfnetlink and libnetfilter_* libraries release
Date: Fri, 27 Jun 2008 15:52:50 +0200
Message-ID: <4864F0B2.5060002@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000309000103060805090106"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48757 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751147AbYF0Nw4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:52:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000309000103060805090106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents:

  * libnfnetlink-0.0.39
  * libnetfilter_conntrack-0.0.95
  * libnetfilter_queue-0.0.16
  * libnetfilter_log-0.0.14

This release set includes bugfixes for the userspace netfilter
libraries. See ChangeLog for more details. Upgrade is recommended.

You can download them from:

http://www.netfilter.org
ftp://ftp.netfilter.org

Enjoy,
Pablo - on behalf of the Netfilter Project.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers




--------------000309000103060805090106
Content-Type: text/plain;
 name="changelog-libnetfilter_conntrack"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changelog-libnetfilter_conntrack"

Fabian Hugelshofer (1):
      Use union of char buffer and message header to ensure proper byte

Pablo Neira Ayuso (2):
      fix wrong ATTR_*_L3PROTO handling in the message building
      bump version to 0.0.95


--------------000309000103060805090106
Content-Type: text/plain;
 name="changelog-libnetfilter_log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changelog-libnetfilter_log"

KOVACS Krisztian (1):
      libnetfilter_log pkt-config changes 

Patrick McHardy (1):
      Add NFULA_GID support

Fabian Hugelshofer (1):
      Use union to ensure proper alignment

Pablo Neira Ayuso (1):
      bump version to 0.0.14

--------------000309000103060805090106
Content-Type: text/plain;
 name="changelog-libnetfilter_queue"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changelog-libnetfilter_queue"

Paul P. Komkoff (1):
      fix compilation issues on newer toolchains

Fabian Hugelshofer (1):
      fix alignment issues

Jan Engelhardt (1):
      libnfq: mark functions as extern C

Pablo Neira Ayuso (2):
      bump version to 0.0.16 and bump libnfnetlink dependencies

--------------000309000103060805090106
Content-Type: text/plain;
 name="changelog-libnfnetlink"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changelog-libnfnetlink"

Fabian Hugelshofer (1):
      Aligns buffers to maximum alignment of architecture

Jan Engelhardt (1):
      libnfnetlink: mark functions as extern C

Pablo Neira Ayuso (1):
      bump version to 0.0.39


--------------000309000103060805090106--
