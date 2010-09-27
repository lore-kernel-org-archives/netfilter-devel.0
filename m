From: Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal secid
Date: Mon, 27 Sep 2010 15:45:48 -0400
Message-ID: <1285616748.4935.43.camel@sifl>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
	 <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>
	 <alpine.LRH.2.00.1009271038280.25748@tundra.namei.org>
	 <1285606896.2815.36.camel@localhost.localdomain>
	 <1285612156.4935.16.camel@sifl>
	 <1285615525.2815.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
	selinux@tycho.nsa.gov, netfilter-devel@vger.kernel.org,
	sds@tycho.nsa.gov, jengelh@medozas.de, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
	mr.dash.four@googlemail.com
To: Eric Paris <eparis@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:34533 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab0I0Tp7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:45:59 -0400
In-Reply-To: <1285615525.2815.76.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2010-09-27 at 15:25 -0400, Eric Paris wrote:
> On Mon, 2010-09-27 at 14:29 -0400, Paul Moore wrote:
> > On Mon, 2010-09-27 at 13:01 -0400, Eric Paris wrote:
> > > On Mon, 2010-09-27 at 10:50 +1000, James Morris wrote:
> > > > On Fri, 24 Sep 2010, Eric Paris wrote:
> > > 
> > > > For the reasons above, I think the secctx string needs to be exported in 
> > > > addition to this rather than instead of.
> > > 
> > > I won't argue, I don't agree with your reasoning, but I'm not opposed to
> > > this result.  We have 3 competing suggestions:
> > > 
> > > Jan suggested we:
> > > completely eliminate secmark from procfs+netlink and only export secctx
> > > in netlink.
> > > 
> > > Eric suggested we:
> > > completely eliminate secmark from procfs+netlink and then export secctx
> > > in procfs+netlink
> > > 
> > > sounds like James suggested we:
> > > continue to export meaningless and confusing secmark from procfs+netlink
> > > and then export secctx in procfs+netlink as well.
> > > 
> > > I'm going to implement James' idea and resend the patch series.  Any
> > > strong objections?
> > 
> > I apologize for not getting a chance to look at these patches sooner.
> > In general they look fine to me and my only real concern was addressed
> > by Pablo already (breaking userspace due to #define changes).
> > 
> > As far as exporting the 32bit secid/secmark to userspace, I think that
> > is a mistake.  James correctly points out that it does map to a LSM
> > specific value, e.g. SELinux and Smack security labels, but I don't
> > think he makes it clear that in the two LSMs that currently use secids
> > the mapping between the secid and the secctx is not constant; the secids
> > are transient values that will change with each boot in a manner that
> > userspace can not predict.  For this reason, I think exporting the
> > secids is only going to cause users/admins grief, whereas exporting the
> > associated secctx should be a much more stable value and is likely what
> > the user/admin is expecting anyway.
> 
> So it sounds to me like Paul agrees with me that exporting the SELinux
> sid as 'secmark=' was a bad idea.  It's the whole reason this thread
> started, someone wanted to be able to translate and use that field (and
> instantly realized it was useless.)
> 
> I see it as having 3 options.  lets assume was have a packet with
> selinux sid=121 and selinux context=packet_t.  We can
> 
> 1) secmark=121 secctx=packet_t
> 	This continues to send secmark like we do and people might continue to
> be baffled by the 121.
> 
> 2) secmark=1 secctx=packet_t
> 	This sends a secmark field to userspace so if an application which
> reads this exists (I doubt such an application actually exists in in the
> real world) it will still get all of the information it got before but
> noone will be baffled by what the number means.  1/0 is pretty obvious.
> 
> 3) secctx=packet_t
> 	Smallest easiest, what my patches actually do.  Could theoretically
> break some script that expected the field to be there, but any such
> script is already broken since that field can be easily compiled
> out......
> 
> James, if you are adamant about #1 I'll resend, otherwise I'm sticking
> with #3.....

James, if you do feel strongly about door #1, can you provide a good
example of how someone might use the secid to do something useful in
userspace?  I ask because I can't think of anything and it would be nice
to have the example on record for future work.

-- 
paul moore
linux @ hp


