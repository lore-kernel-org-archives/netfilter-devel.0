From: =?iso-8859-2?q?T=F6r=F6k_Edwin?= <edwin.torok@level7.ro>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting both incoming and outgoing packets
Date: Mon, 20 Feb 2006 19:40:40 +0200
Message-ID: <200602201940.40504.edwin.torok@level7.ro>
References: <200602181410.59757.edwin.torok@level7.ro> <Pine.LNX.4.64.0602201122330.21034@excalibur.intercode>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@lists.netfilter.org,
	fireflier-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, martinmaurer@gmx.at,
	Patrick McHardy <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161075AbWBTRl3@vger.kernel.org>
To: James Morris <jmorris@namei.org>
In-Reply-To: <Pine.LNX.4.64.0602201122330.21034@excalibur.intercode>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Monday 20 February 2006 18:26, James Morris wrote:
> On Sat, 18 Feb 2006, T=F6r=F6k Edwin wrote:
> > This is a patch based on Luke Kenneth Casson Leighton's patch [1]
> > One problem with that patch was that it couldn't be used for filter=
ing
> > incoming packets, due to the fact that more than one process can li=
sten
> > on the same socket ([2],[3]).
>
> Have a look at my skfilter patches:
> http://people.redhat.com/jmorris/selinux/skfilter/kernel/
I already looked at them yesterday evening,(I found a link in a lwn.net=
=20
article).  Nice work :-)
Having your patches applied to mainline kernel would solve many of my=20
problems.
 >
> These implement a scheme for matching incoming packets against socket=
s by
> adding a new hook in the socket layer.

AFAICT this solves the "incoming packets" problem and will I also be ab=
le to=20
filter data sent through raw sockets?

If selinux is enabled and available then the skfilter patch solves all =
of=20
fireflier's problems. Nice.

In the following I will be referring to 16-skfilter-ipt_owner-ctx.patch=
:

However I'd like to do filtering based on owner (process) even when sel=
inux is=20
not available. Your context match explicitly requires selinux to be ena=
bled,=20
and a policy loaded. Is there a way to do context matching, when bootin=
g with=20
selinux=3D0, i.e. is there a way to enable just a minimal subset of sel=
inux,=20
that would do this:
 - (auto)label processes based on its inode/mount-point
- (auto)label all sockets that a process has access to with the process=
's=20
label (or better: its domain)
- do context matching based on these labels (if I understood correctly =
this is=20
what your patch does)

Could you please use LSM hooks (like inode_getsecurity) instead of dire=
ctly=20
using selinux? I'd want to provide my own implementation of labeling (a=
=20
very,very simple labeling, a very small subset of what selinux does, bu=
t=20
which wouldn't require much configuration). In other words, I want to w=
rite a=20
LSM, and then mod_register_security() my module.

Or if the above is not possible, could you provide some hooks, where I =
could=20
register my hooks to provide these:
- int available()
- int ctx_to_id(char*,u32*)
- int socket_to_ctxid(struct sock*,u32*)

(Of course I could create another match that would use my module to do =
the=20
matching on the SOCKET  chain. But this would uselessly duplicate=20
functionality&code, an additional hook would be a much cleaner solution=
).

What is your opinion on what I said above? I am open to suggestions,=20
criticism, advice....

Thanks,
Edwin
>
> For upstream merge, the issues are:
> - should the new socket hook be used for all incoming packets?
> - ensure IP queuing still works
>
> Patrick: any other issues?
>
>
>
> - James
