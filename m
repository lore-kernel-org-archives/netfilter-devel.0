From: "Rob Sterenborg (lists)" <lists@sterenborg.info>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Tue, 21 Dec 2010 12:14:14 +0100
Message-ID: <1292930054.3313.15.camel@ns014530.dcyb.net>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu>
	 <1292657351.2371.73.camel@kushiel.sterenborg.info>
	 <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2010-12-18 at 12:13 +0100, Jozsef Kadlecsik wrote:

Hi Jozsef,

> > When running 'configure' I got this error:
> > 
> > ./configure: line 11510: syntax error near unexpected token `[libmnl],'
> > ./configure: line 11510: `PKG_CHECK_MODULES([libmnl], [libmnl >= 1])'
> > 
> > CentOS' pkg-config is installed, so, for reference: I copied
> > '/usr/share/aclocal/pkg.m4' into the 'm4' directory, ran 'autogen.sh'
> > again and after that 'configure' had no problems.
> 
> Autoconf has its own pitfalls... I can't reproduce it so I added
> 'aclocal -I m4' to autogen.sh. After checking out the git tree, could you 
> give it a try whether it solves the issue?

Call me stupid, but I couldn't figure out how to download the git branch
using git (when I did, I downloaded the 4.5 tree), but I did see it on
the web inferface. I downloaded today's snapshot from the git-5 branch;
I hope that's the same. I still get the same error however.

I've resolved the other issues I had: I should have thought of
installing the accompanying kernel header files.

> > Finally, when trying the new ipset it seems that except for 'version',
> > every command I tried returns 'Invalid argument':
> > 
> > (Yes I know this is incorrect syntax, but now I know it's trying to do
> > something besides giving me 'Invalid argument'.)
> > # ipset create TEST hash   
> > ipset v5.0: Syntax error: typename 'hash' is unkown
> > 
> > (As per ipset.8 example.)
> > # ipset create foo bitmap:ip range 192.168.0.0/16
> > ipset v5.0: Kernel error received: Invalid argument
> > 
> > # ipset list               
> > ipset v5.0: Kernel error received: Invalid argument
> > 
> > # lsmod|grep set
> > ip_set                 16790  0 
> > nfnetlink               3179  2 ip_set,nf_conntrack_netlink
> > 
> > So, I guess something must have gone wrong when compiling ipset anyhow.
> 
> Please read the README file: you must patch your kernel source with 
> netlink.patch, compile and install it. Otherwise the new nfnetlink id 
> won't handled by the kernel and thus ipset can't work.

I did this. The patch succeeded and compilation went, except for pkg.m4
which is easily resolved, without errors that I can see. I still get the
above results however.

> Thanks for tests and the reporting!

NP. Thank you..


Rob


