From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere
 else (was Re: Fw: Rusty's brain broke!)
Date: Tue, 20 Jan 2004 00:48:29 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401200023120.17422-100000@filer.marasystems.com>
References: <20040119231501.GB1142@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, Julian Anastasov <ja@ssi.bg>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20040119231501.GB1142@eychenne.org>
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

> 3) However, I think it would be a bad idea to have the iptables manpage
>   depend on what is currently installed at the time of its generation:
>   this would introduce incompatibilities between manpages over
>   different hosts, and people are not used to that (at least for
>   manpages).

To this I do not agree, or at least not fully. This way the man page 
documents what this specific version of the iptables user program 
supports. This may or may not be the same as the current running kernel.

It is impossible for the man page to correctly reflect all possible 
combinations.

If a certain feature is not supported by the current running kernel then 
this is found out pretty quickly. Unfortunately the error is not the most 
forgiving and this can be considered a major bug in the iptables command.

After some thinking I think what should be done is actually to do what we
have done in the Squid project, always include the documentation for
everything but if the feature is not currently enabled in the build
automatically add a comment explaining this. My personal preference for 
this type of reference information is man pages, and I do not doubt many 
shares this view.

With the loose coupling between p-o-m and the iptables userspace I do not 
see it feasible to document in the userspace documentation which 
matches/targets are from p-o-m or not, but on the other hand if all 
documentation is always included but with comments then most people will 
learn quickly what is mainstream and what is not, and if in doubt a quick 
look into the man page on your system will tell what you have.

I see a big merit in the iptables man page actually documenting the 
extensions available. And if done correcly this can be almost self 
maintaining.

Ideally this would be derived automatically from the C source of the
extension to avoid having to maintain so many files but that is a
substantially larger reorganisation than the split manpage.

This is not really the same kind of information you want to put into the
kernel help, or in the command help output, and it is not exacly howto 
material either.

For the userspace documentation to be complete there has to in my 
opinion be

* Reference documentation, explaining the function of each option. (man
page). Not having not yet submitted extensions in the reference
documentation is a major loss in the quality of the reference information
in my opinion, and also discourages the information from being maintained
making things even worse.

* Terse usage information for --help, acting no more than a reminder on 
the syntax.

* A howto explaining/discussing in more depth why/when/how certain matches
should be used, what p-o-m is, and how to use things from p-o-m. (the
extensions howto). This does not need to include the reference material
and can refer to the reference documentation for further details.

Regards
Henrik
