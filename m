From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH] support --physdev-out for routed packets
Date: Fri, 13 Jul 2007 13:14:18 +1000
Message-ID: <4696EE0A.9000103@snapgear.com>
References: <4695CCF8.1010202@snapgear.com> <4696225E.3000606@trash.net>
	<4696CE1B.1090600@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4696CE1B.1090600@snapgear.com>
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

Philip Craig wrote:
> Patrick McHardy wrote:
>> Its probably also racy wrt. fdb changes.
> 
> Yes.  It could modify the bridging code to only forward to the
> physoutdev stored in nf_bridge, or store the fdb result in
> nf_bridge and avoid the second fdb lookup.

I remember now why I didn't do this already.
The solution is to store the result in the mark, and use that in
ebtables to ensure it still goes out that port.  This needs to be
done anyway when defining the zone in terms of IP addresses.
