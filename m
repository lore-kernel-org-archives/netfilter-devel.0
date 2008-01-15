From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_RAWNAT target idea
Date: Tue, 15 Jan 2008 07:34:45 +0100
Message-ID: <478C5405.6040104@trash.net>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr> <478AFB75.7040701@trash.net> <Pine.LNX.4.64.0801140944000.10906@fbirervta.pbzchgretzou.qr> <478B310A.3040300@trash.net> <Pine.LNX.4.64.0801141618030.10906@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62526 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYAOGew (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:34:52 -0500
In-Reply-To: <Pine.LNX.4.64.0801141618030.10906@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 14 2008 10:53, Patrick McHardy wrote:
> 
>> But adding a new chain to the raw table is a high price, every new
>> netfilter hooks costs quite a bit of performance. Why not simply do
>> this in the mangle table? That will also make rerouting in OUTPUT
>> work as a side effect.
> 
> I think the issue that I tried to outrun was that if I mangle the
> address in NF_IP_PRI_MANGLE, then IP_NF_PRI_CONNTRACK_HELPER and
> IP_NF_PRI_CONNTRACK_CONFIRM gets confused because I change the
> address after NF_IP_PRI_CONNTRACK.
> 
> IOW: conntrack sees the packet, I mangle it in mangle,
> and then the other conntrack hooks get confused.
> That is why I thought I need some hook after
> NF_IP_PRI_CONNTRACK_CONFIRM.


They probably put the wrong address in the hash tables. The main
use for this seems to be avoiding the use of conntrack anyways,
but to make them play nicely together I guess you'd have to
mangle the conntrack tuple in case conntrack is used.
