From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] TCP window tracking over-window handling
Date: Wed, 2 Feb 2005 14:35:38 -0800
Message-ID: <20050202223538.GA32531@linuxace.com>
References: <20050128234334.GA20713@linuxace.com>
	<Pine.LNX.4.58.0502021017590.24272@blackhole.kfki.hu>
	<20050202160009.GB30465@linuxace.com>
	<Pine.LNX.4.58.0502022139470.25538@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0502022139470.25538@blackhole.kfki.hu>
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

On Wed, Feb 02, 2005 at 09:44:51PM +0100, Jozsef Kadlecsik wrote:
> That it can't be due to some window scaling/SACK handling bug, at least.

I don't think so either, but you can correct me if I'm wrong given the below
handshake:

x.x.x.14.32782 > x.x.x.7.21: S 855161881:855161881(0) win 5840 <mss 1460,sackOK,timestamp 430761638 0,nop,wscale 2>
x.x.x.7.21 > x.x.x.14.32782: S 3715392258:3715392258(0) ack 855161882 win 8280 <mss 1380>
x.x.x.14.32782 > x.x.x.7.21: . ack 1 win 5840

> I'm digging my mail folders to find the reports which triggered adding
> that code segment.

Great, thanks.

Phil
