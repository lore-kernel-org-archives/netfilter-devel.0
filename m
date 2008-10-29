From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] conntrack-tools 0.9.8 released
Date: Wed, 29 Oct 2008 16:03:34 +0100
Message-ID: <49087B46.5010002@netfilter.org>
References: <48FE2CA5.3050004@netfilter.org> <49086A7E.4000500@astrocorp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090509030506030403000802"
Cc: netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@astrocorp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37881 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753934AbYJ2PDs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:03:48 -0400
In-Reply-To: <49086A7E.4000500@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090509030506030403000802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Bryan Duff wrote:
> Is there a changelog posted somewhere?

Hm, did I forget to include it in the email. Attached again. The
ChangeLog is extracted from git shortlog, you may want to get more
detailed information from git.netfilter.org.

> Also you may want to update your "more information" link below.

http://conntrack-tools.netfilter.org/manual.html

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------090509030506030403000802
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

Albin Tonerre (1):
      fix unsecure usage of printf and include limits.h (PATH_MAX and INT_MAX)

Eric Leblond (1):
      commit: retry at least once if we hit ETIME or ENOMEM

Pablo Neira Ayuso (63):
      check if entries already exist in kernel before injection
      do not include Changelog in tarballs, user git shortlog for changelog instead
      use only the original tuple to check if a conntrack is present
      fix xml output: wrap output with one root element
      Major rework of the user-space event filtering
      add support for kernel-space filtering via BSF
      log: syslog displays the entry that triggers the error
      filter: skip protocol state filtering if state not present
      CLI: add new option --buffer-size for -E
      add more sanity checks in the input path
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
      cli: remove duplicated optarg checking
      cli: remove unrequired \n in error message
      cli: check for missing arguments in getopt_long
      cli: insert `conntrack-tools' string in help and error messages
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


--------------090509030506030403000802--
