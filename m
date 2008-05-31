From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.0.94 release
Date: Sat, 31 May 2008 18:30:36 +0200
Message-ID: <48417D2C.7040002@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010008090205090008040507"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010008090205090008040507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents libnetfilter_conntrack-0.0.94

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table.

This release includes new features and minor fixes. See ChangeLog for
more details. Upgrade is recommended.

This library requires a linux kernel >= 2.6.18.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo (on behalf of the Netfilter Project)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers



--------------010008090205090008040507
Content-Type: text/plain;
 name="Changelog-libnetfilter_conntrack"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Changelog-libnetfilter_conntrack"

Krzysztof Oledzki (1):
      add ICMPv6 support
      fix "type", "code" and "id": in reply direction were always set to 0

Pablo Neira Ayuso (5):
      add nfct_copy function
      add nfct_cmp function (this function replaces nfct_compare)
      fix __nfct_l4 structure layout (specifically, ICMP)
      add full support of SCTP
      fix segfault while getting the conntrack ID
      add nfct_send function
      check for pkg-config at configure stage
      fix missing bitset in the autocomplete code

--------------010008090205090008040507--
