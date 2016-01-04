From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0ggMy8zIG5m?=
 =?utf-8?Q?-next=5D_netfilter?= =?utf-8?Q?=3A?= nf_ct_helper: Add
 nf_conntrack_helpers_register()
Date: Mon, 4 Jan 2016 17:46:56 +0100
Message-ID: <20160104164656.GA2135@salvia>
References: <1451908093-3754-3-git-send-email-pablo@netfilter.org>
 <201601041946.QoN8MveC%fengguang.wu@intel.com>
 <BAY403-EAS25258E748DF4B612DF8D4AF95F20@phx.gbl>
 <20160104161550.GB1303@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fgao@ikuai8.com
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49492 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbcADQrB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 11:47:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 01A2A1324CB
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 17:47:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E72F0DA807
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 17:46:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BC3F0DA795
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 17:46:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160104161550.GB1303@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 04, 2016 at 05:15:50PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 04, 2016 at 10:14:40PM +0800, Feng Gao wrote:
> > Hi Pablo,
> > 
> > I received the warning notification.
> > But I just checked the patch file, and find I already initialized the "err"
> > in the nf_conntrack_helpers_register.
> > 
> > http://www.spinics.net/lists/netfilter-devel/msg39270.html
> 
> Will fix this here, no problem.

BTW, it would be good if you can send us a follow up patch on top of
this series to switch from the bidimensional to unidimensional arrays
to store the helper structures, so we can get rid of the &array[0][0]
thing.
