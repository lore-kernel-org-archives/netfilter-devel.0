From: Herve Eychenne <rv@wallfire.org>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Wed, 21 Jan 2004 00:21:03 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040120232103.GB1143@eychenne.org>
References: <20040120011305.GD1142@eychenne.org> <Pine.LNX.4.44.0401200743490.23963-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401200743490.23963-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 20, 2004 at 08:05:45AM +0100, Henrik Nordstrom wrote:

> On Tue, 20 Jan 2004, Herve Eychenne wrote:

> > Yes, as it is always some kind of "static".
> > You'll note that the reason why I prefer a program to a "static" (eve=
n
> > if generated at iptables compile time) manpage is that the manpage wi=
ll
> > not reflect your current combination (at least durably), again.

> But with iptables the best level or program is the same as you get with=
=20
> the proposed patch, the manpage reflects what your userspace binary=20
> supports, independent of what the kernel supports.

Yes, and that is another question I want to raise...
I don't really understand why p-o-m would not add both parts (kernel/user=
).
That would mean not distributing an iptables tarball with every
extensions. According to me, adding an extension should be treated
equally on user and kernel sides (as they are heavily coupled).

> Actually, fixing the error message is not hard, but it requires some sl=
igt=20
> additions to the kernel to allow querying if a given target/match is=20
> supported so users of old kernels will have to live with the obscure=20
> error even after the problem has been addressed.

Why isn't this done already? ;-)

> > Please note that I do not suggest this shouldn't be done. If we write
> > the program I'm talking about, it will be perfectly feasible (and
> > it should be done) to generate a document (manpage, or other)
> > documented every existing module.

> What I don't get is what this program approach gives which the=20
> at-compiletime build of the manpage does not.

If you think of the current scheme, where you're forced to recompile
userspace after having used patch-o-matic, not so much: filtering
capabilities... (mainstream or not, match or target, specific version
or all, currently available or not, etc.).=20
A way to know all that is available in every kind of context is needed
anyway, independantly of the documentation, anyway.

> > That doesn't prevent from providing a program which generates a
> > manpage dynamically (if you really want it in a manpage format)...

> Not easily in a way which allows the manpage to be packaged I think.

Packaged in the sense of a distribution package?
Well... the "extension" manpage would simply not be part of the
package itself (which is static, by essence)... but the package would
include the doc (manpage, if we want) generator.

> In addition it does not solve the problem of userspace/kernel mismatche=
s (see=20
> below).

> > Yes. That state is not always that clear. For example, a feature coul=
d belong to
> > p-o-m for a certain kernel version, and mainstream for kernel version=
 + 1.
> > But! You (netfilter developer) perfectly know what this is all about.

> So then we should try to have this better documented than it is today. =
=20
> Mentioning p-o-m in the iptables documentation would be a start..

p-o-m is already mentionned, but in the netfilter extensions HOWTO, I
think. It is not mentionned in the manpage, but iptables manpage is
about userspace anyway. And that has been a moment since I think that
there really should be a manpage about userspace (iptables), a manpage
about kernel (there are some things to tell, and I have started one,
which I'll sent in a few days), and one about extensions.

> > I do not understand. A manpage with every extensions will only tell
> > you what you could have, and you would have to experiment quite much
> > (with uninformative error messages) to know what you can really _use_=
.

> What I propose is a manpage with

> a) Every extension which is known to your userspace binary (i.e. the=20
> extensions which was enabled in the kernel the binary is built for)

> b) In addition, the documentation for the extensions (where such
> documentation exists) you could have with documentation on how you get
> these from p-o-m if you need them. This could be in the same page or a
> different page if having them in the same page may confuse people (I th=
ink=20
> not, but I am not the average user)

> Not a dumb page where all extensions is documented as if they were=20
> supported on the users system.

If we really want a userspace-compile-time-built manpage, then yes,
probably.

> > And this is all to be done again when you upgrade the kernel...

> Yes, and the iptables binary needs to be rebuilt as well to add binary=20
> support for the added/changed matches/targets. This is the current stat=
e=20
> of affairs anyway.

Yes, but that should be different. There's unfortunately no easy way
to have a good module management system (fast adding, no recompilation
needed, no binary interface problems) for iptables. :-(  (pkttables
will be the place to do that, as we discussed during the workshop)

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
