From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH 00/12] nftables: generic protocol contexts, "inet" family support
Date: Mon,  6 Jan 2014 17:27:15 +0000
Message-ID: <1389029247-27697-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55573 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbaAFR1f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:27:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches implement the necessary support for the mixed IPv4/IPv6
"inet" table. The patchset consists of two major parts:

- introduction of generic protocol contexts
- support for the inet family and nfproto/l4proto meta expression types

The generic protocol contexts are a generalization of the payload contexts.
Since not only the payload expression, but also the ct and meta expression
can imply higher or lower layer protocols, the context tracking is
generalized. A small patch for the ct expression for context dependant
parsing of ct-src, ct-dst, ct-proto-src and ct-proto-dst is also included.

Support for the inet family mainly consist of adding a mapping for the
parser and netlink support for "inet" <-> NFPROTO_INET and adding support
for the meta nfproto and l4proto types.

With this in place, we can create rules like:

inet filter output tcp dport ssh counter

to match on ssh traffic for both IPv4 and IPv6.

inet filter output nfproto ipv4 tcp dport ssh

to match on ssh traffic for only IPv4.

Sets etc. have been verified to work as expected.

The only open question (related to the kernel though, but I forgot to
state it in my posting) is handling of autoloading of AF-specific
modules like nf_conntrack_ipv4 and nf_conntrack_ipv6. With NFPROTO_INET
the autoloading fails, so the ct expression can currently not be used.
We basically have two options:

- load both
- load none

Both approaches seem reasonable, but for consistency I'd tend to add
some special handling to load both modules for NFPROTO_INET.

The kernel patches are unchanged, just some minor cleanups in the
changelogs. If there are no objections I'll post a final version of
this patchset and will push it to the nftables repository and will
also post the final version of the kernel patches.

Cheers,
Patrick
