From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: state match is obsolete 1.4.17
Date: Tue, 15 Jan 2013 15:49:12 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301151534360.11172@blackhole.kfki.hu>
References: <CAMD-=V+PhM3NLpWyxB0G4KUN6D+-XKL0PZCBAuyUXUw56gmuJw@mail.gmail.com> <alpine.LNX.2.01.1301150958390.16853@nerf07.vanv.qr> <50F5273F.5020205@inliniac.net> <alpine.DEB.2.00.1301151102490.11129@blackhole.kfki.hu> <alpine.LNX.2.01.1301151342440.19279@nerf07.vanv.qr>
 <alpine.DEB.2.00.1301151406540.11172@blackhole.kfki.hu> <alpine.LNX.2.01.1301151444250.20224@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Victor Julien <lists@inliniac.net>,
	Nick Edwards <nick.z.edwards@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1301151444250.20224@nerf07.vanv.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 15 Jan 2013, Jan Engelhardt wrote:

> On Tuesday 2013-01-15 14:22, Jozsef Kadlecsik wrote:
> >> 
> >> state is currently aliased and translated to conntrack in iptables
> >> if the kernel has it. No scripts are broken.
> >> 
> >> If the aliasing is done in userspace, the kernel part can be removed -
> >> someday maybe.
> >
> >The aliasing is already done in userspace. One types in "state" and it's 
> >converted into "conntrack" and that is then sent to the kernel. (So as far 
> >as I see if the ipt_state, etc module aliases were added to the conntrack 
> >module, even the state kernel module could be removed.)
> 
> The module aliases were added because the module in fact (still) supports
> the "state" extension by that name.

No, please don't "still". It implies "for a while, then it won't".
 
> >However I suggest to delete the obsolete warnings completely from iptables 
> >and let these cases silently be handled as aliases.
> 
> Then users will complain about spooky action at a distance.
> (silent changing of rules) - not a great perspective either.
> The obsolescence warning is an important part of documenting
> changed behavior, and you really really do not want to take
> that away from users.

With passing one more internal flag, indicating that the "state" alias is 
used, the "conntrack" module can remain completely hidden and the user can 
list/save exactly the same command as the issued one.

I do not want to take away the "state" match at all from the users, and 
don't want it to be tainted by a warning either. This is a basic match 
used everywhere and there's no point in forcing everyone to use a new 
syntax.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
