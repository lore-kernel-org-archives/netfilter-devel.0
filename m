From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere
 else (was Re: Fw: Rusty's brain broke!)
Date: Tue, 20 Jan 2004 08:05:45 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401200743490.23963-100000@filer.marasystems.com>
References: <20040120011305.GD1142@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20040120011305.GD1142@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 20 Jan 2004, Herve Eychenne wrote:

> Yes, as it is always some kind of "static".
> You'll note that the reason why I prefer a program to a "static" (even
> if generated at iptables compile time) manpage is that the manpage will
> not reflect your current combination (at least durably), again.

But with iptables the best level or program is the same as you get with 
the proposed patch, the manpage reflects what your userspace binary 
supports, independent of what the kernel supports.

This for the same reasons as the error when trying to use a target/match 
not supported gives an obscure error message.

Actually, fixing the error message is not hard, but it requires some sligt 
additions to the kernel to allow querying if a given target/match is 
supported so users of old kernels will have to live with the obscure 
error even after the problem has been addressed.

> Please note that I do not suggest this shouldn't be done. If we write
> the program I'm talking about, it will be perfectly feasible (and
> it should be done) to generate a document (manpage, or other)
> documented every existing module.

What I don't get is what this program approach gives which the 
at-compiletime build of the manpage does not.

> That doesn't prevent from providing a program which generates a
> manpage dynamically (if you really want it in a manpage format)...

Not easily in a way which allows the manpage to be packaged I think. In 
addition it does not solve the problem of userspace/kernel mismatches (see 
below).

> Yes. That state is not always that clear. For example, a feature could belong to
> p-o-m for a certain kernel version, and mainstream for kernel version + 1.
> But! You (netfilter developer) perfectly know what this is all about.

So then we should try to have this better documented than it is today.  
Mentioning p-o-m in the iptables documentation would be a start..

> People in real life (read "not developer life") often upgrade their
> kernel and iptables command via packages, and if they get to know the
> existence of p-o-m, they have only little time to keep tracking down if
> their favorite p-o-m modules have been included into mainstream or removed
> (from kernel, or cvs).

Yes, and this is also assumed by me.

What the above means is that the average user will always have a manpage 
which correctly reflects the capabilities of the iptables package he has 
been provided by his distributor, including any p-o-m patches the 
distributor may have selected to be part of their distribution.

> I do not understand. A manpage with every extensions will only tell
> you what you could have, and you would have to experiment quite much
> (with uninformative error messages) to know what you can really _use_.

What I propose is a manpage with

a) Every extension which is known to your userspace binary (i.e. the 
extensions which was enabled in the kernel the binary is built for)

b) In addition, the documentation for the extensions (where such
documentation exists) you could have with documentation on how you get
these from p-o-m if you need them. This could be in the same page or a
different page if having them in the same page may confuse people (I think 
not, but I am not the average user)

Not a dumb page where all extensions is documented as if they were 
supported on the users system.

> And this is all to be done again when you upgrade the kernel...

Yes, and the iptables binary needs to be rebuilt as well to add binary 
support for the added/changed matches/targets. This is the current state 
of affairs anyway.

> > * A howto explaining/discussing in more depth why/when/how certain matches
> > should be used, what p-o-m is, and how to use things from p-o-m. (the
> > extensions howto). This does not need to include the reference material
> > and can refer to the reference documentation for further details.
> 
> Yes. Such a document doesn't really exist yet, although it would be
> very useful. But it's orthogonal to the discussion, as it is an
> "editorial" document, that cannot be generated by any tool (which
> was the original subject of this thread, right?).

The iptables extensions HOWTO gets quite far on this, but is plauged 
somewhat by the same issues as discussed.

Regards
Henrik
