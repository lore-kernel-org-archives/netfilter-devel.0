From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Mon, 20 Jun 2005 14:15:47 +0200
Message-ID: <42B6B373.20507@trash.net>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>	
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
	<1119249575.3387.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: bdschuym@pandora.be, Herbert Xu <herbert@gondor.apana.org.au>,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, rankincj@yahoo.com,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@telenet.be>
In-Reply-To: <1119249575.3387.3.camel@localhost.localdomain>
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

Bart De Schuymer wrote:
> Op ma, 20-06-2005 te 04:45 +0200, schreef Patrick McHardy:
> 
>> Bart, can you explain why the hooks are defered please?
> 
> This is done so that iptables knows which bridge port the output device
> is, using the iptables physdev match.

In which cases is this necessary? AFAICT the output device is determined
in br_handle_frame_finish() for a normally bridged packet.

> Can't you release the conntrack reference with a function registered on
> the POSTROUTING hook with a prio higher than nat POSTROUTING (or
> something like that)?

We would have to hold the reference while the packet is queued at the
device for the bridge case, which we want to avoid.

Regards
Patrick
