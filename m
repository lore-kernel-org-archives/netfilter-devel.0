From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
 breaks amanda dumps
Date: Fri, 05 Nov 2004 01:40:39 +0100
Message-ID: <418ACC07.4090104@trash.net>
References: <20041104121522.GA16547@merlin.emma.line.org>	<418A7B0B.7040803@trash.net>	<20041104231734.GA30029@merlin.emma.line.org>	<418AC0F2.7020508@trash.net>
	<20041104160655.1c66b7ef.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20041104160655.1c66b7ef.davem@davemloft.net>
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

David S. Miller wrote:

>On Fri, 05 Nov 2004 00:53:22 +0100
>Patrick McHardy <kaber@trash.net> wrote:
>
>  
>
>>Your observation and your patch were correct, thanks. It is supposed
>>to be just a copy, I missed that it wasn't anymore. While your patch
>>works too, and is even faster with non-linear skbs, I don't like the
>>idea of using the skb as a scratch-area, so I sent this patch to Dave
>>instead.
>>    
>>
>
>His patch isn't correct, even making a temporary change to
>a shared SKB is illegal.  Things like tcpdump could see
>corrupt SKB contents if they look during that tiny window
>when the newline character has been changed to NULL by
>the amanda conntrack module.
>  
>

True, I'm stupid sometimes :)

Regards
Patrick
