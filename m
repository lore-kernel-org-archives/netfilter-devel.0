From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 0.9.14 released
Date: Mon, 28 Dec 2009 19:56:46 +0100
Message-ID: <4B38FF6E.3050803@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000407040207040206070607"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000407040207040206070607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter project presents another development release of the 
conntrack-tools. This release includes several fixes for the command 
line tool and lots of improvements for the daemon. Specifically I'd like 
to thank Hannes Eder, Vincent Jardin and Samuel Gauthier for their 
suggestions and contributions.

Please, see changelog attached for more details.

I'd also like to thank 6WIND <www.6wind.com> for sponsoring the 
development of two new features that are included in this release: the 
new TCP-based state-synchronization approach and a new feature that 
allows to disable the internal and the external caches. They have also 
helped auditing the code and doing bug hunting.

Q: How stable are the conntrack-tools?
A: The daemon that allows to synchronize states between firewalls has 
been tested in a cluster environment composed of two stateful firewalls 
running Debian 5.0 (Lenny) with a Linux kernel 2.6.32, keepalived 
1.1.15, using conntrackd in FT-FW mode. The test consisted of 
downloading the Linux kernel source code in a tarball file via HTTP and 
randomly (in periods of 10 seconds) unplugging cablelinks to force the 
fail-over between the nodes. The results has shown no hangs/closure in 
any TCP connection.

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

--------------000407040207040206070607
Content-Type: text/plain;
 name="changes-conntrack-tools-0.9.14.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-conntrack-tools-0.9.14.txt"

Hannes Eder (3):
      conntrack: fix output when no arguments are passed
      conntrack: avoid error with expectations when using 'conntrack -E -e ALL ...'
      conntrack: use fscanf() instead of read() for showing counter

Jan Engelhardt (1):
      doc: spell fix in conntrack(8) manpage

Pablo Neira Ayuso (36):
      build: update library version requirements
      local: add LOCAL_RET_* return values for UNIX sockets callbacks
      conntrackd: add iterators with limited steps in hash and cache types
      conntrackd: rework commit not to fork a child process
      conntrackd: improve handling of external messages
      conntrackd: reset event limit iteration counter
      conntrackd: add clause to enable ctnetlink reliable event delivery
      conntrackd: add support for IPv6 kernel-space filtering via BSF
      conntrackd: use conntrack ID in the cache lookup
      conntrackd: fix crash for unubuffered channel on exit path
      conntrackd: more robust sanity checking on synchronization messages
      conntrackd: add `DisableExternalCache' clause
      conntrackd: reduce the number of gettimeofday() syscalls
      conntrackd: allow to remove file descriptors from set
      conntrackd: add support state-replication based on TCP
      conntrackd: net message memory allocation is unsafe
      conntrackd: fix MTU for TCP channels
      conntrackd: fix return value in notrack_local()
      conntrackd: improve error handling in tcp_send
      conntrackd: fix `conf' local variable in channel.c that shadows global
      conntrackd: fix re-connect with multiple TCP channels
      conntrackd: break lines at 80 characters in example config files
      conntrackd: rate-limit the amount of connect() calls
      conntrackd: add retention queue for TCP errors
      conntrackd: add alive control messages to notrack mode
      conntrackd: fix wrong calculation of new maxfd on unregister_fds()
      conntrackd: add statistics when the external cache is disabled
      conntrackd: add missing external statistics
      conntrackd: add `DisableInternalCache' clause
      conntrackd: use indirect call to build layer 4 protocol information
      conntrackd: add ICMP support for state-synchronization
      conntrackd: fix flow-state filtering for TCP
      conntrackd: document internal cache disabling and TCP-based synchronization
      conntrack: fix manually created TCP entries with window tracking enabled
      conntrackd: document `-B' command
      build: bump version to 0.9.14

Samuel Gauthier (2):
      conntrackd: better parse_payload protection against corrupted packets
      conntrackd: fix bad configuration file for DisableExternalCache statement


--------------000407040207040206070607--
