From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere
 else (was Re: Fw: Rusty's brain broke!)
Date: Wed, 21 Jan 2004 00:55:27 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401210033400.29594-100000@filer.marasystems.com>
References: <20040120232103.GB1143@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20040120232103.GB1143@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 21 Jan 2004, Herve Eychenne wrote:

> Why isn't this done already? ;-)

Because we are all programmers on this list and we never type wrongly?

More likely because we always think on how to solve the whole problem 
instead rather than solving the most obvious shortcomings. To solve the 
whole problem includes versioning and many other fancy features which is 
way beyond the scope of what can be done in 2.4/2.6 lifetime due to their 
freezed nature. To just solve the issue where a non-existing match/target 
is used requires far less.

> If you think of the current scheme, where you're forced to recompile
> userspace after having used patch-o-matic, not so much: filtering
> capabilities... (mainstream or not, match or target, specific version
> or all, currently available or not, etc.). 
> A way to know all that is available in every kind of context is needed
> anyway, independantly of the documentation, anyway.

To me the only two contexts really interesting is

a) What is supported on this system

b) What may be added if you need it.

all other contexts can be derived from there.

> > Not easily in a way which allows the manpage to be packaged I think.
> 
> Packaged in the sense of a distribution package?

Yes, which is what the majority of the users where one has to care about 
p-o-m/not p-o-m use.

Most users rolling their own binaries understand that both kernel and 
userspace may need upgradign when adding a previously unsupported item so 
I do not regard them as a problem in this discussion.

> If we really want a userspace-compile-time-built manpage, then yes,
> probably.

I defenitely vote that there should be a reference manpage covering the 
iptables extensions, in case there is any doubt on what my 
preference is ;-)

Being a long-timer UNIX guy I don't really like HOWTO style documents for
reference. But it is not what they are ment to be used for either. Man
pages does a excellent job for that purpose, and the iptables man page is
not bad at all it just lags behind a lot because extensions maintainers
don't care about the man page and this is what should be addressed first. 
Once documentation is structured in a way that allows it to be maintained 
in a sane manner it is easy to improve on the scheme if so is needed.

Today trying to make a scheme which solves the question on how the 
iptables/kernel should be kept in synch, documentation reflecting 100% 
correctly the status of different extensions etc is in my opinion trying 
to grasp for to much and not likely to succeed.

> Yes, but that should be different. There's unfortunately no easy way
> to have a good module management system (fast adding, no recompilation
> needed, no binary interface problems) for iptables. :-(  (pkttables
> will be the place to do that, as we discussed during the workshop)

With pkttables being rather far away at the moment and very far away for
mainstream, lets try to focus on how to solve the documentation question
for iptables. Any improvements done in iptables then sets the standards
the same documentation for pkttables should live up to when it's time.


Making close relation between p-o-m and the userspace is in my opinion a 
big mistake and creates a big nest of maintain issues. The scheme where 
the iptables userspace has to be built matching your kernel works 
reasonably well in my opinion.

If it was the case that we had all of iptables (kernel+user) in one single 
package with no real dependencies on the kernel version used then the 
situation would be different, but this is not how things work and 
everything moves in the opposite direction.

Regards
Henrik
