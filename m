From: "junk" <junk@toutatis.be>
Subject: can't unregister_netdevice
Date: Thu, 24 Feb 2005 11:03:59 +0100
Message-ID: <20050224100359.M40666@toutatis.be>
Reply-To: junk <junk@toutatis.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

I'm coding a module which sends packets to eth0, it actually sends packets but
when i halt/reboot my linux, it hang over saying it can't unregister_netdevice
eth0 because usage count is = X

What did I forget in my code?

I use dev_queue_xmit to transmit my packet to eth0
I finally kfree_skb my skb
I did unregister my netfilter hooks

Any ideas?
