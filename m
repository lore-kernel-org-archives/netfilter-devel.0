From: Patrick McHardy <kaber@trash.net>
Subject: Re:  SCTP NAT
Date: Wed, 23 Jan 2008 18:42:00 +0100
Message-ID: <47977C68.4080705@trash.net>
References: <1C6541574A2FC447B53A6B4522B678AFF057BE@moe.nextone.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Sohan Shetty <sshetty@nextpointnetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51348 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbYAWRmp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:42:45 -0500
In-Reply-To: <1C6541574A2FC447B53A6B4522B678AFF057BE@moe.nextone.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sohan Shetty wrote:
> Is  anyone aware if there an  NAT module for netfilter being developed
> for SCTP protocol ?
> 
> 
> I have searched the netfilter development tree source code and also
> mailing list and so far I have not found the NAT module for SCTP . There
> is SCTP conntrack module and packet match module. 
> 
> If anyone is aware and can point me to  some one who is already working
> on this or has evaluated this it would be of great help.


I looked into this a few weeks ago, but multihoming is problematic
since the ports need to stay stable, so the vtag needs to be used
as key. Conntrack doesn't support this currently.

A further problem are checksum updates. There are multiple
different checksumming algorithms in use, with no way of
finding out which one is used currently, all require full
recalculation.
