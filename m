From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Tue, 21 Sep 2004 15:36:00 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040921153600.2e732ea6.davem@davemloft.net>
References: <1095721742.5886.128.camel@bach>
	<20040921143613.2dc78e2f.Ballarin.Marc@gmx.de>
	<1095803902.1942.211.camel@bach>
	<20040922003646.3a84f4c5.Ballarin.Marc@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: torvalds@osdl.org, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marc Ballarin <Ballarin.Marc@gmx.de>
In-Reply-To: <20040922003646.3a84f4c5.Ballarin.Marc@gmx.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 22 Sep 2004 00:36:46 +0200
Marc Ballarin <Ballarin.Marc@gmx.de> wrote:

> I just added some warnings, but modprobe ipchains always fails on
> 2.6.9-rc2:
> 
> FATAL: Error inserting ipchains
> (/lib/modules/2.6.9-rc2-rcf/kernel/net/ipv4/netfilter/ipchains.ko): Device
> or resource busy

You can't have ipchains and iptables loaded at the same time.
You must first manually unload iptables, then you can
successfully load the ipchains module.
