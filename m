From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/20]: Netfilter Update part II
Date: Sat, 02 Dec 2006 22:16:51 -0800 (PST)
Message-ID: <20061202.221651.74747690.davem@davemloft.net>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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
Date: Sat,  2 Dec 2006 15:49:36 +0100 (MET)

> following is part two of my netfilter update for 2.6.20, containing
> NAT support for nf_conntrack and ports of all conntrack/NAT helpers.
> With these patches nf_conntrack is finally a full replacement for
> ip_conntrack, which is now scheduled for removal in 2.6.22 after some
> stabilization of the new code.

I've rebased my tree and applied all 20 patches, thanks a lot!

Also, since I wanted to try to push this work to Linus tonight
I applied Yasuyuki-san's header include fix as well.

Thanks again.  I'm very happy this work got completed in time
for 2.6.20
