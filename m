From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: more questions about kernel config options for iptables
Date: Tue, 8 Apr 2003 09:04:35 -0400 (EDT)
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304080901350.10671-100000@dell>
References: <1049806772.11714.187.camel@elendil.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: iptables mailing list <netfilter@lists.netfilter.org>,
    Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
In-Reply-To: <1049806772.11714.187.camel@elendil.intranet.cartel-securite.net>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On 8 Apr 2003, Cedric Blancher wrote:

> Le mar 08/04/2003 =E0 14:23, Robert P. J. Day a =E9crit :
> > it would make far more sense to have a list of menu options
> > that reflects what a user would want to *do*, and have the
> > underlying dependencies kept invisible.  a more readable menu
> > like:
> > =

> >    Basic filtering
> >      Connection tracking
> >    NAT
> >    Packet mangling
> =

> This does not reflect reality. Connection tracking does not depend on
> basic filtering. It's even completly independent form it. It does not
> depend on NAT either.

sorry, i didn't mean it that way -- just suggesting that, if one
selects to do basic filtering, a sub-option of "connection tracking"
means that they want to do *additional* filtering.  but there would
still have to be a top-level connection tracking option.  this just
gets messy with these interdependencies.  yuck.
 =

> > gotcha.  if you want masq/NAT, you would have to select
> > not only Connection tracking, but IPtables support and,
> > within that, "Full NAT".  and that's why i dislike the current
> > menu layout.  it would be more reasonable for someone to say,
> > "i want NAT", and have the underlying dependencies automatically
> > satisfied.
> =

> I see your point. But I do think connection tracking has to appear as a=

> independent choice.

i agree.  see above.  i'll give all of this more thought, and peruse
the actual code more carefully to see how all of this ties together.

rday
