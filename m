From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE device handling - revert optimization
Date: Mon, 15 Nov 2004 21:58:02 +0100
Message-ID: <4199185A.7000404@trash.net>
References: <20041112200126.GA30173@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041112200126.GA30173@linuxace.com>
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

Phil Oester wrote:

> <>Since it looks like no other solution will be accepted, the only way to
> fix masquerade is to revert the 'mostly static' optimization which
> went in last year. The patch below does so.
>
> This fixes bugzilla #227.

Patch applied, thanks Phil. Can you send a patch for 2.4 as well ?

Regards
Patrick
