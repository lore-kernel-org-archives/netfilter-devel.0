From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 0.9.9 released
Date: Thu, 18 Dec 2008 12:27:11 +0100
Message-ID: <494A338F.8020603@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050205060008020901080106"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050205060008020901080106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents another development release of
the conntrack-tools. This release includes important updates, fixes and
improvements. See changelog for details.

Q: What are the conntrack-tools?
A: The conntrack-tools are:

- The userspace daemon so-called conntrackd that covers the specific
aspects of stateful Linux firewalls to enable high availability
solutions. It can be used as statistics collector of the firewall use as
well. The daemon is highly configurable and easily extensible.

- The command line interface (CLI) conntrack that provides an interface
to add, delete and update flow entries, list current active flows in
plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush the
complete connection tracking table among many other.

Q: Where can I download it from?
A: http://www.netfilter.org/projects/conntrack-tools/downloads.html

Q: Where can I get more information about them?
A: http://conntrack-tools.netfilter.org

Q: Where can I have a look at the user manual?
A: http://conntrack-tools.netfilter.org/manual.html

Q: What are the main changes in this release?
A: The main changes in the conntrack command line interface are:
- filtering support for related connections (-L --status EXPECTED)
- several manpage updates
A: The main changes in the conntrackd user-space daemon are:
- new message format in the replication protocol (note that this breaks
backward compatibility with previous conntrack-tools releases)
- several performance improvements
- CIDR-based filtering support
- fixes and improvements in the state injection to kernel (aka. committing)
- several cleanups

On behalf of the Netfilter Project,
Pablo

Enjoy!

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers




--------------050205060008020901080106
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

Pablo Neira Ayuso (65):
      ftfw: rise the size of the acknowledgment window in the example
      conntrack: add missing -U in conntrack(8) manpage
      ftfw: add option `-v' to output debugging information (if any)
      ftfw: remove bottleneck in ack/nack handling
      network: remove message omission test-code
      network: add protocol version field (breaks backward compatibility)
      network: rework TLV-based protocol
      filter: use XOR instead of branches
      filter: use jhash2 instead of jhash for IPv6 addresses
      filter: remove useless branch in the check functions
      conntrack: --status should not be mandatory with -I
      filter: choose the filtering method via configuration file
      conntrack: cleanup command line tool protocol extensions
      build: add attribute header size to total attribute length
      filter: CIDR-based filtering support
      run: release fds structure in the exit path
      fds: remove unused array of file descriptors
      ftfw: remove useless ftfw_run invocation in the alive alarm handler
      src: move callbacks to run.c for better readability
      conntrack: do_parse_parameter show warning to stderr (not to stdout)
      conntrack: remove hardcoded buffer size, use sizeof instead
      conntrack: support diminutives for -L
      conntrack: move release options code to free_options()
      config: move `Checksum' inside `Multicast' clause
      network: make tx buffer initialization independent of mcast config
      manpage: add notice about conntrackd version incompatibilities
      conntrack: add new --status EXPECTED to filter expected connections
      manpage: add --status FIXED_TIMEOUT and EXPECTED
      build: do not include NTA_TIMEOUT in the replication messages
      netlink: clone conntrack object while creation/update
      netlink: use NFCT_Q_[CREATE|UPDATE] instead of NFCT_Q_CREATE_UPDATE
      netlink: constify conntrack object parameter of nl_*_conntrack()
      netlink: remove unnecessary whitespace lines in netlink.h
      netlink: unset ATTR_HELPER_NAME to avoid EBUSY in nl_update_conntrack()
      parse: fix missing master layer 4 protocol number assignation
      network: remove unused function mcast_send_netmsg()
      network: remove length parameter of mcast_buffered_send_netmsg()
      network: remove __do_send() function
      network: remove the netpld header from the messages
      network: fix data offset alignment returned by NTA_DATA macro
      parse: strict attribute size checking
      src: recover conntrackd -F operation
      run: better wait() error handling
      netlink: fix EILSEQ error messages due to process race condition
      cache_iterators: use a cloned object while resetting timers
      netlink: build TCP flags/mask only if this is a TCP connection
      netlink: conditional build of TCP flags/mask for updates
      netlink: do not build the reply tuple in update messages
      configure: conntrack-tools requires libnetfilter_conntrack 0.0.99
      network: use NET_T_* instead of NFCT_Q_*
      ftfw: do not check for data messages in tx_queue_xmit
      ftfw: resync messages can be retransmitted
      network: do more strict message type checking
      ftfw: shrink alive message size
      sync-mode: check if message type is >= NET_T_STATE_MAX before parsing
      src: cleanup, rename hashtable_test() by hashtable_find()
      cache: cleanup, rename __del2() by __del()
      netlink: log report initial netlink event socket buffer size
      doc: fix typo SocketBufferSizeMaxGrowth in example conffiles
      doc: document the netlink buffer size clauses
      doc: better documentation about ResendBufferSize
      doc: add note on McastSndSocketBuffer and McastRcvSocketBuffer
      netlink: fix type in warning message on SocketBufferSizeMaxGrowth
      automake: add missing cidr.h
      configure: bump version to 0.9.9


--------------050205060008020901080106--
