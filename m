From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 0.9.13 released
Date: Fri, 17 Jul 2009 13:00:24 +0200
Message-ID: <4A6059C8.7070900@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040300060308090406030302"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040300060308090406030302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project presents another development release of the
conntrack-tools that includes support for all the protocol helpers
available in 2.6.30 that were missing so far (SCTP, UDPlite, DCCP and
GRE). The daemon updates includes a fix for a memory leak that can be
triggered under heavy load and if you set a hashtable in user-space that
is smaller than the one in the kernel. Moreover, it adds initial support
for DCCP and SCTP state-synchronization.

Please, see changelog attached for more details.

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

On behalf of the Netfilter Core Team,
Pablo.

--------------040300060308090406030302
Content-Type: text/plain;
 name="changes-conntrack-tools-0.9.13.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-conntrack-tools-0.9.13.txt"

Pablo Neira Ayuso (38):
      daemon: remove unused constants in header file
      conntrack: remove hardcoded iteration in TCP support
      conntrack: cleanup error output with `-p tcp --state'
      conntrack: save one indent in the TCP support
      conntrack: fix coupled-options sanity checkings
      conntrack: add UDPlite support
      conntrack: add SCTP support
      conntrack: add DCCP support
      conntrackd: change scheduler and priority via configuration file
      conntrack: fix English typo in output message
      conntrack: add GRE support
      sync: add support for SCTP state replication
      conntrack: add DCCP role parameter for conntrack creation
      sync: add support for DCCP state replication
      conntrackd: add child process infrastructure
      conntrackd: detect where the events comes from
      conntrackd: flush operation use the child process and origin infrastructure
      conntrackd: remove the cache write-through policy
      conntrackd: remove redudant declaration of Port in the parser
      conntrackd: remove an unused extern declaration in cache.h
      src: remove obsolete changelog file
      conntrackd: remove unused request nfct handler
      conntrackd: add missing initialization of PID in process infrastructure
      conntrackd: block signals during the access to the process list
      conntrackd: allow to limit the number of simultaneous child processes
      conntrackd: use a permanent handler for flush operations
      conntrackd: use a permanent handler for commit operations
      conntrackd: add support to display statistics on existing child processes
      build: use TLV format for SCTP/DCCP protocol information
      conntrackd: rename `-s queue' option by `-s rsqueue'
      conntrackd: add the name field to queues
      conntrackd: add `-s queue' to display queue statistics
      conntrackd: add statistics about queue node objects
      conntrackd: add statistics for enospc errors in queues
      conntrackd: fix memory leak in cache_update_force()
      conntrackd: fix wrong TCP handling in unused nl_update_conntrack()
      build: bump version to 0.9.13

Jan Engelhardt (1):
      conntrack: fix English typo in documentation

Samuel Gauthier (1):
      build: use uint16_t instead of uint32_t for uint16_t attributes

Thomas Jarosch (1):
      build: Added "m4" directory to make dist


--------------040300060308090406030302--
