From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.0.89 release
Date: Fri, 07 Mar 2008 19:55:02 +0100
Message-ID: <47D18F86.9060004@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080202090204060801000306"
Cc: netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter-announce@lists.netfilter.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53404 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751866AbYCGSzO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:55:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080202090204060801000306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents libnetfilter_conntrack-0.0.89

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table.

This release includes new features and minor fixes. See ChangeLog for
more details. Upgrade is recommended.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo (on behalf of the Netfilter Project)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers


--------------080202090204060801000306
Content-Type: text/plain;
 name="ChangeLog-libnetfilter_conntrack-0.0.89"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog-libnetfilter_conntrack-0.0.89"

libnetfilter_conntrack v0.0.89 Changelog (in chronological order)
======================================================================
Changes from 0.0.82:

- Deprecate old libnetfilter_conntrack API
	[ Pablo Neira Ayuso ]

- Add support for conntrack master setup
	[ Pablo Neira Ayuso ]

- Rename libnetfilter_conntrack.c to main.c
	[ Pablo Neira Ayuso ]

- Include examples on how to add a new related conntrack
	[ Pablo Neira Ayuso ]

- Fix several compilation warnings
	[ Pablo Neira Ayuso ]

- Add support for secmark
	[ Pablo Neira Ayuso ]

- Add support for UDPLITE
	[ Pablo Neira Ayuso ]

- Add NFCT_OF_TIME flag to nfct_snprintf
	[ Pablo Neira Ayuso ]

- Several cleanups in Makefile.am
	[ Pablo Neira Ayuso ]

- Add support for NAT sequence adjustment
	[ Pablo Neira Ayuso ]

- Fix glibc 2.7.20 compilation
	[ Paul P. Konkoff ]

--------------080202090204060801000306--
