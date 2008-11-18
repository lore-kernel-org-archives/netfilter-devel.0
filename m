From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: ctnetlink: deliver events for conntracks
 changed from userspace
Date: Tue, 18 Nov 2008 11:57:13 +0100
Message-ID: <49229F89.300@trash.net>
References: <20081118030948.28549.30226.stgit@Decadence> <20081118031010.28549.67042.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33744 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYKRK5T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:57:19 -0500
In-Reply-To: <20081118031010.28549.67042.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> As for now, the creation and update of conntracks via ctnetlink do not
> propagate an event to userspace. This can result in inconsistent situations
> if several userspace processes modify the connection tracking table by means
> of ctnetlink at the same time. Specifically, using the conntrack command
> line tool and conntrackd at the same time can trigger unconsistencies.
> 
> This patch also modifies the event cache infrastructure to pass the
> process PID and the ECHO flag to nfnetlink_send() to report back
> to userspace if the process that triggered the change needs so.
> Based on a suggestion from Patrick McHardy.

Applied, thanks.
