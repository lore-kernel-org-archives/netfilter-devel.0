From: Philip Craig <philipc@snapgear.com>
Subject: Re: How to make conntrack ignore packets on certain interfaces?
Date: Fri, 25 Jun 2004 10:07:18 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40DB6CB6.3080307@snapgear.com>
References: <BAY22-F9OxHp2sdp2Mn0009ff98@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Colin Paton <cozzarp@hotmail.com>
In-Reply-To: <BAY22-F9OxHp2sdp2Mn0009ff98@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Colin Paton wrote:
> - Register a higher-priority netfilter hook which is called before 
> conntrack_in() - this somehow(?!) causes the packet to jump over netfilter. 
> I'm not sure if 'jumping' over netfilter hooks is possible however.
> - Tell the conntrack code (somehow) to ignore packet coming on eth1.6. While 
> it seems that iptables can read the connection tracking state I don't think 
> it can alter it.

The raw patch in pom-ng will let you do this.  It adds a raw table
that is higher priority then conntrack, and a NOTRACK target which
tells conntrack to ignore packets.

-- 
Philip Craig - SnapGear, A CyberGuard Company - http://www.SnapGear.com
