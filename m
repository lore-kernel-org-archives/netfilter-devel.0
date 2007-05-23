From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Release conntrack-tools 0.9.3
Date: Wed, 23 May 2007 21:41:45 +0200
Message-ID: <465498F9.8000804@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090300010505060002080807"
To: netfilter-announce@lists.netfilter.org,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	lwn@lwn.net
Return-path: <netfilter-announce-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-announce>
List-Post: <mailto:netfilter-announce@lists.netfilter.org>
List-Help: <mailto:netfilter-announce-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-announce-bounces@lists.netfilter.org
Errors-To: netfilter-announce-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090300010505060002080807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents conntrack-tools-0.9.3

The userspace daemon conntrackd covers the specific aspects of stateful
Linux firewalls to enable high availability solutions, and can be used
as statistics collector of the firewall use as well. The daemon is
highly configurable and easily extensible. On the other hand, the
command line conntrack provides an interface to add, delete and update
flow entries, list current active flows and flush the complete
connection tracking table.

You can download it from:

http://www.netfilter.org/projects/conntrack-tools/files/conntrack-tools-0.9.3.tar.bz2

Enjoy,

	Pablo (on behalf of the Netfilter Project)

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris



--------------090300010505060002080807
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

version 0.9.3
-------------

= conntrackd =
o fix commit of confirmed expectations (reported by Nishit Shah)
o fix double increment of counters in cache_update_force() (Niko Tyni)
o nl_dump_handler must return NFCT_CB_CONTINUE (Niko Tyni)
o initialize buffer in nl_event_handler() and nl_dump_handler() (Niko Tyni) 
o CacheCommit value can be set via conntrackd.conf for the NACK approach
o fix leaks in the hashtable/cache flush path (Niko Tyni)
o fix leak if a connection already exists in the cache (Niko Tyni)
o introduce a new header that encapsulates netlink messages
o remove all '_entry' tail from all functions in cache.c
o split cache.c: move cache iterators to file cache_iterators.c
o fix inconsistencies in the cache API related to counters
o cleanup 'usage' message
o fix typo in examples/sync/nack/node1/conntrackd.conf
o introduce message checksumming as described in RFC1071 (enabled by default)
o major cleanups in the synchronization code
o just warn once that the maximum netlink socket buffer has been reached
o fix ignore conntrack entries by IP and introduce ignore pool abstraction layer
o introduce netlink socket buffer overrun handler
o constification of hash, compare and hashtable_test functions in hash.c
o introduce ACKnowledgement mechanisms to reduce the size of the resend queue
o remove OK messages at startup since provide useless data
o fix compilation warning in mcast.c: recvfrom takes socklen_t not size_t
o add a lock per buffer: makes buffer code thread safe
o introduce 'Replicate' clause to explicitely set states to be replicated
o kill cache feature abuse: introduce nicer cache hooks for sync algorithms
o fix oversized buffer allocated in the stack in the cache functions
o add support to dump internal/external cache in XML format '-x'
o add script for keepalived fault state (eg. unplugged cable/link down)

= conntrack =
o port conntrack to the new libnetfilter_conntrack API
o introduce '--output xml,extended,timestamp' option for '-L', '-G' and '-E'
o deprecated '--id'
o replace '-a' by '--src-nat' and '--dst-nat'
o use positive logic in error handling
o remove sctp support until is fully supported in the kernel side
o update conntrack manpage
o update test.sh file in examples/cli/
o several fixes for the output of usage messages

--------------090300010505060002080807--
