From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 3/4] add support for modifying secmark via ctnetlink
Date: Thu, 22 May 2008 14:11:59 -0400
Message-ID: <1211479919.7486.507.camel@moss-spartans.epoch.ncsc.mil>
References: <483350D3.50103@netfilter.org>
	 <Xine.LNX.4.64.0805212129150.19104@us.intercode.com.au>
	 <48340EC9.3020507@trash.net>  <200805211246.07481.paul.moore@hp.com>
	 <1211388856.7486.366.camel@moss-spartans.epoch.ncsc.mil>
	 <4834582D.8090009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Paul Moore <paul.moore@hp.com>, James Morris <jmorris@namei.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zombie.ncsc.mil ([144.51.88.131]:45378 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYEVSM2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 14:12:28 -0400
In-Reply-To: <4834582D.8090009@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wed, 2008-05-21 at 19:13 +0200, Patrick McHardy wrote:
> Stephen Smalley wrote:
> > On Wed, 2008-05-21 at 12:46 -0400, Paul Moore wrote:
> >>
> >> I agree with James that we need to perform some access check before 
> >> setting the ct->secmark field, however, I don't think it is as simple 
> >> as calling selinux_secmark_relabel_packet_permission().  The problem is 
> >> that the selinux_secmark_relabel_packet_permission() function checks to 
> >> see if the currently running task can relabel packets; in this case we 
> >> don't want to check the currently running task we want to check the 
> >> sender of the netlink message which we can't really do currently.
> > 
> > Sending task SID is saved in NETLINK_CB(skb).sid at send time, so the
> > information is available (but would need to be passed into the
> > function).
> 
> This part can actually be removed from af_netlink, see the message
> I just sent to Paul for reference.

So eff_cap, loginuid, sessionid, and sid no longer need to be saved in
netlink_skb_parms?  Current users include security modules and audit.

-- 
Stephen Smalley
National Security Agency

