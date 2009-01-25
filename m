From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 0.9.10 released
Date: Sun, 25 Jan 2009 22:05:30 +0100
Message-ID: <497CD41A.3040106@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040803020903090905020507"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040803020903090905020507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project presents another development release of the
conntrack-tools. As usual, this release includes important fixes,
improvements and new features, mainly:

= command line interface: conntrack =

*  New option `-C': you can use it to display the number of entries in
the conntrack and expectation tables.

= userspace daemon: conntrackd =

* Internal performance improvements: important rework of the
hashtable/caching/queueing infrastructure; single output path for state
transmissions; improved event-driven architecture. See ChangeLog
attached for more details.

* Support for multi-dedicated links: you can define a pool of dedicated
links, ie. if the current dedicated link fails, another available in the
pool is selected to propagate state-changes. See the example files under
doc/ for more information.

* Extended statistics information: you can display networking, caching,
runtime and queueing statistics with `conntrackd -s [type]'. See the
manpage for more information on the statistics types.

* Polling (or batch-based) synchronization: you can configure the daemon
to send batches periodically instead of the soft real-time state
synchronization. This allows you to set up a relaxed replication while
consuming less computational resources. See `PollSecs' clause.

Q: How stable are the conntrack-tools?
A: This software is under development. Nevertheless, it has been tested
in a cluster environment composed of two stateful firewalls running
Debian 4.0 (Etch) with a Linux kernel 2.6.28, keepalived 1.1.15, using
conntrackd in FT-FW mode, randomly (in periods of 10 seconds) setting
links down to force the fail-over between the nodes. The results has
shown no hangs/closure in any TCP connection.

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

On behalf of the Netfilter Project,
Pablo.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------040803020903090905020507
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

Pablo Neira Ayuso (48):
      headers: delete unused flags in conntrackd.h
      src: add network statistics via `-s network'
      src: add cache statistics via `-s cache'
      src: add run-time statistics via `-s runtime'
      sync-mode: remove unnecessary split lines
      conntrackd: fix missing \n in conntrackd -h
      cache_iterators: display the commit time taken in the logs
      cache_iterators: add total entries available in the cache to stats
      cache: fix ENOSPC errors due to over-population of inactive entries
      filter: skip filtering by state if the event has no state info
      run: show current netlink buffer size in `-s runtime'
      netlink: don't double the netlink buffer twice during resize
      src: constify hashtable parameter in hash() callbacks
      hashtable: use calloc instead of malloc + memset
      hashtable: check NULL instead of ! for pointers
      filter: add prefix ct_filter_ to hash and compare functions
      run: limit the number of iterations over the event handling
      src: rework of the hash-cache infrastructure
      cache: add status field to store the object status
      run: relax resynchronization algorithm when netlink overruns
      sync: unify tx_list and tx_queue into one single tx_queue
      ftfw: move helloing to ftfw_xmit()
      sync: add generic tx_queue for all synchronization modes
      sync: enqueue state updates to tx_queue
      network: do not re-set the message type in nethdr_set* functions
      src: support for redundant dedicated links
      src: rename overrun handler to resync handler
      src: remove register_fds hooks
      src: add state polling support (oppossed to current event-driven)
      cache: add objects statistics
      ftfw: add ResendQueueSize and deprecate ResendBufferSize clauses
      src: add `-s queue' and change `-v' behaviour
      conntrack: add -C command to display the counter
      src: obsolete `DestroyTimeout' clause
      conntrack: fix use of -u which is optional with -I
      cache_iterators: start a clean session if commit finds an entry
      cache: remove nl_exist_conntrack() function
      cache: mangle timeout inside nl_*_conntrack() functions
      src: don't clone when calling nl_*_conntrack functions
      src: change behaviour of `-t' option
      cache: move lifetime feature to main cache code
      src: add support for approximate timeout calculation during commit
      src: increase default PurgeTimeout value
      netlink: set IP_CT_TCP_FLAG_CLOSE_INIT for TIME_WAIT states
      doc: unset CommitTimeout by default
      doc: use 'From' instead of 'from' in the example configfiles
      doc: increase hashtable bucket size and limits in example files
      configure: bump version to 0.9.10


--------------040803020903090905020507--
