Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CD01B140E
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 17:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722445772; cv=none; b=JCV4s3uSf3PN2a0GH1Z7PHUjORGrH8HWEAp14eGEo45ZIf1K7XiaDWlSlVWDJpngtJpKZ61ED7FN4j9rz7UEKD6ZVKzoTymwVWgi4lp+1MmO5BbwSJBaeLlc0xceoutKR2rAi+8pn6ci/CCnDtaZ5oLTmiPlIiJBH3qm6/tn/Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722445772; c=relaxed/simple;
	bh=EYpY7099QCElEKHoLrUW1uwKTwtxdidLb9OIFCE/24Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PW+b1sleAc1QVHqdIk8I49FWoAe7SMPZh1lneFI3u/38UnxenPUiKux6VGYI6fnedCV4wyvAE1BcNAzjA7TcnQx1WGt21eUdPzDWQk7JjdKFQ08+VDETjMb80ZHu/Py/6JtPjB/gLORwedjncTvOwQbEX0up0hbdJypxLE1EQSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sZCpM-0006z0-UT; Wed, 31 Jul 2024 19:09:28 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v2 5/5] doc: add documentation about list hooks feature
Date: Wed, 31 Jul 2024 18:51:05 +0200
Message-ID: <20240731165111.32166-6-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240731165111.32166-1-fw@strlen.de>
References: <20240731165111.32166-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a brief segment about 'nft list hooks' and a summary
of the output format.

As nft.txt is quite large, split the additonal commands
into their own file.

The existing listing section is removed; list subcommand is
already mentioned in the relevant statement sections.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Makefile.am                 |   1 +
 doc/additional-commands.txt | 116 ++++++++++++++++++++++++++++++++++++
 doc/nft.txt                 |  63 +-------------------
 3 files changed, 118 insertions(+), 62 deletions(-)
 create mode 100644 doc/additional-commands.txt

diff --git a/Makefile.am b/Makefile.am
index d5ae1f66755a..fb64105dda88 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -321,6 +321,7 @@ A2X_OPTS_MANPAGE = \
 ASCIIDOC_MAIN = doc/nft.txt
 
 ASCIIDOC_INCLUDES = \
+	doc/additional-commands.txt \
 	doc/data-types.txt \
 	doc/payload-expression.txt \
 	doc/primary-expression.txt \
diff --git a/doc/additional-commands.txt b/doc/additional-commands.txt
new file mode 100644
index 000000000000..9ad338f8c7d1
--- /dev/null
+++ b/doc/additional-commands.txt
@@ -0,0 +1,116 @@
+LIST HOOKS
+~~~~~~~~~~
+
+This shows the list of functions that have been registered for the
+given protocol family, including functions that have been
+registered implicitly by kernel modules such as nf_conntrack. +
+
+[verse]
+____
+*list hooks* ['family']
+*list hooks netdev device* 'DEVICE_NAME'
+____
+
+*list hooks* is enough to display everything that is active
+on the system, however, it does currently omit hooks that are
+tied to a specific network device (netdev family). To obtain
+those, the network device needs to be queried by name.
+Example Usage:
+
+.List all active netfilter hooks in either the ip or ip6 stack
+--------------------------------------------------------------
+% nft list hooks inet
+family ip {
+        hook prerouting {
+                -0000000400 ipv4_conntrack_defrag [nf_defrag_ipv4]
+                -0000000200 ipv4_conntrack_in [nf_conntrack]
+                -0000000100 nf_nat_ipv4_pre_routing [nf_nat]
+        }
+        hook input {
+                 0000000000 chain inet filter input [nf_tables]
+                +0000000100 nf_nat_ipv4_local_in [nf_nat]
+[..]
+--------------------------------------------------------------
+
+The above shows a host that has nat, conntrack and ipv4 packet
+defragmentation enabled.
+For each hook location for the queried family a list of active hooks
+using the format +
+
+*priority* *identifier* [*module_name*]
+
+will be shown.
+
+The *priority* value dictates the order in which the hooks are called.
+The list is sorted, the lowest number is run first.
+
+The priority value of hooks registered by the kernel cannot be changed.
+For basechains registered by nftables, this value corresponds to the
+*priority* value specified in the base chain definition.
+
+After the numerical value, information about the hook is shown.
+For basechains defined in nftables this includes the table family,
+the table name and the basechains name.
+For hooks coming from kernel modules, the function name is used
+instead.
+
+If a *module name* is given, the hook was registered by the kernel
+module with this name.  You can use 'modinfo *module name*' to
+obtain more information about the module.
+
+This functionality requires a kernel built with the option +
+CONFIG_NETFILTER_NETLINK_HOOK
+enabled, either as a module or builtin. The module is named
+*nfnetlink_hook*.
+
+MONITOR
+~~~~~~~
+The monitor command allows you to listen to Netlink events produced by the
+nf_tables subsystem. These are either related to creation and deletion of
+objects or to packets for which *meta nftrace* was enabled. When they
+occur, nft will print to stdout the monitored events in either JSON or
+native nft format. +
+
+[verse]
+____
+*monitor* [*new* | *destroy*] 'MONITOR_OBJECT'
+*monitor* *trace*
+
+'MONITOR_OBJECT' := *tables* | *chains* | *sets* | *rules* | *elements* | *ruleset*
+____
+
+To filter events related to a concrete object, use one of the keywords in
+'MONITOR_OBJECT'.
+
+To filter events related to a concrete action, use keyword *new* or *destroy*.
+
+The second form of invocation takes no further options and exclusively prints
+events generated for packets with *nftrace* enabled.
+
+Hit ^C to finish the monitor operation.
+
+.Listen to all events, report in native nft format
+--------------------------------------------------
+% nft monitor
+--------------------------------------------------
+
+.Listen to deleted rules, report in JSON format
+-----------------------------------------------
+% nft -j monitor destroy rules
+-----------------------------------------------
+
+.Listen to both new and destroyed chains, in native nft format
+-----------------------------------------------------------------
+% nft monitor chains
+-------------------------------
+
+.Listen to ruleset events such as table, chain, rule, set, counters and quotas, in native nft format
+----------------------------------------------------------------------------------------------------
+% nft monitor ruleset
+---------------------
+
+.Trace incoming packets from host 10.0.0.1
+------------------------------------------
+% nft add rule filter input ip saddr 10.0.0.1 meta nftrace set 1
+% nft monitor trace
+------------------------------------------
diff --git a/doc/nft.txt b/doc/nft.txt
index 3f4593a29831..7e8c8695522d 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -766,17 +766,6 @@ and subtraction can be used to set relative priority, e.g. filter + 5 equals to
 *destroy*:: Delete the specified flowtable, it does not fail if it does not exist.
 *list*:: List all flowtables.
 
-LISTING
--------
-[verse]
-*list { secmarks | synproxys | flow tables | meters | hooks }* ['family']
-*list { secmarks | synproxys | flow tables | meters | hooks } table* ['family'] 'table'
-*list ct { timeout | expectation | helper | helpers } table* ['family'] 'table'
-
-Inspect configured objects.
-*list hooks* shows the full hook pipeline, including those registered by
-kernel modules, such as nf_conntrack.
-
 STATEFUL OBJECTS
 ----------------
 [verse]
@@ -908,57 +897,7 @@ ADDITIONAL COMMANDS
 -------------------
 These are some additional commands included in nft.
 
-MONITOR
-~~~~~~~~
-The monitor command allows you to listen to Netlink events produced by the
-nf_tables subsystem. These are either related to creation and deletion of
-objects or to packets for which *meta nftrace* was enabled. When they
-occur, nft will print to stdout the monitored events in either JSON or
-native nft format. +
-
-[verse]
-____
-*monitor* [*new* | *destroy*] 'MONITOR_OBJECT'
-*monitor* *trace*
-
-'MONITOR_OBJECT' := *tables* | *chains* | *sets* | *rules* | *elements* | *ruleset*
-____
-
-To filter events related to a concrete object, use one of the keywords in
-'MONITOR_OBJECT'.
-
-To filter events related to a concrete action, use keyword *new* or *destroy*.
-
-The second form of invocation takes no further options and exclusively prints
-events generated for packets with *nftrace* enabled.
-
-Hit ^C to finish the monitor operation.
-
-.Listen to all events, report in native nft format
---------------------------------------------------
-% nft monitor
---------------------------------------------------
-
-.Listen to deleted rules, report in JSON format
------------------------------------------------
-% nft -j monitor destroy rules
------------------------------------------------
-
-.Listen to both new and destroyed chains, in native nft format
------------------------------------------------------------------
-% nft monitor chains
--------------------------------
-
-.Listen to ruleset events such as table, chain, rule, set, counters and quotas, in native nft format
-----------------------------------------------------------------------------------------------------
-% nft monitor ruleset
----------------------
-
-.Trace incoming packets from host 10.0.0.1
-------------------------------------------
-% nft add rule filter input ip saddr 10.0.0.1 meta nftrace set 1
-% nft monitor trace
-------------------------------------------
+include::additional-commands.txt[]
 
 ERROR REPORTING
 ---------------
-- 
2.44.2

