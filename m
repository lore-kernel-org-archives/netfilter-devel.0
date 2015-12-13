From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: rebasing nf tree
Date: Sun, 13 Dec 2015 22:51:25 +0100
Message-ID: <20151213215125.GA2029@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48576 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbbLMVvf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Dec 2015 16:51:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5A8661324C2
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Dec 2015 22:51:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4D85ADA72A
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Dec 2015 22:51:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8EE28DA72A
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Dec 2015 22:51:32 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have to toss this patch from the nf tree:

        netfilter: nf_tables: release objects on netns destruction

I detected problems in it and I don't want to pass up this fix in
several incremental updates.

So I had to rebase, in case you got that patch into your working copy,
please just remove it from your head via:

git reset HEAD^
git reset --hard

then pull back from master. Sorry for the inconvenience.
