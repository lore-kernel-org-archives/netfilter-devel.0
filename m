From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
Date: Thu, 06 Sep 2007 08:41:09 +1000
Message-ID: <1189032069.10802.212.camel@localhost.localdomain>
References: <20070904203053.GC19083@hmsreliant.think-freely.org>
	 <1189023999.12261.147.camel@jcmlaptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>, adam@yggdrasil.com,
	jcm@jonmasters.org, kaber@trash.net,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
To: Jon Masters <jonathan@jonmasters.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757350AbXIEWlq@vger.kernel.org>
In-Reply-To: <1189023999.12261.147.camel@jcmlaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2007-09-05 at 16:26 -0400, Jon Masters wrote:
> On Tue, 2007-09-04 at 16:30 -0400, Neil Horman wrote:
> 
> > 	2nd of two patches.  This patch enhances modprobe to operate like rmmod
> > in non-blocking mode.  It also adds a -w option to allow for explicit blocking
> > operation.
> 
> As I suspected, this patch isn't in the tree. I am going to commit it
> now because it makes sense. I'm also going to sort out moving things to
> kernel.org this afternoon while I'm at it - I don't want to confuse
> people with kerneltools.org any more now I've got a kernel.org acc.

1) You don't want to hand the "wait" flag (ie ~O_NONBLOCK) to
sub-rmmods,

2) You need to do something about this code if wait is specified:

	if (usecount != 0) {
		if (!ignore_inuse)
			error("Module %s is in use.\n", name);
		goto remove_rest;
	}

Cheers,
Rusty.
