From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/02]: Netfilter fixes
Date: Fri, 02 Feb 2007 19:34:09 -0800 (PST)
Message-ID: <20070202.193409.90150692.davem@davemloft.net>
References: <20070203014620.892.62689.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070203014620.892.62689.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Sat,  3 Feb 2007 02:46:22 +0100 (MET)

> Hi Dave,
> 
> following are two more netfilter fixes for 2.6.20, fixing H.323 compilation with
> IPV6=m and NF_CONNTRACK_H323=y (Adrian's patch) and another compile failure with
> NF_CONNTRACK_MARK=n (same for IP_NF_CONNTRACK_MARK=n).
> 
> Please apply, thanks.

Applied, thanks Patrick.
