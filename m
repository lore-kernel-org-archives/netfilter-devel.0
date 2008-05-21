From: Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH 3/4] add support for modifying secmark via ctnetlink
Date: Wed, 21 May 2008 12:46:07 -0400
Message-ID: <200805211246.07481.paul.moore@hp.com>
References: <483350D3.50103@netfilter.org> <Xine.LNX.4.64.0805212129150.19104@us.intercode.com.au> <48340EC9.3020507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: James Morris <jmorris@namei.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11114 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbYEUQqM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 12:46:12 -0400
In-Reply-To: <48340EC9.3020507@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 21 May 2008 8:00:09 am Patrick McHardy wrote:
> James Morris wrote:
> > On Wed, 21 May 2008, Patrick McHardy wrote:
> >> Pablo Neira Ayuso wrote:
> >>> As for now we only support dumping. This patch adds support to
> >>> change the secmark from ctnetlink.
> >>
> >> I'm wondering whether this isn't subverting the intent of
> >> secmark since AFAIK SELinux doesn't have finegrained
> >> controls for netlink messages. OTOH, it also doesn't have
> >> finegrained control over iptables rulesets.
> >>
> >> James, does this patch look OK to you?
> >
> > There is some fine-grained netlink coverage, but it is incomplete
> > (the various generic netlink layers likely need to be consolidated
> > first).
> >
> > Currently, the SECMARK and CONNSECMARK targets call out to
> > selinux_secmark_relabel_packet_permission() when SELinux is active
> > to obtain a permission check.  So, detection of the current
> > security model would need to be similarly performed.
>
> Thanks for the explanation.

Sorry, I don't subscribe to netfilter-devel so I missed the original 
discussion; I'm subscribed now.

I agree with James that we need to perform some access check before 
setting the ct->secmark field, however, I don't think it is as simple 
as calling selinux_secmark_relabel_packet_permission().  The problem is 
that the selinux_secmark_relabel_packet_permission() function checks to 
see if the currently running task can relabel packets; in this case we 
don't want to check the currently running task we want to check the 
sender of the netlink message which we can't really do currently.  The 
next best thing is to provide access control around the individual 
netlink message types which we can currently do.

>From what I can tell (I'm no netfilter expert), we need to ensure that 
only privileged process have the ability to send netlink messages with 
type (NFNL_SUBSYS_CTNETLINK | IPCTNL_MSG_CT_NEW) which should be 
possible using the code in security/selinux/nlmsgtab.c.  You would need 
to create a NETLINK_NETFILTER nlmsg_perm struct first like the others 
for routing, XFRM, audit, etc.

> > The bigger issue perhaps is whether there's really a need to set
> > secmark via ctnetlink.
>
> I think Pablo wants to use it for synchronization with conntrackd,
> but I'm not sure.

To be honest I'm a little uneasy about this because we don't have a way 
to perform any "good" access check (there is no subject in this case 
since we can't check the security label of the process sending the 
netlink message).  Has anyone checked to see if setting the secmark via 
conntrackd works?  I really doubt it would since the actual secmakr 
integer value is specific, in the SELinux case, to a particular running 
kernel and not globally recognized by other systems even if they are 
running the same kernel and SELinux policy.  There are ways to 
workaround this by passing the string based label between systems but 
even that can have issues if the security policies differ slightly.

-- 
paul moore
linux @ hp
