From: Philip Craig <philipc@snapgear.com>
Subject: Re: Netfilter+IPsec patches
Date: Wed, 18 Aug 2004 14:31:31 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4122DBA3.7080900@snapgear.com>
References: <20040526033537.GH4402@samad.com.au> <40B53CCE.40704@trash.net> <20040527044613.GC24464@samad.com.au> <20040818024025.GC21419@ns.snowman.net> <4122CCF8.2060203@snapgear.com> <20040818034549.GE21419@ns.snowman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20040818034549.GE21419@ns.snowman.net>
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
> This is DNAT'ing, btw, I wasn't specific about that before, sorry.
> un-NAT'ing should happen pre-routing, I think...  Like this:
> Packet shows up on eth1 from 1.1.1.1 -> 1.2.3.4
> Gateway NAT's from 1.2.3.4 -> 10.1.2.3 (interal address)
> Gateway does routing on NAT'd packet, finds eth2
> Gateway sends packet out eth2 to the 10.1.2.3 machine
> 10.1.2.3 machine sends reply from 10.1.2.3 to 1.1.1.1
> Gateway unNAT's from 10.1.2.3 -> 1.2.3.4
> Gateway does routing on unNAT'd packet, should find eth1
> Gateway sends packet out eth1 to the 1.1.1.1 machine

I don't know what the ipsec patches change, but for unpatched kernels,
this is how it works:  If you DNAT in one direction, there is an
automatic SNAT in the other direction (or unNAT as you call it)
which is performed in the POST_ROUTING hook.  So for your example,
the routing is based on a packet with source 10.1.2.3.

-- 
Philip Craig - SnapGear, A CyberGuard Company - http://www.SnapGear.com
