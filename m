From: Patrick McHardy <kaber@trash.net>
Subject: Re: DCCP conntrack/NAT
Date: Tue, 08 Apr 2008 18:21:59 +0200
Message-ID: <47FB9BA7.6080500@trash.net>
References: <47F64C0D.5080700@trash.net> <20080407215017.GB8682@gerrit.erg.abdn.ac.uk> <47FAA40D.7010905@trash.net> <47FB7D3E.4060703@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43763 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYDHQWB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:22:01 -0400
In-Reply-To: <47FB7D3E.4060703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> I've added this patch on top to handle the out-of-sync case by
> letting Requests pass in (almost) any state and resyncing when
> seeing a valid Response.
> 
> Last TODO before the DCCP_LISTEN support is to fix connection
> pickup for established connections. Since it doesn't see the
> initial Request/Response it doesn't know which side has which
> role and also can't properly pick an inital state.

I skipped this for now since it gets a bit ugly and is
not very important for an initial version. I'm uploading
my current tree to kernel.org now, should be there within
the next 20 minutes.

I'll post a patch for DCCP_LISTEN soon (not sure if I will
manage to get it ready today though).

