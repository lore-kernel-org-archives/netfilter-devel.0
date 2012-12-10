From: kaber@trash.net
Subject: [PATCH 0/5] netfilter: nf_tables: nf_tables update
Date: Mon, 10 Dec 2012 18:20:07 +0100
Message-ID: <1355160012-13952-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36286 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2LJRbl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:31:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches for nf_tables fix a few bugs and introduct
loop detection:

- anonymous sets are currently broken since we're not reporting the
  chosen set name to userspace anymore

- save 48 bits per rule by reducing the handle size and plugging a whole

- destroy anonymous sets immediately when binding fails since there
  will be no unbinding operation

- add loop detection for new jump verdicts

Please apply, thanks!
