From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] add support for modifying secmark via ctnetlink
Date: Wed, 21 May 2008 19:13:17 +0200
Message-ID: <4834582D.8090009@trash.net>
References: <483350D3.50103@netfilter.org>	 <Xine.LNX.4.64.0805212129150.19104@us.intercode.com.au>	 <48340EC9.3020507@trash.net>  <200805211246.07481.paul.moore@hp.com> <1211388856.7486.366.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Paul Moore <paul.moore@hp.com>, James Morris <jmorris@namei.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46610 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbYEURNR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 13:13:17 -0400
In-Reply-To: <1211388856.7486.366.camel@moss-spartans.epoch.ncsc.mil>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Smalley wrote:
> On Wed, 2008-05-21 at 12:46 -0400, Paul Moore wrote:
>>
>> I agree with James that we need to perform some access check before 
>> setting the ct->secmark field, however, I don't think it is as simple 
>> as calling selinux_secmark_relabel_packet_permission().  The problem is 
>> that the selinux_secmark_relabel_packet_permission() function checks to 
>> see if the currently running task can relabel packets; in this case we 
>> don't want to check the currently running task we want to check the 
>> sender of the netlink message which we can't really do currently.
> 
> Sending task SID is saved in NETLINK_CB(skb).sid at send time, so the
> information is available (but would need to be passed into the
> function).

This part can actually be removed from af_netlink, see the message
I just sent to Paul for reference.
