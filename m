From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlA==?=
 =?utf-8?Q?=E5=A4=8D=3A_=5BPATCH_3=2F3_nf-next=5D_netfilter?= =?utf-8?Q?=3A?=
 nf_ct_helper: Add nf_conntrack_helpers_register()
Date: Sat, 9 Jan 2016 13:17:51 +0100
Message-ID: <20160109121751.GA4655@salvia>
References: <1451908093-3754-3-git-send-email-pablo@netfilter.org>
 <201601041946.QoN8MveC%fengguang.wu@intel.com>
 <BAY403-EAS25258E748DF4B612DF8D4AF95F20@phx.gbl>
 <20160104161550.GB1303@salvia>
 <20160104164656.GA2135@salvia>
 <BAY403-EAS3732A77CAF9E1DCE79ED89395F20@phx.gbl>
 <BAY403-EAS181F9CE879F779A8E160FD195F50@phx.gbl>
 <BAY403-EAS167CF4DCA9B031F6AEFDF7F95F60@phx.gbl>
 <20160108122227.GA3384@salvia>
 <BAY403-EAS1672CCA8B36E7E4F7EC720E95F70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36375 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbcAIMR5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jan 2016 07:17:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BB35512A68C
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jan 2016 13:17:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AD11DDA801
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jan 2016 13:17:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D19F7DA7FF
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jan 2016 13:17:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <BAY403-EAS1672CCA8B36E7E4F7EC720E95F70@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 09, 2016 at 08:09:57AM +0800, Feng Gao wrote:
> Hi Pablo,
> 
> These patches are ok, the memory is continuous. ----------------- I
> misunderstood it. It was deep night, so my status was bad.
> Because the array is helper[MAX_PORT][2], not [2][MAX_PORT].
> 
> I have tested them, and they works well.

Then, please resubmit them. We still have time to integrate them.

> So I only send another patch to enhance the multi-dimension array to
> unidimenssion.

You sent that as a follow up coming after the principal ones.
