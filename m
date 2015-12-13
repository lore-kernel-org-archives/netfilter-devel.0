From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: release objects on netns
 destruction
Date: Sun, 13 Dec 2015 22:42:20 +0100
Message-ID: <20151213214220.GA1764@salvia>
References: <1449690931-1617-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arturo.borrero.glez@gmail.com, ben@decadent.org.uk
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47898 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbbLMVma (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Dec 2015 16:42:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A9C391324C2
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Dec 2015 22:42:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9D8CCDA794
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Dec 2015 22:42:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 59139DA73F
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Dec 2015 22:42:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449690931-1617-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 09, 2015 at 08:55:31PM +0100, Pablo Neira Ayuso wrote:
> We have to release the existing objects on netns removal otherwise we
> leak them. Chains are unregistered in first place to make sure no
> packets are walking on our rules and sets anymore.

I have detected a problem in this patch.

The netns_exit path from every family is removing the afinfo object
before this iteration here, so this is not working in case family
netns exit callbacks are called before the ones from the core.

I'm going to toss it, will send a new version.
