From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] Release of libnfnetlink,
	libnfnetlink_conntrack and libnetfilter_queue
Date: Thu, 11 Jan 2007 01:58:59 +0100
Message-ID: <45A58BD3.1010000@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070703040805050801090809"
Cc: lwn@lwn.net
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-announce@lists.netfilter.org,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070703040805050801090809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents:

	libnfnetlink-0.0.25
	libnfnetlink_conntrack-0.0.50
	libnetfilter_queue-0.0.13

libnfnetlink
	is the low-level userspace library for nfnetlink based
	communication between the kernel-side netfilter and the
	userspace world.

libnfnetlink_conntrack
	is the library for userspace access to the in-kernel connection
	tracking table.

libnetfilter_queue
	is the library to filter and mangle packets from userspace

You can download the three releases from
	http://www.netfilter.org/projects/libnfnetlink/files/libnfnetlink-0.0.25.tar.bz2
http://www.netfilter.org/projects/libnetfilter_conntrack/files/libnetfilter_conntrack-0.0.50.tar.bz2

http://www.netfilter.org/projects/libnetfilter_queue/files/libnetfilter_queue-0.0.13.tar.bz2

Attached to this email the changelog. Upgrade is recommended.

Happy firewalling,

	Pablo Neira Ayuso (for the Netfilter Project)

p.s: the signature verification can complain about the key expiration
date, sorry for that, we are still in the process of the renewal.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------070703040805050801090809
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

libnfnetlink 0.0.25
======================================================================

Changes from 0.0.16:

- Add iterator API
	[ Pablo Neira ]

- Add replacements for nfnl_listen and nfnl_talk
	[ Pablo Neira ]

- Fix error handling
	[ Pablo Neira ]

- Add assertions
	[ Pablo Neira ]

- Add documentation
	[ Pablo Neira ]

- Minor cleanups
	[ Pablo Neira ]

- Initialize callback structure
	[ Victor Stinner ]

libnetfilter_conntrack 0.0.50
======================================================================

Changes from 0.0.31:

- Introduce new API and documentation
	[ Pablo Neira ]

- Fix minor nitpick in the XML output
	[ Victor Stinner ]

- Minor fix in the counters parsing
	[ Pablo Neira ]

- Implement getter for the ATTR_USE attribute
	[ Victor Stinner ]

- ATTR_*_COUNTER_*, ATTR_USE and ATTR_ID are unsettable
	[ Victor Stinner ]

libnetfilter_queue 0.0.13
======================================================================

Changes from 0.0.12:

- Set maximum queue length
	[ Eric Leblond ]

--------------070703040805050801090809--
