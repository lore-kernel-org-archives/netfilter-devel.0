From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 1/7] net: refactor __netif_receive_skb_core
Date: Fri, 10 Apr 2015 15:47:34 +0200
Message-ID: <5527D476.6030306@iogearbox.net>
References: <1428668142-4006-1-git-send-email-pablo@netfilter.org> <1428668142-4006-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netdev@vger.kernel.org, davem@davemloft.net
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1428668142-4006-2-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 04/10/2015 02:15 PM, Pablo Neira Ayuso wrote:
> This patch splits __netif_receive_skb_core() in smaller functions to improve
> maintainability.
>
> The function __netif_receive_skb_core() has been split in two:
>
> * __netif_receive_skb_ingress(), to perform all actions up to
>    ingress filtering.
>
> * __netif_receive_skb_finish(), if the ingress filter accepts this
>    packet, pass it to the corresponding packet_type function handler for further
> processing.
>
> This patch also adds __NET_RX_ANOTHER_ROUND that is used when the packet is
> stripped off from the vlan header or in case the rx_handler needs it.
>
> This also prepares the introduction of the netfilter ingress hook.

Out of curiosity, what is actually the performance impact on all
of this? We were just arguing on a different matter on two more
instructions in the fast-path, here it's refactoring the whole
function into several ones, I presume gcc won't inline it.
