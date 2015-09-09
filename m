From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 1.0.5
Date: Wed, 9 Sep 2015 17:56:04 +0200
Message-ID: <20150909155604.GA5912@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnetfilter_conntrack 1.0.5

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table. The
library libnetfilter_conntrack has been previously known as
libnfnetlink_conntrack and libctnetlink. This library is currently
used by conntrack-tools among many other applications.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/downloads.html
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Have fun!

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnetfilter_conntrack-1.0.5.txt"

Felix Janda (2):
      include: Sync with kernel headers
      src: Use stdint types everywhere

Florian Westphal (3):
      conntrack: labels: remove dead code
      qa: add cmp ATTR_ZONE regression test cases
      conntrack: compare: relax MARK/ZONE attribute comparision

Gustavo Zacarias (2):
      configure: uclinux is also linux
      src/Makefile.am: drop hardcoded -ldl

Ken-ichirou MATSUZAWA (10):
      conntrack: mnl: fix parsing payload len
      conntrack: remove duplicate code
      qa: update cmp ATTR_ZONE size mark and zone
      conntrack: api: add two new bitmask functions
      qa: add tests for new bitmask functions
      doc: fix symbol name typo in comment
      qa: build unshared nfct environment
      conntrack: add mark event filter
      qa: add test for mark event filter
      conntrack: fix stop timestamp assignment

Pablo Neira Ayuso (3):
      src: fix documentation regarding nfct_catch() and nfexp_catch()
      build: bump version to 1.0.5
      qa: Keep ct_echo_event and ct_mark_filter out from Makefile.am


--8t9RHnE3ZwKMSgU+--
