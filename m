From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal netfilter socket option removal
Date: Wed, 5 Sep 2007 13:08:31 -0400
Message-ID: <20070905170831.GA25050@hmsreliant.think-freely.org>
References: <20070904202433.GA19083@hmsreliant.think-freely.org> <46DEC9BF.9010807@trash.net> <1189008806.10802.150.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, adam@yggdrasil.com,
	jcm@jonmasters.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758129AbXIERKb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1189008806.10802.150.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 06, 2007 at 02:13:26AM +1000, Rusty Russell wrote:
> On Wed, 2007-09-05 at 17:22 +0200, Patrick McHardy wrote:
> > But I'm wondering, wouldn't module refcounting alone fix this problem?
> > If we make nf_sockopt() call try_module_get(ops->owner), remove_module()
> > on ip_tables.ko would simply fail because the refcount is above zero
> > (so it would fail at point 3 above). Am I missing something important?
> 
> Yes, that seems the correct solution to me, too.  ISTR that this code
> predates the current module code.
> 
> Rusty.

Thanks guys-
	When I first started looking at this problem I would have agreed with
you, that module reference counting alone would fix the problem.  However,
delete_module can work in either a non-blocking or a blocking mode.  rmmod
passes O_NONBLOCK to delete module, and so is fine, but modprobe does not.  So
if you currently use modprobe -r to remove modules (as the iptables service
script nominally does), modprobe winds up waiting in the kernel for the module
reference count to become zero.  Since we can hold a reference to the module
being removed in the same path that forks a modprobe request to load that same
module (which then blocks on the first modprobes fcntl lock), we still get
deadlock.  The way I fixed this was by use of the second patch, which brings
modprobes behavior into line with the rmmod utility (which is to default to
non-blocking operation), leading to the remove_module failure and breaking of
the deadlock that you describe above.

Thanks & Regards
Neil

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
