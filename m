From: Philip Craig <philipc@snapgear.com>
Subject: Re: another PPTP conntrack problem (no fix this time)
Date: Wed, 05 Feb 2003 18:23:59 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E40CA1F.1080205@snapgear.com>
References: <4.2.0.58.20030129161653.01aab6e8@avocetgw> <4.2.0.58.20030131122321.01a7a8b8@avocetgw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Mielke <paulm@routefree.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Paul Mielke wrote:
> Does this seem to make sense?  Please let me know if you think I am
> mistaken in my analysis and that the previous ICMP patches would help.

You've convinced me that there is a problem here.  I think
that gre_pkt_to_tuple() needs to handle the case when
gre_keymap_lookup() fails by trying to do an inverse
lookup.  I haven't tried fixing this yet.

I suspect that you will still need the other ICMP patches
as well once you have the gre lookup succeeding though.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances
