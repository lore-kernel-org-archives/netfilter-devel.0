From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-2.3.3
Date: Mon, 21 Jul 2008 16:36:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807211633550.26314@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0807192259320.24664@blackhole.kfki.hu>
 <Pine.LNX.4.58.0807201524360.8513@mail3.jubileegroup.co.uk>
 <Pine.LNX.4.64.0807201824590.25442@blackhole.kfki.hu>
 <Pine.LNX.4.58.0807210815530.30128@mail3.jubileegroup.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: "G.W. Haywood" <ged@jubileegroup.co.uk>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0807210815530.30128@mail3.jubileegroup.co.uk>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 21 Jul 2008, G.W. Haywood wrote:

> > Do you compile your kernel without modules?
> 
> All my production kernels are compiled without modules, but in this
> case I had enabled modules in the kernel .config file - otherwise I
> could not have expected it to build.  (Obviously:)
> 
> > I have just released 2.3.3a which should fix it. Please give it a try.
> 
> That's fine now.
> 
> Is there any chance of being able to compile a non-modular 2.4 kernel
> with the released ipsets, or am I on my own with that?

With ipset-2.3.3a you should be able to compile a non-modular kernel. 
I.e. you can configure the features of the patched kernel as you want and 
it should be compiled cleanly.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
