From: Patrick McHardy <kaber@trash.net>
Subject: Re: [1/1] OSF: pom-ng - linux-2.6.
Date: Mon, 03 Jan 2005 00:31:20 +0100
Message-ID: <41D88448.6080701@trash.net>
References: <1102503533.3363.48.camel@uganda>	<1102503753.3363.50.camel@uganda>	<41B74C8C.20607@trash.net>
	<20041212181351.22570bf6@zanzibar.2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20041212181351.22570bf6@zanzibar.2ka.mipt.ru>
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

Evgeniy Polyakov wrote:

>On Wed, 08 Dec 2004 19:48:44 +0100
>Patrick McHardy <kaber@trash.net> wrote:
>
>>Anyhow, it still needs to handle non-linear skbs. Have a look
>>at the other matches and their use of skb_header_pointer.
>>
>
>Sure.
>Patch attached, although I do not quite understand what should be 
>done with a poor skb to move IP and TCP headers into the fragments...
>
Applied, sorry for the delay. Copying the ip-header is not necessary,
but the TCP header may be nonlinear because of defragmentation.

>P.P.S. I do not have 2.4 sources but if 2.4 has skb_header_pointer
>(as long as it has skb_copy_bits()) patch can be applied against it
>as well, but path in diff should be changed. If needed it is attached
>as well.
>
2.4 doesn't need this change, netfilter always gets linearized skbs.

Regards
Patrick
