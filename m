From: Florian Westphal <fw@strlen.de>
Subject: [Patch v3] netfilter: ebtables: CONFIG_COMPAT support
Date: Mon, 15 Feb 2010 22:05:32 +0100
Message-ID: <1266267939-7736-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33309 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756474Ab0BOVGp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:06:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is v3 of ebtables CONFIG_COMPAT patch set.
Only changes since v2 are those pointed out by Bart:
- remove MEMPRINT macro
- remove BUGPRINT line instead of adding compat argument to
  copy_counters_to_user().

Also, I rebased things on top of nf-next master.

The following changes since commit 3e5e524ffb5fcf2447eb5dd9f8e54ad22dd9baa7:
  Florian Westphal (1):
        netfilter: CONFIG_COMPAT: allow delta to exceed 32767

are available in the git repository at:

  git://git.breakpoint.cc/fw/nf-next-2.6.git ebt_config_compat_v3

Florian Westphal (7):
      netfilter: ebtables: split do_replace into two functions
      netfilter: ebtables: split copy_everything_to_user into two functions
      netfilter: ebtables: split update_counters into two functions
      netfilter: ebtables: add CONFIG_COMPAT support
      netfilter: ebtables: try native set/getsockopt handlers, too
      netfilter: ebt_limit: add CONFIG_COMPAT support
      netfilter: ebtables: mark: add CONFIG_COMPAT support

 net/bridge/netfilter/ebt_limit.c  |   16 +
 net/bridge/netfilter/ebt_mark.c   |   31 +
 net/bridge/netfilter/ebt_mark_m.c |   37 ++
 net/bridge/netfilter/ebtables.c   | 1118 +++++++++++++++++++++++++++++++++----
 4 files changed, 1083 insertions(+), 119 deletions(-)
