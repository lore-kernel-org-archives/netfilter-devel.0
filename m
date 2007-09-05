From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
Date: Thu, 06 Sep 2007 03:41:37 +1000
Message-ID: <1189014097.10802.174.camel@localhost.localdomain>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
	 <46DEC9BF.9010807@trash.net>
	 <1189008806.10802.150.camel@localhost.localdomain>
	 <20070905170831.GA25050@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, adam@yggdrasil.com,
	jcm@jonmasters.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755963AbXIERmd@vger.kernel.org>
In-Reply-To: <20070905170831.GA25050@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2007-09-05 at 13:08 -0400, Neil Horman wrote:
> On Thu, Sep 06, 2007 at 02:13:26AM +1000, Rusty Russell wrote:
> > On Wed, 2007-09-05 at 17:22 +0200, Patrick McHardy wrote:
> > > But I'm wondering, wouldn't module refcounting alone fix this problem?
> > > If we make nf_sockopt() call try_module_get(ops->owner), remove_module()
> > > on ip_tables.ko would simply fail because the refcount is above zero
> > > (so it would fail at point 3 above). Am I missing something important?
> > 
> > Yes, that seems the correct solution to me, too.  ISTR that this code
> > predates the current module code.
> > 
> > Rusty.
> 
> Thanks guys-
> 	When I first started looking at this problem I would have agreed with
> you, that module reference counting alone would fix the problem.  However,
> delete_module can work in either a non-blocking or a blocking mode.  rmmod
> passes O_NONBLOCK to delete module, and so is fine, but modprobe does not.

Hi Neil,

	You have this backwards: O_NONBLOCK is the default.  That seems to be
what everyone wants, although I implemented 'rmmod -w' because it seemed
like a good option.

Rusty.
