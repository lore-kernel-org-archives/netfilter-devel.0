From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 0.9.8 released
Date: Tue, 21 Oct 2008 21:25:25 +0200
Message-ID: <48FE2CA5.3050004@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030402050608010005050203"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030402050608010005050203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents another development release of
the conntrack-tools. This release includes important updates, fixes and
improvements. Moreover, a new user manual has been released,
contributions to improve are welcome! Detailed changelog is attached.

What are the conntrack-tools?

- The userspace daemon so-called conntrackd that covers the specific
aspects of stateful Linux firewalls to enable high availability
solutions. It can be used as statistics collector of the firewall use as
well. The daemon is highly configurable and easily extensible.

- The command line interface (CLI) conntrack that provides an interface
to add, delete and update flow entries, list current active flows in
plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush the
complete connection tracking table among many other.

Where can I download it from?

http://www.netfilter.org/projects/conntrack-tools/downloads.html

Where can I get more information about them?

http://people.netfilter.org/pablo/conntrack-tools/

Where can I have a look at the new user manual?

http://people.netfilter.org/pablo/conntrack-tools/install.html

On behalf of the Netfilter Project,
Pablo

Enjoy!

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers



--------------030402050608010005050203
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

Albin Tonerre (1):
      fix unsecure usage of printf and include limits.h (PATH_MAX and INT_MAX)
 
Pablo Neira Ayuso (63):
      check if entries already exist in kernel before injection
      do not include Changelog in tarballs, use git shortlog instead
      use only the original tuple to check if a conntrack is present
      fix xml output: wrap output with one root element
      Major rework of the user-space event filtering
      add support for kernel-space filtering via BSF
      log: syslog displays the entry that triggers the error
      filter: skip protocol state filtering if state not present
      conntrack: add new option --buffer-size for -E
      add more sanity checks in the input path
      commit: retry at least once if we hit ETIME or ENOMEM
      fix: use %zu instead of %u for size_t
      cleanup: remove obsolete clause Replicate in the example conffiles
      fix: wrong information related to default logging action
      fix: wrong use of timersub in cache_timer
      fix broken normal deletion in caches
      ftfw: show consistent information to users for problem diagnosing
      doc: remove duplicated example files
      script: rework scripts that enable interaction with keepalived
      conntrackd: add -t option to shorten conntrack timeouts
      fix missing updates in the example files
      script: fix broken if branches
      cache_iterators: do not report ENOENT in cache_reset_timers
      script: yet another minor fix
      netlink: add getter and check existence functions
      cache iterators: rework cache_reset_timers
      cache iterators: commit master entries before related ones
      netlink: avoid errors related to the expected bit handling
      conntrack: remove duplicated optarg checking
      conntrack: remove unrequired \n in error message
      conntrack: check for missing arguments in getopt_long
      conntrack: insert `conntrack-tools' string in help and error messages
      compilation: relax too strict warning checking
      ftfw: check for malformed ack and nack messages
      filter: fix NAT detection tweak
      cleanup: Linux kernel version checking
      filter: check if kernel-space filtering is available
      cleanup: remove some debug messages from sync-ftfw.c
      config: use /var/run to create the UNIX socket file
      fix: remove node from tx_list when the state-entry is destroy
      ftfw: fix race that triggers a double insertion into tx_list
      ftfw: fix race condition in the helloing routine
      ftfw: reset window and flush the resend queue during helloing
      conntrack: cleanup for the update path
      conntrack: cleanup XML header handling
      conntrack: fix mark-based filtering for event display
      conntrack: fix filtering for unsupported protocol
      conntrack: fix dump counter displayed with -L expect
      manual: add initial user manual
      doc: update INSTALL file
      conntrack: cleanup for NAT filtering
      cache: fix update of scheduled-to-timeout entries
      cache-iterators: improve committing
      config: fix usage of 'PurgeTimeout' in Sync NOTRACK
      notrack: fix double receival of resync requests
      doc: rise default size of the hashtable in the example file
      netlink: report when kernel-space event filtering is in use
      filter: fix segfault if the Filter clause is unused
      cache: use jhash2 instead of double jhash+jhash_2words
      filter: do not filter in user-space if kernel supports BSF
      doc: remove example about CacheWriteTrough
      doc: update conntrackd manpage
      conntrackd: add missing information on -t to the help
      conntrackd: bump version to 0.9.8


--------------030402050608010005050203--
