From: Krzysztof Oledzki <ole+n@ans.pl>
Subject: Re: REJECT using invalid data
Date: Wed, 8 Dec 2004 01:33:27 +0100 (CET)
Message-ID: <Pine.LNX.4.53.0412080130560.3300@bizon.gios.gov.pl>
References: <Pine.LNX.4.53.0412072347080.2736@bizon.gios.gov.pl>
	<41B642A1.9030807@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41B642A1.9030807@eurodev.net>
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



On Wed, 8 Dec 2004, Pablo Neira wrote:

> Krzysztof Oledzki wrote:
>
> >I'm not sure if changing "-j REJECT" to drop invalid tcp packets is good
> >idea since we have -m unclean and we can drop such packets explicitly
> >with this match.
> >
>
> unclean was removed from 2.6 series

Oh? I did not know about that... After some googling I have just found
http://lists.netfilter.org/pipermail/netfilter-devel/2003-August/012199.htm=
l
So, how it is now possible to DROP invalid packets? I think that it should
be at least a match which can be used to drop broken or malformed packets
such as ones used to expoloit buggy IP stack on old win95 hosts.

> > And what about other protocols (udp, etc) when REJECT
> >generates ICMP port-unreachable?
> >
> you are right, udp stuff is missing, checkings here are trivial to add
> anyway. I'll think about this issue more carefully in next days.
OK.

Best regards,

=09=09=09=09Krzysztof Ol=EAdzki
