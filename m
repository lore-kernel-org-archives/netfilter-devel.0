From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Mon, 08 Nov 2004 17:24:52 +0100
Message-ID: <418F9DD4.20202@trash.net>
References: <20041107181825.GA3522@linuxace.com> <418F9952.5030004@trash.net> <20041108161511.GA6754@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org
Return-path: <linux-net-owner@vger.kernel.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041108161511.GA6754@linuxace.com>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>On Mon, Nov 08, 2004 at 05:05:38PM +0100, Patrick McHardy wrote:
>
>>But without the ifindex comparison, a situation like this can happen:
>>
>>ppp0 goes down
>>ppp1 goes down
>>ppp0 comes up again, same IP as before
>>ppp1 connections get killed
>>ppp1 comes up again
>>
>>So we should keep this.
>>
>
>But ifindex is meaningless on ppp interfaces - it is incremented on each
>cycle.  So there is no way to say that the original ppp1 is the same
>interface as the new ppp1.
>
>ifindex just cannot be used reliably.
>
Of course, I wasn't thinking :) Then what about Henrik's suggestion,
replacing masq_index by a new status bit ?

Regards
Patrick

