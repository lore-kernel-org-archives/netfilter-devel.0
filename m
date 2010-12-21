From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Tue, 21 Dec 2010 15:03:08 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012211457020.15662@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu>  <1292657351.2371.73.camel@kushiel.sterenborg.info>  <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu> <1292930054.3313.15.camel@ns014530.dcyb.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: "Rob Sterenborg (lists)" <lists@sterenborg.info>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1292930054.3313.15.camel@ns014530.dcyb.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Rob,

On Tue, 21 Dec 2010, Rob Sterenborg (lists) wrote:

> On Sat, 2010-12-18 at 12:13 +0100, Jozsef Kadlecsik wrote:
> 
> > > When running 'configure' I got this error:
> > > 
> > > ./configure: line 11510: syntax error near unexpected token `[libmnl],'
> > > ./configure: line 11510: `PKG_CHECK_MODULES([libmnl], [libmnl >= 1])'
> > > 
> > > CentOS' pkg-config is installed, so, for reference: I copied
> > > '/usr/share/aclocal/pkg.m4' into the 'm4' directory, ran 'autogen.sh'
> > > again and after that 'configure' had no problems.
> > 
> > Autoconf has its own pitfalls... I can't reproduce it so I added
> > 'aclocal -I m4' to autogen.sh. After checking out the git tree, could you 
> > give it a try whether it solves the issue?
> 
> Call me stupid, but I couldn't figure out how to download the git branch
> using git (when I did, I downloaded the 4.5 tree), but I did see it on
> the web inferface. I downloaded today's snapshot from the git-5 branch;
> I hope that's the same. I still get the same error however.

Clone the git tree, then checkout the ipset-5 branch:

% git clone git://git.netfilter.org/ipset.git
% cd ipset
% git checkout ipset-5

> > > # ipset create TEST hash   
> > > ipset v5.0: Syntax error: typename 'hash' is unkown
> > > 
> > > (As per ipset.8 example.)
> > > # ipset create foo bitmap:ip range 192.168.0.0/16
> > > ipset v5.0: Kernel error received: Invalid argument
> > > 
> > > # ipset list               
> > > ipset v5.0: Kernel error received: Invalid argument
> > > 
> > > # lsmod|grep set
> > > ip_set                 16790  0 
> > > nfnetlink               3179  2 ip_set,nf_conntrack_netlink
> > > 
> > > So, I guess something must have gone wrong when compiling ipset anyhow.
> > 
> > Please read the README file: you must patch your kernel source with 
> > netlink.patch, compile and install it. Otherwise the new nfnetlink id 
> > won't handled by the kernel and thus ipset can't work.
> 
> I did this. The patch succeeded and compilation went, except for pkg.m4
> which is easily resolved, without errors that I can see. I still get the
> above results however.

I can think only that you still have the unpatched kernel binary running. 
Please note, netlink cannot be compiled as module, it's in the core 
kernel. So it's required to reboot using the patched kernel core.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
