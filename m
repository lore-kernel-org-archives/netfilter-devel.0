From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Mon, 8 Nov 2004 02:06:11 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411080204240.8012@filer.marasystems.com>
References: <20041107181825.GA3522@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041107181825.GA3522@linuxace.com>
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

On Sun, 7 Nov 2004, Phil Oester wrote:

> To achieve this, two changes were required to core networking code (thus
> the linux-net cc):
>
> 1) export inet_confirm_addr
>
> 2) change inet_ifa_match to use ifa_local instead of ifa_address.
>   Since ifa_local != ifa_address on ppp interfaces, inet_ifa_match
>   could not be used to verify ppp interface addresses without
>   this change.
>
> Comments?

Looks fine to me, but maybe we should also utilize the fact that 
nat.masq_index with this change only needs to be a boolean flag "this 
connection is masqueraded", allowing us to cut down a little on the 
conntrack entry size.

Regards
Henrik
