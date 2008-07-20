From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-2.3.3
Date: Sun, 20 Jul 2008 21:48:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807202147180.25564@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0807192259320.24664@blackhole.kfki.hu>
 <Pine.LNX.4.58.0807201524360.8513@mail3.jubileegroup.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: "G.W. Haywood" <ged@jubileegroup.co.uk>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0807201524360.8513@mail3.jubileegroup.co.uk>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Greg,

On Sun, 20 Jul 2008, G.W. Haywood wrote:

> On Sat, 19 Jul 2008, Jozsef Kadlecsik wrote:
> 
> > This is a compatibility fix release of ipset which supports kernel
> > versions >= 2.6.16 and 2.4.36.x [snip]
> > If you run ipset on a 2.4 kernel, please upgrade as you'll get all the
> > bugfixes (which had been forgotten to backport) and iptreemap support.
> 
> Currently running 2.4.35.1 patched for ipsets by hand using the old
> POM sources.  No problems with that at all.
> 
> Using fresh kernel 2.36.6 source and the ipsets source download from
> http://ipset.netfilter.org/ I can't seem to get past this failure to
> build the kernel, no matter how I permute the building and patching
> instructions, although I've put no time into actually debugging it:
> 
> ip_set.c: In function `ip_set_register_set_type':
> ip_set.c:329: parse error before ',' token
> ip_set.c: In function `ip_set_create':
> ip_set.c:840: parse error before ',' token

I have just released 2.3.3a which should fix it. Please give it a try.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
