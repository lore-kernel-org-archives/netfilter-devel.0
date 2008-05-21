From: Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH 3/4] add support for modifying secmark via ctnetlink
Date: Wed, 21 May 2008 13:51:08 -0400
Message-ID: <200805211351.08499.paul.moore@hp.com>
References: <483350D3.50103@netfilter.org> <200805211246.07481.paul.moore@hp.com> <483457DF.3070702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: James Morris <jmorris@namei.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:47032 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763462AbYEURvS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 13:51:18 -0400
In-Reply-To: <483457DF.3070702@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 21 May 2008 1:11:59 pm Patrick McHardy wrote:
> Paul Moore wrote:
> > Sorry, I don't subscribe to netfilter-devel so I missed the
> > original discussion; I'm subscribed now.
> >
> > I agree with James that we need to perform some access check before
> > setting the ct->secmark field, however, I don't think it is as
> > simple as calling selinux_secmark_relabel_packet_permission().  The
> > problem is that the selinux_secmark_relabel_packet_permission()
> > function checks to see if the currently running task can relabel
> > packets; in this case we don't want to check the currently running
> > task we want to check the sender of the netlink message which we
> > can't really do currently.  The next best thing is to provide
> > access control around the individual netlink message types which we
> > can currently do.
>
> Actually in the current kernel netlink message processing is
> done synchronously in the context of the sending process
> (commit cd40b7d3: [NET]: make netlink user -> kernel interface
> synchronious). So this check should be easy to add.

Thanks, that is definitely handy.

> > From what I can tell (I'm no netfilter expert), we need to ensure
> > that only privileged process have the ability to send netlink
> > messages with type (NFNL_SUBSYS_CTNETLINK | IPCTNL_MSG_CT_NEW)
> > which should be possible using the code in
> > security/selinux/nlmsgtab.c.  You would need to create a
> > NETLINK_NETFILTER nlmsg_perm struct first like the others for
> > routing, XFRM, audit, etc.
>
> So far nfnetlink is restricted to CAP_NET_ADMIN and uses
> security_netlink_recv() for permission checks. I'll add
> a nlmsg_perm struct for nfnetlink, I guess this makes
> sense independant of this patch. Will send over for review
> once its ready.

Thanks.  When developing the patch keep in mind that the new permissions 
will probably need to made conditional on the SELinux policy 
capabilitity to preserve backwards compability.  Look for the 
selinux_policycap_{netpeer,openperm} under security/selinux for 
examples.  I can lend a hand if you have any questions.

-- 
paul moore
linux @ hp
