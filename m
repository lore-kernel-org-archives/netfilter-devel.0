From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.0.100 release
Date: Thu, 16 Jul 2009 12:23:20 +0200
Message-ID: <4A5EFF98.2020705@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050108010806050100020705"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050108010806050100020705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter project presents libnetfilter_conntrack-0.0.100.

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table. This
library requires a linux kernel >= 2.6.18.

This release includes a couple of minor fixes. See ChangeLog for more
details.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo,
on behalf of the Netfilter Core Team.

--------------050108010806050100020705
Content-Type: text/plain;
 name="changes-libnetfilter_conntrack-0.0.100.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-libnetfilter_conntrack-0.0.100.txt"

Pablo Neira Ayuso (31):
      src: remove old deprecated API
      build: reset age interface since old API has been removed
      src: remove reminiscent of NFCT_DIR_ORIGINAL and old prototypes
      src: add support for GRE transport protocol
      src: add support for UDPlite transport protocol
      include: deprecate several header files with obsolete enums
      src: remove debian/ directory
      header: refresh nfnetlink_conntrack.h copy
      src: add initial DCCP support
      snprintf: remove duplicated protocol string definitions
      snprintf: fix missing protocol state support in XML output
      snprintf: fix output of GRE dstkey in XML
      parse: fix SCTP vtag parsing
      snprintf: fix missing port output in DCCP
      copy: add missing ATTR_DCCP_STATE in nfct_copy()
      src: add DCCP role attribute
      api: add new callback interface while keeping backward compatibility
      snprintf: perform strict checking for the protocol state value
      include: shrink helper name field to 16 bytes
      tcp: add support for SYN_SENT2 state
      src: recover some obsolete enums and constants not to break backward
      configure: this library requires libnfnetlink 1.0.0
      build: remove unrequired checking in the protocol information
      bsf: add support for IPv6 address filtering
      src: add support for DCCP 64-bits sequence number tracking
      headers: include u64 get/set prototype in libnetfilter_conntrack.h
      src: rename ATTR_DCCP_SEQ by ATTR_DCCP_HANDSHAKE_SEQ
      dccp: fix endianess in handshake_seq
      expect: add new callback interface while keeping backward compatibility
      src: unset all the callback handler in the nfct_close() path.
      configure: bump version to 0.0.100


--------------050108010806050100020705--
