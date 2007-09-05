From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
Date: Thu, 06 Sep 2007 06:51:26 +1000
Message-ID: <1189025486.10802.206.camel@localhost.localdomain>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
	 <46DEC9BF.9010807@trash.net>
	 <1189008806.10802.150.camel@localhost.localdomain>
	 <20070905170831.GA25050@hmsreliant.think-freely.org>
	 <1189014097.10802.174.camel@localhost.localdomain>
	 <20070905192744.GB25050@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, adam@yggdrasil.com,
	jcm@jonmasters.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, Jim Radford <radford@blackbean.org>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757683AbXIEUwD@vger.kernel.org>
In-Reply-To: <20070905192744.GB25050@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2007-09-05 at 15:27 -0400, Neil Horman wrote:
> On Thu, Sep 06, 2007 at 03:41:37AM +1000, Rusty Russell wrote:
> > 	You have this backwards: O_NONBLOCK is the default.  That seems to be
> > what everyone wants, although I implemented 'rmmod -w' because it seemed
> > like a good option.
> > 
> Thats really the point I'm trying to make.  O_NONBLOCK should be the default,
> but it isn't in the case of modprobe.

Ouch, you're right!

And that's been around for a *long* time.  From the original 0.9.2
version (Dec 9th 2002).  ChangeLog says:

	Jim Radford <radford@blackbean.org>'s modprobe -r implementation.

The userspace check still stops most cases of removing used modules.

On the bright side, this one bug has probably done more to deprecate
module removal than any thing else, by making it unreliable...

Good catch!
Rusty.
