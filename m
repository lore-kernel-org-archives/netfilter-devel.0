From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libipt_statistic
Date: Mon, 02 Jul 2007 15:11:21 +0200
Message-ID: <4688F979.60606@trash.net>
References: <dd45289d0707011710v189ac25j174458fecb0bfb41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <dd45289d0707011710v189ac25j174458fecb0bfb41@mail.gmail.com>
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

NICOLAS BOULIANE wrote:
> Hi Patrick,
> 
> I think that this calculation is erroneous:
> info->u.nth.count = info->u.nth.every - info->u.nth.packet;
> 
> ex: --mode nth --every 4 --packet 6
> AIUI, we want to drop the 4th packet after 6 packets have pass.
> Base on this example, we want to match the 10th packet.
> 
> But we are gonna match the 7th packet, wich is wrong.
>   count: -3
>   every: 3
>   packet: 6
> 
> -3,  -2, -1,  0,  1,  2,  (3) -- Increment
>  1,   2,   3,  4,  5,  6,   7  -- nth packet
> 
> comments are welcome.


--packet is the initial counter value and must be >= 0 and <= every - 1.

In your example, which packet do you want to drop on the second round?
The fourth or the tenth?
