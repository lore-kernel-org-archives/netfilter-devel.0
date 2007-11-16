From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.0.82 release
Date: Fri, 16 Nov 2007 14:02:17 +0100
Message-ID: <473D94D9.2050701@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060301030308010207010401"
Cc: netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter-announce@lists.netfilter.org, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060301030308010207010401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents libnetfilter_conntrack-0.0.82

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table.

This release includes TCP flags support and one bugfix for big-endian
platforms. See ChangeLog for more details. Upgrade is recommended.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo (on behalf of the Netfilter Project)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------060301030308010207010401
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

libnetfilter_conntrack 0.0.82
======================================================================

Changes from 0.0.81:

- add support for TCP flags
	[Pablo Neira Ayuso]

- Fix big-endian issues with getters
	[Philip Craig]

--------------060301030308010207010401--
