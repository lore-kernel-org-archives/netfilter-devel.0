From: Herve Eychenne <rv@wallfire.org>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Tue, 20 Jan 2004 02:13:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040120011305.GD1142@eychenne.org>
References: <20040119231501.GB1142@eychenne.org> <Pine.LNX.4.44.0401200023120.17422-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@netfilter.org>,
	Julian Anastasov <ja@ssi.bg>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401200023120.17422-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 20, 2004 at 12:48:29AM +0100, Henrik Nordstrom wrote:

> On Tue, 20 Jan 2004, Herve Eychenne wrote:

> > 3) However, I think it would be a bad idea to have the iptables manpage
> >   depend on what is currently installed at the time of its generation:
> >   this would introduce incompatibilities between manpages over
> >   different hosts, and people are not used to that (at least for
> >   manpages).

> To this I do not agree, or at least not fully. This way the man page 
> documents what this specific version of the iptables user program 
> supports.

The problem is not only about user program, but user/kernel
combination.

> This may or may not be the same as the current running kernel.

Yes, and that's what it would be good to take such (kernel, here) changes
into account.

> It is impossible for the man page to correctly reflect all possible 
> combinations.

Yes, as it is always some kind of "static".
You'll note that the reason why I prefer a program to a "static" (even
if generated at iptables compile time) manpage is that the manpage will
not reflect your current combination (at least durably), again.

> If a certain feature is not supported by the current running kernel then 
> this is found out pretty quickly.

Usually, in such a case, most users get an obscur error and write to the
mailing-list. Pretty clear and quick, isn't it? ;-)

> Unfortunately the error is not the most 
> forgiving and this can be considered a major bug in the iptables command.

Indeed... and I think it will be hard to change that for iptables...
So a documentation effort seems much more affordable to me...

> After some thinking I think what should be done is actually to do what we
> have done in the Squid project, always include the documentation for
> everything

Please note that I do not suggest this shouldn't be done. If we write
the program I'm talking about, it will be perfectly feasible (and
it should be done) to generate a document (manpage, or other)
documented every existing module.

> but if the feature is not currently enabled in the build
> automatically add a comment explaining this. My personal preference for 
> this type of reference information is man pages, and I do not doubt many 
> shares this view.

That doesn't prevent from providing a program which generates a
manpage dynamically (if you really want it in a manpage format)...

> With the loose coupling between p-o-m and the iptables userspace I do not 
> see it feasible to document in the userspace documentation
> which matches/targets are from p-o-m or not,

If you have a static document, clearly not. But that's not what I'm
talking about.

> but on the other hand if all
> documentation is always included but with comments then most people will 
> learn quickly what is mainstream and what is not,

Yes. That state is not always that clear. For example, a feature could belong to
p-o-m for a certain kernel version, and mainstream for kernel version + 1.
But! You (netfilter developer) perfectly know what this is all about.
Everyone is not that informed. I personnaly know some people who are
quite confused by these incertitudes.
People in real life (read "not developer life") often upgrade their
kernel and iptables command via packages, and if they get to know the
existence of p-o-m, they have only little time to keep tracking down if
their favorite p-o-m modules have been included into mainstream or removed
(from kernel, or cvs).

> and if in doubt a quick 
> look into the man page on your system will tell what you have.

I do not understand. A manpage with every extensions will only tell
you what you could have, and you would have to experiment quite much
(with uninformative error messages) to know what you can really _use_.
And this is all to be done again when you upgrade the kernel...
Sigh...
Besides, this situation is a nightmare for automatic programs (upper
layers) which try to take advantage of a maximum of extensions.

> Ideally this would be derived automatically from the C source of the
> extension to avoid having to maintain so many files but that is a
> substantially larger reorganisation than the split manpage.

Why not... as long as the information is stored somewhere...

> This is not really the same kind of information you want to put into the
> kernel help,

No, this is not, but information about kernel configuration is not
exactly of the same nature.

> or in the command help output, and it is not exacly howto 
> material either.

You are right, but I didn't recommend using a single description for
all these things, which may be different. It was only about
factorizing as much as we can (if we can).

> For the userspace documentation to be complete there has to in my 
> opinion be

> * Reference documentation, explaining the function of each option. (man
> page). Not having not yet submitted extensions in the reference
> documentation is a major loss in the quality of the reference information
> in my opinion,

The discussion was not about that, am I wrong? I think everyone agrees
that p-o-m extensions should be documented somewhere, where it would
be easily accessible, which is not the case for the moment.
The discussion was about how documenting everything in the clearest,
the most complete and accurate (according to what you really have at
runtime) way.

> and also discourages the information from being maintained
> making things even worse.

I want exactly the same thing: factorize, and generate things
dynamically to reduce maintainance as much as possible...

> * Terse usage information for --help, acting no more than a reminder on 
> the syntax.

Isn't it what we have currently? These messages seem perfect to me as
they are today. But we can discuss what is the best way to
store/generate it to minimize redundancy (and so maintainance),
although that's not a priority for me, as we could always factorize
what we can afterwards.

> * A howto explaining/discussing in more depth why/when/how certain matches
> should be used, what p-o-m is, and how to use things from p-o-m. (the
> extensions howto). This does not need to include the reference material
> and can refer to the reference documentation for further details.

Yes. Such a document doesn't really exist yet, although it would be
very useful. But it's orthogonal to the discussion, as it is an
"editorial" document, that cannot be generated by any tool (which
was the original subject of this thread, right?).

Maybe I should read your email one more time, but I don't see how it
contradicts my points, even if we seem to reach a completely opposite
conclusion considering manpage generation. ;-)

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
