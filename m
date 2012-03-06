From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 5/6] bridge: netfilter: don't call iptables on vlan
 packets if sysctl is off
Date: Tue, 06 Mar 2012 15:15:41 -0500 (EST)
Message-ID: <20120306.151541.842243311598350897.davem@davemloft.net>
References: <1331032975-5303-1-git-send-email-pablo@netfilter.org>
	<1331032975-5303-6-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1331032975-5303-6-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: pablo@netfilter.org
Date: Tue,  6 Mar 2012 12:22:54 +0100

> From: Florian Westphal <fw@strlen.de>
> 
> When net.bridge.bridge-nf-filter-vlan-tagged is 0 (default), vlan packets
> arriving should not be sent to ip(6)tables by bridge netfilter.
 ...
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied.
