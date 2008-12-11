From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ctnetlink: fix missing CTA_NAT_SEQ_UNSPEC
Date: Thu, 11 Dec 2008 14:00:47 +0100
Message-ID: <49410EFF.1020603@trash.net>
References: <20081210200649.23169.33618.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56917 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbYLKNAw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2008 08:00:52 -0500
In-Reply-To: <20081210200649.23169.33618.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch fixes an inconsistency in nfnetlink_conntrack.h that
> I introduced myself. The problem is that CTA_NAT_SEQ_UNSPEC is
> missing from enum ctattr_natseq. This inconsistency may lead to
> problems in the message parsing in userspace (if the message
> contains the CTA_NAT_SEQ_* attributes, of course).
> 
> This patch breaks backward compatibility, however, the only known
> client of this code is libnetfilter_conntrack which indeed crashes
> because it assumes the existence of CTA_NAT_SEQ_UNSPEC to do
> the parsing.
> 
> The CTA_NAT_SEQ_* attributes were introduced in 2.6.25.

Applied, thanks.
