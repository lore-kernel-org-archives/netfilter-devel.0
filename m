From: Philip Craig <philipc@snapgear.com>
Subject: Re: iptables.c changes submitted argv value
Date: Fri, 13 Aug 2004 10:05:01 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411C05AD.6030408@snapgear.com>
References: <IDEAKKJENKGNPNLKJKODOEAECAAA.listuser@epygi.de> <Pine.LNX.4.61.0408121254480.20263@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sascha <listuser@epygi.de>
In-Reply-To: <Pine.LNX.4.61.0408121254480.20263@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Thu, 12 Aug 2004, Sascha wrote:
>>That's not the point. I'm developing on an embedded device and i have no 
>>space for iptables-store.c, iptables-restore.c and iptables.c.
> 
> 
> All you need is iptables-restore. It has all functions of iptables plus 
> more and is very well suited for batch or daemon operations. What 
> iptables-restore is is a efficient batch interface using the same syntax 
> as iptables (well, it is even the same code so..)

You probably want to have iptables still for debugging/diagnostics.
If so, get the latest version of iptables from CVS and enable DO_MULTI.
This combines all three programs into the one binary.

-- 
Philip Craig - SnapGear, A CyberGuard Company - http://www.SnapGear.com
