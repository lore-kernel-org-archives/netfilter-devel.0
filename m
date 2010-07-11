From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_queue 1.0.0 release
Date: Sun, 11 Jul 2010 18:00:21 +0200
Message-ID: <4C39EA95.2080806@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090803040406030006070300"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41856 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab0GKQAm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jul 2010 12:00:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090803040406030006070300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter proudly project presents:

  * libnetfilter_queue-1.0.0

libnetfilter_queue is a userspace library providing an API to packets
that have been queued by the kernel packet filter. It is is part of a
system that deprecates the old ip_queue / libipq mechanism.

See ChangeLog (file attached) for more details on this release. You can
download it from:

http://www.netfilter.org/projects/libnetfilter_queue/downloads.html
ftp://ftp.netfilter.org/pub/libnetfilter_queue/

Cheers,
Pablo (on behalf of the Netfilter Core Team)

--------------090803040406030006070300
Content-Type: text/plain;
 name="changes-libnetfilter_queue-1.0.0.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="changes-libnetfilter_queue-1.0.0.txt"

Alessandro Vesely (1):
      doc: document possible verdicts on packets and minor change in example

David Fabro (4):
      non-modified payload arguments are pointer-to-const
      payload buffer datatypes are consistent
      added .gitignore for base directory
      doc: enhancements

Holger Hans Peter Freyther (1):
      doc: make doxygen.cfg.in work with doxygen 1.6.1

Pablo Neira Ayuso (11):
      nfq: add minor comment in the documentation to warn about privileges
      nfq: deprecate nfq_set_verdict_mark() in favour of nfq_set_verdict2()
      doc: remove references to deprecated nfq_set_verdict_mark()
      add nfq_snprintf_xml() to output a packet in XML format
      nfq: fix compilation warning in nfq_snprintf_xml()
      nfq: consistent nfq_snprintf_xml() return value with snprintf()
      nfq: fix HW address output in nfq_snprintf_xml()
      nfq: remove `0x' from HW protocol in output of nfq_snprintf_xml()
      nfq: remove libipq.h
      build: add libtool m4 support
      nfq: bump version to 1.0.0

Patrick McHardy (1):
      remove libipq_compat


--------------090803040406030006070300--
