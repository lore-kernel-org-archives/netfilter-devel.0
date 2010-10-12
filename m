From: Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH 2/5] secmark: make secmark object handling generic
Date: Tue, 12 Oct 2010 19:20:48 -0400
Message-ID: <1286925648.5133.103.camel@sifl>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
	 <20101012154015.26943.18385.stgit@paris.rdu.redhat.com>
	 <1286924143.5133.86.camel@sifl>
	 <1286924512.2614.1.camel@localhost.localdomain>
	 <1286924762.5133.91.camel@sifl>
	 <1286925270.2614.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, jmorris@namei.org,
	selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jengelh@medozas.de,
	linux-security-module@vger.kernel.org, mr.dash.four@googlemail.com,
	pablo@netfilter.org
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1286925270.2614.9.camel@localhost.localdomain>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2010-10-12 at 19:14 -0400, Eric Paris wrote:
> On Tue, 2010-10-12 at 19:06 -0400, Paul Moore wrote:
> > On Tue, 2010-10-12 at 19:01 -0400, Eric Paris wrote:
> > > On Tue, 2010-10-12 at 18:55 -0400, Paul Moore wrote:
> > > > On Tue, 2010-10-12 at 11:40 -0400, Eric Paris wrote:
> > > > > Right now secmark has lots of direct selinux calls.  Use all LSM calls and
> > > > > remove all SELinux specific knowledge.  The only SELinux specific knowledge
> > > > > we leave is the mode.  The only point is to make sure that other LSMs at
> > > > > least test this generic code before they assume it works.  (They may also
> > > > > have to make changes if they do not represent labels as strings)
> > > > 
> > > > I'm sure you have, but I just want to make sure - you've tested this
> > > > change (and the others for that matter) against the existing iptables
> > > > userspace to make sure everything still works, right?
> > > 
> > > I did.  The only patch which needs userspace changes is the exporting of
> > > secctx over netlink.  It appears the current userspace tools just
> > > ignores unknown field types.  I have a patch to userspace to tell it
> > > about the new field and will send it after the kernel patch goes in.
> > 
> > Okay, that's good.  Is the existing, i.e. unmodified, userspace still
> > able set a Secmark with your patches applied?  That is the part I'm most
> > concerned about right now ...
> 
> It is.  Everything about secmark is still userspace ABI compatible.
> (except what I indicated)

Excellent, I figured that was the case but just wanted to see it in
writing :)

Acked-by: Paul Moore <paul.moore@hp.com>

-- 
paul moore
linux @ hp


