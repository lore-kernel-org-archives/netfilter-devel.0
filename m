From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Wed, 14 Jul 2004 03:22:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40F48AE6.9090302@trash.net>
References: <20040415212034.GE7611@obs.bg> <20040713023700.GM21419@ns.snowman.net> <40F34EF2.2010405@trash.net> <20040713115306.GN21419@ns.snowman.net> <40F4062B.9060308@trash.net> <20040713161021.GO21419@ns.snowman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20040713161021.GO21419@ns.snowman.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Stephen Frost wrote:
> Okay, thanks.  For --reqid...  Do you think that's sufficient to base
> firewall rules off of?  Can it be somehow 'faked' by the
> remote/potentially untrusted side?  That's my main issue.  If it can't
> and will only match if the ipsec packet is valid and coming from that
> network then I don't need to care about --spid and will just use
> --reqid...

It can't be faked, it will always match the reqid of the used SA.
But policy checks happen after the PRE_ROUTING/LOCAL_IN/FORWARD
hooks, so you can't be sure that a packet matching a reqid really
has a source/destination address that is configured in the policy.
Invalid packets will be dropped by the network stack before socket
delivery/forwarding. But this can also happen with --spi matching.

Maybe we should add new policy checks to protect conntrack from these
packets. If they are invalid it shouldn't change state.

Regards
Patrick

> 
> 	Thanks,
> 
> 		Stephen
