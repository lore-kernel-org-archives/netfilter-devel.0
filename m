From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Mon, 27 Jun 2005 13:46:46 +0200
Message-ID: <42BFE726.20305@trash.net>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
	<1119249575.3387.3.camel@localhost.localdomain>
	<42B6B373.20507@trash.net>
	<1119293193.3381.9.camel@localhost.localdomain>
	<42B74FC5.3070404@trash.net>
	<1119338382.3390.24.camel@localhost.localdomain>
	<42B82F35.3040909@trash.net>
	<20050622214920.GA13519@gondor.apana.org.au>
	<1119507800.3387.18.camel@localhost.localdomain>
	<20050627083219.GZ19928@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@telenet.be>,
	Bart De Schuymer <bdschuym@pandora.be>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, rankincj@yahoo.com,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050627083219.GZ19928@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> I have to agree with Bart.  I don't know any bridging-packetfilter setup
> that doesn't use ipt_physdev in FORWARD :(

It shouldn't be a problem to MARK in ebtables and use the marks instead.
So far I think we can only remove the support for locally generated
packets, but the way bridge-netfilter and ip-netfilter interact causes
some more problems and inconsistencies which I would like to look into
first. One thing I've noticed is that NF_IP_LOCAL_OUT, NF_IP_FORWARD and
NF_IP_POST_ROUTING get called for every clone when packets are delivered
to multiple ports, which causes unexpected results with REJECT (many
packets sent in response to a single one) and probably others. This
could be avoided by only passing packets to the NF_IP_* hooks once, but
that would make the physdev match useless.

Another problem is defragmentation, we've added the user argument to
ip_defrag to avoid packets from jumping through the stack between
different callers. With bridge-netfilter defragmentation in
NF_IP_PRE_ROUTING can be reached from both the IP layer and the bridge
layer, so packets can still jump (see netfilter bugzilla #339).

I expect there are more problems, I hope I can find some time to look
into it this week.

Regards
Patrick
