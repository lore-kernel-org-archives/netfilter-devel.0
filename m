From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
Date: Thu, 06 Sep 2007 09:35:32 -0400
Message-ID: <1189085732.12261.187.camel@jcmlaptop>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
	 <46DEC9BF.9010807@trash.net>
	 <1189008806.10802.150.camel@localhost.localdomain>
	 <20070905170831.GA25050@hmsreliant.think-freely.org>
	 <1189014097.10802.174.camel@localhost.localdomain>
	 <20070905192744.GB25050@hmsreliant.think-freely.org>
	 <1189028351.12261.166.camel@jcmlaptop>
	 <20070906125554.GB31868@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Patrick McHardy <kaber@trash.net>, adam@yggdrasil.com,
	jcm@jonmasters.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757799AbXIFNio@vger.kernel.org>
In-Reply-To: <20070906125554.GB31868@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2007-09-06 at 08:55 -0400, Neil Horman wrote:
> On Wed, Sep 05, 2007 at 05:39:11PM -0400, Jon Masters wrote:
> > On Wed, 2007-09-05 at 15:27 -0400, Neil Horman wrote:
> > 
> > > Now, I suppose its possible that I've not been looking at the right source tree
> > > when doing my work.  I've based my modprobe patch on this git tree:
> > > http://git.kernel.org/?p=linux/kernel/git/kyle/module-init-tools.git;a=summary
> > > If theres a newer one, if you could please point it out to me, I'd appreciate
> > > it.  If the functional equivalent of my second patch is already in there, then
> > > we just need my first patch to be good to go.
> > 
> > Neil, please test:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/jcm/module-init-tools/module-init-tools-3.3-pre12.tar.bz2
> > 
> > Jon.
> > 
> Good to go.  Thanks Jon!

Yeah, except I need to play "listen to Rusty" and "Rusty knows best",
then refix it again, after doing so (see his email).

Jon.
