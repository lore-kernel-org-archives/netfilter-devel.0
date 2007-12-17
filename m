From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] xt_mark match rev 1
Date: Mon, 17 Dec 2007 13:49:27 +0100
Message-ID: <47667057.20303@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070341010.1262@fbirervta.pbzchgretzou.qr> <475E65AC.9080901@trash.net> <Pine.LNX.4.64.0712151322150.22877@fbirervta.pbzchgretzou.qr> <4763F8FE.5040607@netfilter.org> <Pine.LNX.4.64.0712151708380.22877@fbirervta.pbzchgretzou.qr> <47640412.5050207@netfilter.org> <Pine.LNX.4.64.0712152219110.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56801 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXLQMuN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:50:13 -0500
In-Reply-To: <Pine.LNX.4.64.0712152219110.22877@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 15 2007 17:42, Pablo Neira Ayuso wrote:
>
>> Netlink doesn't stick us to fixed structure layouts as it happens to the
>> current interface since we represent the messages kernel <-> userspace
>> in TLV (type-length-value) format. Thus, userspace and kernel won't
>> share structures and new features just require a new type. For that
>> reason, the netlink interface won't require such revision infrastructure.
>>
> Please explain the TLV thing. How would something like
> struct ipt_tos_target_info (revision 0, in net-2.6.25/xt_DSCP.c) and
> struct xt_tos_target_info (revision 1, in net-2.6.25/xt_DSCP.c) be
> encoded?
> Does the mere presence of a TLV block (sending it over netlink) indicate
> a certain revision?


Since the kernel doesn't share structures with userspace anymore,
you can simply use the most generic form within the kernel and
put the userspace-data in the required form during initialization.
