From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [patch] conntrack tool: Fix loading of protocol helpers
Date: Mon, 26 Mar 2007 16:46:41 +0200
Message-ID: <200703261646.41321.thomas.jarosch@intra2net.com>
References: <200703161751.08498.thomas.jarosch@intra2net.com>
	<20070316201552.ugc8wof8g5twc0c0@intranator.m.i2n>
	<45FE629D.5040701@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FE629D.5040701@netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello Pablo,

On Monday, 19. March 2007, Pablo Neira Ayuso wrote:
> >> Have a look at the script called test.sh under SVN, you can find one
> >> there.
> >
> > Thanks, that's exactly what I've searched for. I didn't notice it
> > because it's called "test.sh". What about the attached patch for the
> > manual page? ;-)
>
> I'd prefer some examples directly hardcoded to the manpage since test.sh
> is not distributed inside a release package, so this could get people
> confused. So, would you resend me a patch with some examples? Thanks!

What about renaming test.sh to example.sh and include it
in the normal distribution?

Cheers,
Thomas
