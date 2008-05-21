From: Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH 3/4] add support for modifying secmark via ctnetlink
Date: Wed, 21 May 2008 13:41:42 -0400
Message-ID: <200805211341.42765.paul.moore@hp.com>
References: <483350D3.50103@netfilter.org> <200805211246.07481.paul.moore@hp.com> <1211388856.7486.366.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	James Morris <jmorris@namei.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:41398 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936399AbYEURlu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 13:41:50 -0400
In-Reply-To: <1211388856.7486.366.camel@moss-spartans.epoch.ncsc.mil>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 21 May 2008 12:54:16 pm Stephen Smalley wrote:
> On Wed, 2008-05-21 at 12:46 -0400, Paul Moore wrote:
> > I agree with James that we need to perform some access check before
> > setting the ct->secmark field, however, I don't think it is as
> > simple as calling selinux_secmark_relabel_packet_permission().  The
> > problem is that the selinux_secmark_relabel_packet_permission()
> > function checks to see if the currently running task can relabel
> > packets; in this case we don't want to check the currently running
> > task we want to check the sender of the netlink message which we
> > can't really do currently.
>
> Sending task SID is saved in NETLINK_CB(skb).sid at send time, so the
> information is available (but would need to be passed into the
> function).

Thanks, that is good to know, I missed that.

-- 
paul moore
linux @ hp
