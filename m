From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: clean up main command loop
Date: Wed,  9 Feb 2011 02:48:45 +0100
Message-ID: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38705 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab1BIBtC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a respin of the earlier patch. Now the cases for -j and -m
are also in their own functions, and the shared code has
moved to xshared.c.


The following changes since commit e76ec99b48745b0e3c8aecbc91ed5bba186cf25f:

  libxt_cluster: fix inversion in the cluster match (2011-02-06 21:34:33 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (11):
      src: collect do_command variables in a struct
      src: move large default: block from do_command6 into its own function
      src: share iptables_command_state across the two programs
      src: deduplicate find_proto function
      src: move OPT_FRAGMENT to the end so the list can be shared
      src: put shared option flags into xshared
      src: deduplicate and simplify implicit protocol extension loading
      src: unclutter command_default function
      src: move jump option handling from do_command6 into its own function
      src: move match option handling from do_command6 into its own functions
      iptables: fix error message for unknown options

 ip6tables.c |  565 ++++++++++++++++++++++++-------------------------------
 iptables.c  |  607 +++++++++++++++++++++++++----------------------------------
 xshared.c   |   70 +++++++
 xshared.h   |   37 ++++
 4 files changed, 608 insertions(+), 671 deletions(-)
