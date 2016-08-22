From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 1.4.4 release
Date: Mon, 22 Aug 2016 13:06:51 +0200
Message-ID: <20160822110651.GA29083@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Transfer-Encoding: 8bit
Cc: lwn@lwn.net
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project presents:

        conntrack-tools 1.4.4

The conntrack-tools are a set of tools targeted at system
administrators. They are conntrack, the userspace command line
interface, and conntrackd, the userspace daemon. The tool conntrack
provides a full featured interface that is intended to replace the old
/proc/net/ip_conntrack interface. Using conntrack, you can view and
manage the in-kernel connection tracking state table from userspace.  On
the other hand, conntrackd covers the specific aspects of stateful
firewalls to enable highly available scenarios, and can be used as
statistics collector as well.

See ChangeLog that comes attached to this email for more details.

You can download it from:

ftp://ftp.netfilter.org/pub/conntrack-tools/
http://www.netfilter.org/projects/conntrack-tools/downloads.html

Have fun!

P.S: I'm updating the website at this moment, so first link to FTP
allows you a quick fetch of the package.

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="changes-conntrack-tools-1.4.4.txt"
Content-Transfer-Encoding: 8bit

Arturo Borrero (6):
      configure.ac: improve feature selection
      conntrackd: add systemd support
      conntrack-tools: add conntrackd.conf(5) manpage
      dist: include tests/ directory and files in tarball
      conntrackd: add support for NTA_(S|D)NAT_IPV6
      include/network.h: fix erroneus comment in NTA_(S|D)NAT_IPV6

Asbjørn Sloth Tønnesen (15):
      Revert "conntrack: fix expectation entry creation"
      conntrack: fix expectation entry creation
      tests: conntrack: run testfiles in the correct order
      tests: conntrack: flush stdout to keep sync
      tests: conntrack: ignore dot files in testdir
      tests: conntrack: use local conntrack binary
      conntrack: support delete by label
      conntrack: consolidate filtering
      conntrack: cleanup: use switch statements for family checks
      conntrack: add support for netmask filtering
      tests: conntrack: add netmask tests
      conntrack: split up nfct_set_addr_from_opt()
      conntrack: extend parse_addr() with CIDR support
      conntrack: add support for CIDR notation
      tests: conntrack: add tests for CIDR notation

Daniel Borkmann (1):
      conntrack: add zone direction support

Mart Frauenlob (10):
      conntrack: Add missing tables dying and unconfirmed to usage output.
      conntrackd: man: remove bogus characters
      conntrackd: remove unnecessary separator character from usage output.
      conntrack: show --src and --dst options in usage output.
      conntrack: man: add options --src and --dst.
      conntrack: man: Add description of tables dying and unconfirmed.
      nfct: add missing commands to usage output.
      nfct: correct command list in timeout usage error message.
      nfct: helper: correct error messages.
      nfct: man: add missing comands

Pablo Neira Ayuso (2):
      conntrackd: Disable runtime systemd support by default
      conntrack-tools 1.4.4 release

Rodrigo Rebello (1):
      src: fix build with musl libc

Shivani Bhardwaj (1):
      configure: Remove flex check warning


--n8g4imXOkfNTN/H1--
