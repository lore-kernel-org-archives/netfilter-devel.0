From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables 32bit compat layer
Date: Wed, 29 Mar 2006 14:47:23 +0200
Message-ID: <442A81DB.7060608@trash.net>
References: <200602201110.39092.dim@openvz.org>
	<200603291536.17794.dim@openvz.org> <442A7E72.2080405@trash.net>
	<200603291638.02842.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Arnd Bergmann <arnd@arndb.de>,
	rusty@rustcorp.com.au, Martin Josefsson <gandalf@wlug.westbo.se>,
	"David S. Miller" <davem@davemloft.net>, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200603291638.02842.dim@openvz.org>
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

Dmitry Mishin wrote:
> On Wednesday 29 March 2006 16:32, Patrick McHardy wrote:
>>
>>I know, but SOL_IPV6 implies IP6T_* - but please don't bother sending
>>a new patch for this :) So the point of the change is to exclude IPv6
>>from the compat layer because its not implemented yet?
> 
> Exactly. Because do_netfilter_replace still works for some cases, but newer 
> replacement isn't ready yet.

Ah OK. One last thing before I'll pass it on. There was one 64 bit
architecture where iptables already worked with 32 bit userspace for
some reason. I would like to make sure that it still works before it
goes in because I can't debug it if it fails afterwards. I don't
recall which arch it was, but I think Martin had one of these machines.
Martin, could you give the compat patch a try?
