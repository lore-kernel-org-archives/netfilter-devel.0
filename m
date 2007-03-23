From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFNL_NFA_NEST
Date: Fri, 23 Mar 2007 13:55:15 +0100
Message-ID: <4603CE33.9060806@netfilter.org>
References: <4600BDBB.8020205@trash.net>
	<4601B796.5030100@netfilter.org>	<460261EB.4000402@trash.net>
	<46028242.4090609@netfilter.org>	<460284D4.30709@trash.net>
	<4602B25B.10909@netfilter.org>	<4602B667.2030304@trash.net>
	<4603C5AC.1070808@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4603C5AC.1070808@netfilter.org>
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

Pablo Neira Ayuso wrote:
> I implemented a simple conversion function yesterday, so we can get rid 
> of it for this library release. Anyhow, I'm still concerned about one 
> scenario, since netlink over network messages could be sent between two 
> systems A and B with different endianess and different library versions, 
> consider that A sent a message that contains one attribute that B 
> doesn't know. Thus, the message will not be completely converted by the 
> structure aware proxy function in B. Then, the message will probably be 
> passed to B's netlink subsystem that will complain about a malformed 
> attribute, returning EINVAL. For the conntrackd example, both replicas 
> should have the same configuration, so this shouldn't be a problem for 
> me, but perhaps other future applications could have problems. Another 
> point is that we'll have to cook a structure aware conversion function 
> for every netlink messages sent on the wire.

Perhaps the example above probably looks pretty strange. Still, think of 
old libraries and new kernels with one new nested attribute, the 
conversion function will miss the conversion for it. This bit thing gets 
me stressed me a bit :)

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
