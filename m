From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] add support for modifying secmark via ctnetlink
Date: Wed, 21 May 2008 19:11:59 +0200
Message-ID: <483457DF.3070702@trash.net>
References: <483350D3.50103@netfilter.org> <Xine.LNX.4.64.0805212129150.19104@us.intercode.com.au> <48340EC9.3020507@trash.net> <200805211246.07481.paul.moore@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: James Morris <jmorris@namei.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: Paul Moore <paul.moore@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46585 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbYEURMA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 13:12:00 -0400
In-Reply-To: <200805211246.07481.paul.moore@hp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Paul Moore wrote:
> Sorry, I don't subscribe to netfilter-devel so I missed the original 
> discussion; I'm subscribed now.
> 
> I agree with James that we need to perform some access check before 
> setting the ct->secmark field, however, I don't think it is as simple 
> as calling selinux_secmark_relabel_packet_permission().  The problem is 
> that the selinux_secmark_relabel_packet_permission() function checks to 
> see if the currently running task can relabel packets; in this case we 
> don't want to check the currently running task we want to check the 
> sender of the netlink message which we can't really do currently.  The 
> next best thing is to provide access control around the individual 
> netlink message types which we can currently do.


Actually in the current kernel netlink message processing is
done synchronously in the context of the sending process
(commit cd40b7d3: [NET]: make netlink user -> kernel interface
synchronious). So this check should be easy to add.

> From what I can tell (I'm no netfilter expert), we need to ensure that 
> only privileged process have the ability to send netlink messages with 
> type (NFNL_SUBSYS_CTNETLINK | IPCTNL_MSG_CT_NEW) which should be 
> possible using the code in security/selinux/nlmsgtab.c.  You would need 
> to create a NETLINK_NETFILTER nlmsg_perm struct first like the others 
> for routing, XFRM, audit, etc.

So far nfnetlink is restricted to CAP_NET_ADMIN and uses
security_netlink_recv() for permission checks. I'll add
a nlmsg_perm struct for nfnetlink, I guess this makes
sense independant of this patch. Will send over for review
once its ready.

>>> The bigger issue perhaps is whether there's really a need to set
>>> secmark via ctnetlink.
>> I think Pablo wants to use it for synchronization with conntrackd,
>> but I'm not sure.
> 
> To be honest I'm a little uneasy about this because we don't have a way 
> to perform any "good" access check (there is no subject in this case 
> since we can't check the security label of the process sending the 
> netlink message).  Has anyone checked to see if setting the secmark via 
> conntrackd works?  I really doubt it would since the actual secmakr 
> integer value is specific, in the SELinux case, to a particular running 
> kernel and not globally recognized by other systems even if they are 
> running the same kernel and SELinux policy.  There are ways to 
> workaround this by passing the string based label between systems but 
> even that can have issues if the security policies differ slightly.

In that case it doesn't seem to make sense for synchronization.
That was just a guess of mine though, Pablo?
