From: Eric Leblond <eric@regit.org>
Subject: [nftables 0/4] misc improvements and cleaning
Date: Mon, 16 Sep 2013 18:27:34 +0200
Message-ID: <1379348858-29187-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37453 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3IPRHp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:07:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

Here's a small patchset. This is a series of patches on nftables
which appear to be needed when I've play a bit with it.

Patchset statistics:
 files/nftables/bridge-filter |  6 +++---
 files/nftables/ipv4-filter   |  6 +++---
 files/nftables/ipv4-mangle   |  6 +-----
 files/nftables/ipv4-nat      |  6 ++++++
 files/nftables/ipv4-raw      |  6 ------
 files/nftables/ipv4-security |  7 -------
 files/nftables/ipv6-filter   |  6 +++---
 files/nftables/ipv6-mangle   |  6 +-----
 files/nftables/ipv6-nat      |  6 ++++++
 files/nftables/ipv6-raw      |  6 ------
 files/nftables/ipv6-security |  7 -------
 src/netlink_linearize.c      |  4 ++++
 src/rule.c                   | 20 +++++++++++++++++++-
 13 files changed, 46 insertions(+), 46 deletions(-)

BR,
--
Eric
