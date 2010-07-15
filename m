From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_log 1.0.0 release
Date: Thu, 15 Jul 2010 14:17:42 +0200
Message-ID: <4C3EFC66.7050400@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040905070107070405080301"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040905070107070405080301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter proudly project presents:

  * libnetfilter_log-1.0.0

libnetfilter_log is a userspace library providing interface to packets
that have been logged by the kernel packet filter. It is is part of a
system that deprecates the old syslog/dmesg based packet logging.

This releases contains a new function to print logs in XML format and
the doxygen-based documentation. See Changelog for details.

You can find the documentation in doxygen format at:
http://www.netfilter.org/projects/libnetfilter_log/doxygen/

You can download it from:
http://www.netfilter.org/projects/libnetfilter_queue/downloads.html
ftp://ftp.netfilter.org/pub/libnetfilter_queue/

happy logging,
Pablo (on behalf of the Netfilter Core Team)

--------------040905070107070405080301
Content-Type: text/plain;
 name="changes-libnetfilter_log-1.0.0.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="changes-libnetfilter_log-1.0.0.txt"

Pablo Neira Ayuso (11):
      fix segfault in example in nflog_get_payload()
      add nflog_snprintf_xml() to output a log in XML format
      nflog: consistent nflog_snprintf_xml() return value with snprintf()
      nflog: fix HW address output in nfq_snprintf_xml()
      nflog: remove `0x' from HW protocol in output of nflog_snprintf_xml()
      nflog: do not default to NFLOG_XML_HW in nflog_snprintf_xml()
      nflog: revert previous patch
      build: add libtool m4 support
      doc: add libnetfilter_log doxygen documentation and update copyright notice
      build: add LIBVERSION to Makefile.am
      nfq: fix redundant LIBVERSION definition


--------------040905070107070405080301--
