From: Simon Kirby <sim@netnation.com>
Subject: Re: REJECT using invalid data
Date: Tue, 7 Dec 2004 16:52:16 -0800
Message-ID: <20041208005216.GA7958@netnation.com>
References: <Pine.LNX.4.53.0412072347080.2736@bizon.gios.gov.pl>
	<41B642A1.9030807@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
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

On Wed, Dec 08, 2004 at 12:54:09AM +0100, Pablo Neira wrote:

> >And what about other protocols (udp, etc) when REJECT
> >generates ICMP port-unreachable?
> 
> you are right, udp stuff is missing, checkings here are trivial to add 
> anyway. I'll think about this issue more carefully in next days.

I don't think it's a good idea to try to filter all TCP flags in REJECT
unless we're trying to avoid rejecting rejects and we don't already do
that for some reason (eep), for the same reason that unclean was removed
(ECN and other new functionality could break).  I would think that all
that is needed is a check for the RST bit.

At the same time, it would be nice to have a match (or at least some
functionality) resulting in the ability to drop corrupted packets
("corrupted" as in with the checksum) that would otherwise be accepted. 

Hmm.  Maybe this should be done at a different level?  It should
basically not match "-p tcp" in the rule "iptables -p tcp -j REJECT". 
Doing it at "-p tcp" time would also correct "iptables -p tcp --dport 80
-j ACCEPT", which would otherwise also be affected by the same problem
(the TCP port could be corrupted).

Simon-
