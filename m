From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Strange MASQUERADING behaviour, bug or feature?
Date: Thu, 20 Apr 2006 17:00:49 +0900 (JST)
Message-ID: <200604200800.k3K80or0024221@toshiba.co.jp>
References: <44440CD2.6060006@rtij.nl> <444610DD.9000807@ufomechanic.net>
	<44466513.8080000@rtij.nl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, azez@ufomechanic.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: m@rtij.nl
In-Reply-To: <44466513.8080000@rtij.nl>
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

From: Martijn Lievaart <m@rtij.nl>
Date: Wed, 19 Apr 2006 18:28:03 +0200

> Amin Azez wrote:
> 
> > Martijn Lievaart wrote:
> >
> >> Hey, that is the wrong source address! Now when I kill the null0 
> >> interface, suddenly the source address changes to the correct 
> >> (169.254.1.1) address. Also when I stop the ping and restart it, the 
> >> source address is correct.
> >
> >
> > Thats how NAT works.
> >
> > The address mappings are setup when the conntrack is created.
> >
> > You observed that this is less obviously-right for generally stateless 
> > streams like ping, but it is certainly consistent and makes sense, and 
> > is neccessary for tcp or udp connections, or they would break 
> > everytime other routes went up or down.
> 
> 
> For SNAT, I can understand this. For MASQUERADE, this is probably also 
> the correct behaviour. However, why is this "ping stream" seen as one 
> contrack?

The echo requests/replies with same ID, same source - destination address
combination belongs same conntrack. The identity of conntrack is
unrelated with input/output interfaces.

Probably ping kept to use same source address for echo requests on your
test, and routing changed output interface according to routing table.

If source address before masquerading was changed, ip_conntrack would
create different conntrack and MASQUERADE target would use it.

That's why tcpdump saw changed source address after you restart ping,
I think.

-- Yasuyuki Kozakai
