From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V3] net: Allow xt_owner in any user namespace
Date: Thu, 23 Jun 2016 19:37:31 +0200
Message-ID: <20160623173731.GA3498@salvia>
References: <1465942452-23575-1-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, ebiederm@xmission.com
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56323 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbcFWRhl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:37:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 760CC8D0522
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:37:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 664CA9EBAA
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:37:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ECE459EBAB
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:37:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465942452-23575-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 14, 2016 at 03:14:12PM -0700, Kevin Cernekee wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Making this work is a little tricky as it really isn't kosher to
> change the xt_owner_match_info in a check function.
> 
> Without changing xt_owner_match_info we need to know the user
> namespace the uids and gids are specified in.  In the common case
> net->user_ns == current_user_ns().  Verify net->user_ns ==
> current_user_ns() in owner_check so we can later assume it in
> owner_mt.
> 
> In owner_check also verify that all of the uids and gids specified are
> in net->user_ns and that the expected min/max relationship exists
> between the uids and gids in xt_owner_match_info.
> 
> In owner_mt get the network namespace from the outgoing socket, as this
> must be the same network namespace as the netfilter rules, and use that
> network namespace to find the user namespace the uids and gids in
> xt_match_owner_info are encoded in.  Then convert from their encoded
> from into the kernel internal format for uids and gids and perform the
> owner match.
> 
> Similar to ping_group_range, this code does not try to detect
> noncontiguous UID/GID ranges.

Applied, thanks.
