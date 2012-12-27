From: kaber@trash.net
Subject: [PATCH 0/3] netfilter: nf_tables: minor fixes
Date: Thu, 27 Dec 2012 07:43:25 +0100
Message-ID: <1356590608-25829-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59078 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2L0Gnf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 01:43:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

the following patches fix two minor netlink issues and add a missing check
for duplicate names on chain renames.

Please apply, thanks!
