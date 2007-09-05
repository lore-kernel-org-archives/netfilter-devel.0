From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal netfilter socket option removal
Date: Wed, 5 Sep 2007 15:27:44 -0400
Message-ID: <20070905192744.GB25050@hmsreliant.think-freely.org>
References: <20070904202433.GA19083@hmsreliant.think-freely.org> <46DEC9BF.9010807@trash.net> <1189008806.10802.150.camel@localhost.localdomain> <20070905170831.GA25050@hmsreliant.think-freely.org> <1189014097.10802.174.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, adam@yggdrasil.com,
	jcm@jonmasters.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932136AbXIET30@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1189014097.10802.174.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 06, 2007 at 03:41:37AM +1000, Rusty Russell wrote:
> On Wed, 2007-09-05 at 13:08 -0400, Neil Horman wrote:
> > On Thu, Sep 06, 2007 at 02:13:26AM +1000, Rusty Russell wrote:
> > > On Wed, 2007-09-05 at 17:22 +0200, Patrick McHardy wrote:
> > > > But I'm wondering, wouldn't module refcounting alone fix this problem?
> > > > If we make nf_sockopt() call try_module_get(ops->owner), remove_module()
> > > > on ip_tables.ko would simply fail because the refcount is above zero
> > > > (so it would fail at point 3 above). Am I missing something important?
> > > 
> > > Yes, that seems the correct solution to me, too.  ISTR that this code
> > > predates the current module code.
> > > 
> > > Rusty.
> > 
> > Thanks guys-
> > 	When I first started looking at this problem I would have agreed with
> > you, that module reference counting alone would fix the problem.  However,
> > delete_module can work in either a non-blocking or a blocking mode.  rmmod
> > passes O_NONBLOCK to delete module, and so is fine, but modprobe does not.
> 
> Hi Neil,
> 
> 	You have this backwards: O_NONBLOCK is the default.  That seems to be
> what everyone wants, although I implemented 'rmmod -w' because it seemed
> like a good option.
> 
Thats really the point I'm trying to make.  O_NONBLOCK should be the default,
but it isn't in the case of modprobe. If you look at the rmmod sources,
O_NONBLOCK is set in the flags field in the main routine, and cleared if the -w
option is set.  Whereas in the modprobe sources the only call ever made to
delete_module passes the O_EXLC flag only, and never sets O_NONBLOCK, resulting
in persistent blocking operation.  My 2nd patch corrects this by adding a flags
variable to modprobe and setting it to O_NONBLOCK|O_EXLC, and clearing it if the
(new) -w option is specified to modprobe, just like in rmmod.

Now, I suppose its possible that I've not been looking at the right source tree
when doing my work.  I've based my modprobe patch on this git tree:
http://git.kernel.org/?p=linux/kernel/git/kyle/module-init-tools.git;a=summary
If theres a newer one, if you could please point it out to me, I'd appreciate
it.  If the functional equivalent of my second patch is already in there, then
we just need my first patch to be good to go.

Thanks & Regards
Neil

> Rusty.
> 

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
