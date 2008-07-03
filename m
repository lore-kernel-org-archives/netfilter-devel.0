From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Thu, 3 Jul 2008 11:54:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807031150290.1816@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu>
 <Pine.LNX.4.64.0807021536140.4958@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0807021545290.32444@blackhole.kfki.hu>
 <Pine.LNX.4.64.0807021547090.4958@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0807021559170.32444@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807021559170.32444@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2 Jul 2008, Jozsef Kadlecsik wrote:

> On Wed, 2 Jul 2008, Krzysztof Oledzki wrote:
> 
> > > > Is statically linking still supported?
> > > 
> > > No, it has never been supported. (Probaly you mean iptables?)
> > 
> > No, I mean kernel.
> > 
> > I ask because http://ipset.netfilter.org/install.html no longer points to a
> > pom-ng file and it seems that
> > ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/ is currently abandoned
> > - there have been no new files created since 2008-05-21.
> 
> Oh, I see. I'll add back a pom-ng snapshot to ipset.netfilter.org. The 
> pom-ng repository is available from svn - the snapshot creation was 
> probably stopped when most of the repositories were moved to git.

In ordert to cut the last ropes tying ipset to pom-ng, I added support to 
"patch" the kernel directly to the ipset package. 

So I have just released ipset-2.3.2a, which includes the required bits and 
files with and updated README file on how to compile modular and 
non-modular kernels with ipset support. Please give it a try and report me 
if something would be missing.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
