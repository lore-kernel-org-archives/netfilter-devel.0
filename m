From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: more questions about kernel config options for iptables
Date: Tue, 8 Apr 2003 09:54:35 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304080951320.10915-100000@dell>
References: <1049806772.11714.187.camel@elendil.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: iptables mailing list <netfilter@lists.netfilter.org>,
    Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
In-Reply-To: <1049806772.11714.187.camel@elendil.intranet.cartel-securite.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 8 Apr 2003, Cedric Blancher wrote:

> My 0.02=A4 about this is that I personaly prefer a configuration script=

> that reflect reality, than something more "user convenient" that could
> fool people about the way things work. Netfilter insides, as well as
> kernel insides, are already complicated enough to me, for I do not need=

> stuff that could make me misunderstand something. Reality is that NAT
> depends on conntrack. Your point would be to invert this for user's
> sake, and this is, imho, a baaaaad thing ;)
> =

> I don't know if any of them are reading this thread, but if we could
> have some core developper's point of vue about his, would be great.
> =

> It is a very tough subject to discuss how kernel configuration must be
> presented. I wouldn't show nerd's behaviours, e.g. dumb users do not
> compile kernel, but I tend to think that if someone wants to build its
> own kernel, then it's up to him to (try to ?) understand how it is goin=
g
> and what are the choices he's about to make.

yes, i agree with this.  i think i'll just ponder how to reorganize
that menu to, first of all, have more informative help screens and,
second, to add what i *think* we agree on is some missing
dependencies.  =


rday

p.s.  is the rest of this list also getting auto-vacation messages
from respond-dgour?  just wondering if it's coming from *this*
list.
