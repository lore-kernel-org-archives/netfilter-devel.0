From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] Release conntrack-tools 0.9.5
Date: Sun, 29 Jul 2007 16:14:13 +0200
Message-ID: <46ACA0B5.7030608@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030302010800080706070103"
To: netfilter-announce@lists.netfilter.org,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	lwn@lwn.net
Return-path: <netfilter-bounces@lists.netfilter.org>
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
--------------030302010800080706070103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi!

The netfilter project proudly presents another development release of
the conntrack-tools. The conntrack-tools are:

- The userspace daemon so-called conntrackd that covers the specific
aspects of stateful Linux firewalls to enable high availability
solutions. It can be used as statistics collector of the firewall use as
well. The daemon is highly configurable and easily extensible.

- The command line interface (CLI) conntrack that provides an interface
to add, delete and update flow entries, list current active flows in
plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush the
complete connection tracking table among many other.

You can download it from:

http://www.netfilter.org/projects/conntrack-tools/downloads.html

Changelog is attached.

Pablo (on behalf of the Netfilter Project)

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.

--------------030302010800080706070103
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

version 0.9.5 (2007/07/29)
------------------------------

= conntrackd =
o conntrack-tools requires libnetfilter_conntrack >= 0.0.81 
o add len field to nethdr
o implement buffered send/recv to batch messages
o use buffer of MTU size
o stop using netlink format for network messages: use similar TLV-based format
o reduce synchronization messages size up to 60%
o introduce periodic alive messages for sync-nack protocol
o timeslice alarm implementation: remove alarm pthread, remove locking
o simplify debugging functions: use nfct_snprintf instead
o remove major use of libnfnetlink functions: use libnetfilter_conntrack API
o deprecate conntrackd -F, use conntrack -F instead
o major rework of the network infrastructure: much simple, less messy
o simplify cache_flush function: use cache_del()
o remove current script_fault.sh when we reach fault state
o conntrackd requires the connection tracking event API: insist more in INSTALL

= conntrack =
o better protocol argument checkings
o fix per-protocol filtering, eg. conntrack -L -p tcp 
o show per-protocol help, ie. conntrack -h -p tcp
o add alias --src for --orig-src and alias --dst for --orig-dst
o include protocol filters in the manpage

--------------030302010800080706070103--
