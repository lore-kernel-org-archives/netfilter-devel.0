From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix missing attribute in DCCP
Date: Wed, 22 Apr 2009 15:44:56 +0200
Message-ID: <49EF1F58.30209@trash.net>
References: <20090422122306.14461.55699.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55661 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbZDVNpB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:45:01 -0400
In-Reply-To: <20090422122306.14461.55699.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi Patrick,
> 
> While finishing the DCCP support (I think it's the last to finish
> the conntrack-tools), I notice that there's one field that is
> not exported to user-space via ctnetlink.
> 
> This patch adds a couple of missing attributes that allows me to
> set the role in DCCP connections, otherwise the ctnetlink support
> is not of much help to be used by conntrackd.
> 
> This can be done with only one attribute, so we can have just one
> CTA_PROTOINFO_DCCP_ROLE_ORIGINAL and set the reply as the opposite.
> However, this may look at bit inconsistent. I don't really mind
> the way this is done, just tell me I'll do it :), but I need this
> to complete DCCP support.

Indeed, this looks like an unnecessary way to do something wrong for
userspace. Since the roles are always the opposite in each direction,
we might as well change the kernel to only keep track of the role
in the original direction and use !role for the reply direction.

> +	ct->proto.dccp.role[IP_CT_DIR_ORIGINAL] =
> +		nla_get_u8(tb[CTA_PROTOINFO_DCCP_ROLE_ORIGINAL]);
> +	ct->proto.dccp.role[IP_CT_DIR_REPLY] =
> +		nla_get_u8(tb[CTA_PROTOINFO_DCCP_ROLE_REPLY]);

Validation please, incorrect values might crash the kernel.
