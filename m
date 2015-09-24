From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0ggUmVzb2x2?=
 =?utf-8?Q?ed_UMA_issue=5D_netfilter=3A_icmp=3A_Enhanc?= =?utf-8?Q?e?= the
 return value check of nf_nat_icmp(v6)_reply_translation
Date: Thu, 24 Sep 2015 12:13:37 +0200
Message-ID: <20150924101337.GB4709@salvia>
References: <BAY403-EAS1715250DCF2909E7CF2126B95470@phx.gbl>
 <BAY403-EAS177047F29CEA067EAD9964C95430@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36211 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbbIXKGz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2015 06:06:55 -0400
Content-Disposition: inline
In-Reply-To: <BAY403-EAS177047F29CEA067EAD9964C95430@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 24, 2015 at 12:24:41PM +0800, Feng Gao wrote:
> Hi Pablo,
> 
> How about this patch?
> If it is ok, I have more confidence to try to commit more patches.

The patch format looks good, patchwork is catching it.

I'll go back to the pending list of patches as soon as the netns bunch
gets merged mainstream.
