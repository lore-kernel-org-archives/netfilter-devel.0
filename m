From: Milos Wimmer <wimmer@zcu.cz>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Thu, 21 Apr 2005 14:31:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0504211416020.11020@nike.zcu.cz>
References: <4250FA72.3020502@trash.net> <20050404204716.GA4067@linuxace.com>
	<20050406044806.GA9711@linuxace.com> <4263108E.1030707@trash.net>
	<20050419005847.GA591@linuxace.com> <42666F4C.5080706@trash.net>
	<20050420155308.GA7057@linuxace.com> <42667E51.3060005@trash.net>
	<20050420172406.GB7057@linuxace.com> <42669674.3020905@trash.net>
	<20050420182505.GA7612@linuxace.com> <4267042A.2090906@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4267042A.2090906@trash.net>
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

On Thu, 21 Apr 2005, Patrick McHardy wrote:

> Well, I also can't submit a patch that doesn't fix the problem properly
> to -stable. This patch moves helpers to a new hook two priorities below
> ip_conntrack_confirm() and sequence number adjustment to a new hook at
> the next priority, thereby restoreing the old order. Can someone
> affected by the problem please confirm that this patch fixes it?

  I applied your patch to vanilla kernel 2.6.11.7 and it works great.

Regards,
               Milos
