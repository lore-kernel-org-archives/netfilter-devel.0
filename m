From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.0.102 release
Date: Thu, 15 Jul 2010 20:42:24 +0200
Message-ID: <4C3F5690.8030706@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080100070705050901000202"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080100070705050901000202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter project presents libnetfilter_conntrack-0.0.102.

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table. This
library requires a linux kernel >= 2.6.18.

This release includes six fixes and Patrick McHardy's conntrack zone
support (see the 'CT' target in man iptables(8) for more information).
ChangeLog is also attached for more details.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo,
on behalf of the Netfilter Core Team.


--------------080100070705050901000202
Content-Type: text/plain;
 name="changes-libnetfilter_conntrack-0.0.102.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="changes-libnetfilter_conntrack-0.0.102.txt"

Pablo Neira Ayuso (9):
      header: counters are 64-bits long
      src: add support for TCP window scale factor
      parse: fix access to u64 attributes in netlink messages
      ct: add zone support
      ct: print zone before use
      bsf: fix filtering for several network address/mask
      ct: add missing setters for TCP window scale factor support
      ct: fix NAT sequence adjustment setter
      build: bump version to 0.0.102


--------------080100070705050901000202--
