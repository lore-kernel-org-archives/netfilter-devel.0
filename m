From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/05]: nf_conntrack: fix smp_processor_id() in
 preemptible code warning
Date: Wed, 27 Feb 2008 12:09:15 -0800 (PST)
Message-ID: <20080227.120915.54901797.davem@davemloft.net>
References: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
	<20080227131428.26831.70102.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54415
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbYB0UJQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:09:16 -0500
In-Reply-To: <20080227131428.26831.70102.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 27 Feb 2008 14:14:20 +0100 (MET)

> [NETFILTER]: nf_conntrack: fix smp_processor_id() in preemptible code warning
> 
> Since we're using RCU for the conntrack hash now, we need to avoid
> getting preempted or interrupted by BHs while changing the stats.
> 
> Fixes warning reported by Tilman Schmidt <tilman@imap.cc> when using
> preemptible RCU:
> 
> [   48.180297] BUG: using smp_processor_id() in preemptible [00000000] code: ntpdate/3562
> [   48.180297] caller is __nf_conntrack_find+0x9b/0xeb [nf_conntrack]
> [   48.180297] Pid: 3562, comm: ntpdate Not tainted 2.6.25-rc2-mm1-testing #1
> [   48.180297]  [<c02015b9>] debug_smp_processor_id+0x99/0xb0
> [   48.180297]  [<fac643a7>] __nf_conntrack_find+0x9b/0xeb [nf_conntrack]
> 
> Tested-by: Tilman Schmidt <tilman@imap.cc>
> Tested-by: Christian Casteyde <casteyde.christian@free.fr> [Bugzilla #10097]
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
