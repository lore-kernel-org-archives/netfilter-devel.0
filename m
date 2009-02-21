From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 0.9.11 released
Date: Sat, 21 Feb 2009 18:40:03 +0100
Message-ID: <49A03C73.8010004@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060409050204020900080407"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060409050204020900080407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project presents another development release of the
conntrack-tools that includes accumulated fixes, one improvement for the
polling approach and a couple of new features, mainly:

= command line interface: conntrack =

*  Allow use of -D with -p proto --state to delete entries in a certain
protocol state.

= userspace daemon: conntrackd =

* Fix endianess issue in the network header used in the synchronization
messages: this fix breaks backward protocol compatibility. Thus, you
cannot use conntrackd 0.9.11 with a different daemon version <= 0.9.10.

* Add Nice clause to set the nice value of the daemon: setting a lower
nice value reduces the chance to lose state-change events over netlink.

* Improved polling (or batch-based) synchronization: this feature was
introduced in the previous release, you can configure the daemon to send
batches periodically instead of the soft real-time state
synchronization. This allows you to set up a relaxed replication while
consuming less computational resources. See `PollSecs' clause.

* Add NetlinkOverrunResync clause: this feature allows
disabling/enabling the automatic re-synchronization when the daemon
notices that is losing state-change events.

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


--------------060409050204020900080407
Content-Type: text/plain;
 name="ChangeLog-conntrack-tools-0.9.11"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog-conntrack-tools-0.9.11"

Jan Engelhardt (1):
      build: upgrade build system

Pablo Neira Ayuso (26):
      build: replace INCLUDES by AM_CPPFLAGS according to autoreconf
      configure: conntrack-tools >= 0.9.10 requires libnfnetlink >= 0.0.40
      netlink: refactorize several nl_init_*_handler() functions
      src: re-work polling strategy
      netlink: add new option NetlinkOverrunResync
      sync-mode: flush also internal cache after reset PurgeTimeout
      conntrack: allow use of --state with -D
      src: add Nice clause to set the nice value
      config: nl_overrun must be signed int instead of unsigned
      cache_iterators: fix wrong printf format in commit-time message
      src: use resync handler for polling instead of dump handler
      stats-mode: fix polling based logging
      conntrackd: add `-f internal' and `-f external' options
      conntrackd: display help information with `-h'
      conntrackd: don't initialize logging for client request
      doc: unset ACKWindowSize in example configuration files
      doc: add bulk update to primary-script.sh script
      headers: don't use NFCT_DIR_MAX in statistics structure
      network: fix endianess issue in synchronization network header
      network: fix endianess issue in acknowledgment network header
      sync-mode: change current link if message is correct
      src: remove obsolete debug() and debug_ct() calls
      mcast: fix compilation warning due missing header
      config: add NetlinkBufferSize and NetlinkBufferSizeMaxGrowth
      netlink: use u8 getter for TCP states
      build: bump version to 0.9.11


--------------060409050204020900080407--
