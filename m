From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: POM Xtables???
Date: Mon, 30 Jun 2008 23:11:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806302236070.29802@blackhole.kfki.hu>
References: <935fab200806271054oa7c340evbf465b7a9984498b@mail.gmail.com>
 <alpine.LNX.1.10.0806272003170.12725@fbirervta.pbzchgretzou.qr>
 <4866F152.7030109@riverviewtech.net> <935fab200806300904rc7dc7b2kf58ab7893c3ef20a@mail.gmail.com>
 <486907EA.60105@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dave <finalglide@gmail.com>, Jan Engelhardt <jengelh@medozas.de>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <486907EA.60105@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, 30 Jun 2008, Patrick McHardy wrote:

> History has repeatedly shown that out of tree patches are buggy
> and cause more problems than they solve, which is why there
> is no interest from the netfilter team in maintaining external
> patches (with the one exception of ipset, which is not considered
> ready for upstream yet by Jozsef, its author).

The reason why I haven't been considering ipset ready for kernel inclusion 
is actually simple: the current ipset framework is not flexible enough due 
to the rigid kernel<->userspace communication method and it does not 
support IPv6 at all. As I had expected to be ready with the next 
generation of ipset (codename nfset) more soon, I have been refraining to 
submit ipset for kernel inclusion. nfset is finally getting shape, by the 
end of summer it'll be released. So the reason not to submit ipset is 
stronger than ever.

In order to make life easier, as I apply the patches sent by Swen, 
there'll be a new, "standalone" version of ipset, i.e. it'll be possible 
to use it without patch-o-matic-ng.
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
