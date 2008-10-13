From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.0.97 release
Date: Mon, 13 Oct 2008 14:29:14 +0200
Message-ID: <48F33F1A.3000806@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040600000501080305000902"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040600000501080305000902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents libnetfilter_conntrack-0.0.97.

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table. This
library requires a linux kernel >= 2.6.18.

This release includes minor fixes, some enhancements and cleanups. See
ChangeLog for more details.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo,
on behalf of the Netfilter Project.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------040600000501080305000902
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

Albert Veli (1):
      API: fix endianess issue

Pablo Neira Ayuso (7):
      add comment in expect_create test file
      add berkeley socket filtering high-level API
      Extend high-level API for netlink BSF to add negative logic
      bsf: use ntohl instead of htonl in the example
      cleanup: split internal.h into several internal header files
      compare: add two new flags for different level of comparisons
      helper: explicit helper assignation support


--------------040600000501080305000902--
