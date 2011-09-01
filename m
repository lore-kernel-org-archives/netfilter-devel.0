From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] iptables 1.4.12.1 released
Date: Thu, 1 Sep 2011 18:58:53 +0200
Message-ID: <20110901165853.GA17063@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Content-Transfer-Encoding: 8bit
To: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter Users Mailing List <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51437 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab1IAQ7C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:59:02 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The netfilter coreteam presents:

    iptables version 1.4.12.1

This release is a pure bugfix release for regressions reported
against 1.4.12 and manpage updates.

Version 1.4.12.1 can be obtained from:

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/
git://git.netfilter.org/iptables.git

On behalf of the Netfilter Core Team.
Happy firewalling!


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="changes-iptables-1.4.12.1.txt"
Content-Transfer-Encoding: 8bit

Bernard Massot (1):
      doc: fix typo in libxt_TRACE

Dwight Davis (1):
      libxt_string: fix space around arguments

Fernando Luis Vázquez Cao (1):
      libxt_TOS: update linux kernel version list for backported fix

Jan Engelhardt (36):
      extensions: use multi-target registration
      libxt_TCPMSS: restore build with IPv6-less libcs
      libxt_string: define _GNU_SOURCE for strnlen
      build: workaround broken linux-headers on RHEL-5
      build: strengthen check for overlong lladdr components
      build: abort autogen on subcommand failure
      libipq: add pkgconfig file
      libxt_u32: fix missing allowance for inversion
      libxt_set: update man page about kernel support on the feature
      libxt_tcp: always print the mask parts
      libxt_set: put differing variable names in directly
      doc: clarify libxt_connlimit defaults
      libxt_conntrack: remove one misleading comment
      libxt_dccp: restore missing XTOPT_INVERT tags for options
      libxt_dccp: fix deprecated intrapositional ordering of !
      libxt_dccp: spell out option name on save
      libxt_dccp: provide man pages options in short help too
      libxt_dccp: fix random output of ! on --dccp-option
      libxt_dscp: restore inversion support
      libxt_hashlimit: default htable-expire must be in milliseconds
      libxt_conntrack: fix --ctproto 0 output
      xtoptions: flag use of XTOPT_POINTER without XTOPT_PUT
      libip6t_frag: restore inversion support
      libxt_hashlimit: remove inversion from hashlimit rev 0
      libip6t_hbh: restore setting IP6T_OPTS_LEN flag
      libip6t_dst: restore setting IP6T_OPTS_LEN flag
      libipt_ttl: document that negation is available
      libxt_owner: restore inversion support
      libxt_physdev: restore inversion support
      libxt_policy: remove superfluous inversion
      tests: add negation tests for libxt_statistic
      libxt_hashlimit: observe new default gc-expire time when saving
      libxt_string: simplify hex output routine
      libxt_string: replace hex codes by char equivalents
      src: remove unused IPTABLES_MULTI define
      libxt_string: escape the escaping char too

Pablo Neira Ayuso (1):
      Bump version to 1.4.12.1

Patrick McHardy (1):
      Merge branch 'master' of git://dev.medozas.de/iptables


--h31gzZEtNLTqOjlF--
