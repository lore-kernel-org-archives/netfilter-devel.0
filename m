From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Expose x_tables /proc entries as 0444 not 0440
Date: Wed, 11 Nov 2015 21:10:13 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1511112105280.16131@blackhole.kfki.hu>
References: <20151107074939.GA4003@compaq.slightly-cracked.com> <20151111165026.GA20549@salvia> <20151111184052.GA26909@breakpoint.cc> <alpine.LSU.2.20.1511111945170.32360@nerf40.vanv.qr> <20151111193539.GA2751@compaq.slightly-cracked.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Phil Whineray <phil@firehol.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:56413 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbbKKUIh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 15:08:37 -0500
In-Reply-To: <20151111193539.GA2751@compaq.slightly-cracked.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 11 Nov 2015, Phil Whineray wrote:

> On Wed, Nov 11, 2015 at 07:48:11PM +0100, Jan Engelhardt wrote:
> > On Wednesday 2015-11-11 19:40, Florian Westphal wrote:
> > >Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >> > Hiding the contents from non-root users does not achieve anything
> > >> > practical. Possible values are well-known and the specifics can
> > >> > be inferred from a list of loaded modules on most systems.
> > 
> > Conversely, an administrator could just load all modules to give a false 
> > impression. Since the adversary can in turn expect it, he knows as 
> > little as before. In particular, containerized environments will have it 
> > such that many modules are loaded, but each container still has their 
> > own ruleset.
> > So yeah, hiding the contents is not going to achieve anything - nor is 
> > showing. (I am concurring here with the other respondents.)
> 
> Sorry - I've gotten confused about who thinks what exactly. I hope
> the below isn't wasting everyone's time.

My opinion is that the files should not be exposed. Whenever it does not 
clash something vital and cannot be resolved I run kernels with grsec, 
where normal user cannot list the loaded in kernel modules. By exposing 
these files, some part of that data would then be leaked out.

> Unhiding /proc/ip_tables_names content achieves something specific: it
> is used by iptables-save to determine what it should write out (in
> the absence of a specific table being asked for, which I believe is
> the norm).
> 
> I currently have a workaround using a horrific series of bind mounts
> which substitutes in a normal file with the values iptables-save expects.
> 
> Two alternates on the table are:
> 
> - change ownership of the file in the namespace (wherein a user runs
>   "unshare -U -r -n cat /proc/net/ip_tables_names" to do the same as
>   "cat /proc/net/ip_tables_names" with 0444 perms, so not adding much
>   unless unprivileged namespaces are disabled.

I don't quite understand this: if the ownership of the files are changed, 
then why do you need to change the access right to 0444?
   
> - try to do something with capabilities (I'd need to research this)
> 
> Given /proc/modules is 0444 and the observation that loaded != used
> I don't think any significant information is leaked by the patch. I
> don't mind having a stab at an alternate implementation but is it worth
> it?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
