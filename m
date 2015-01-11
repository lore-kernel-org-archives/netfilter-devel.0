From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3] nftables: concat preparation
Date: Sun, 11 Jan 2015 08:41:55 +0000
Message-ID: <1420965718-24339-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54992 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbAKImE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:42:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches contain some preparatory changes for concat support.

* add some helper functions for dealing with concat types, cleanup only
* add helper functions for netlink register parsing and dumping

The register parsing and dumping functions will in the next patchset
be used to transparently translate the old 128 bit register numbers
to the new 32 bits register values.

No functional changes are performed by these changes.
