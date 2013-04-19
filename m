From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 01/14] netlink: add symbolic value for congested state
Date: Fri, 19 Apr 2013 17:24:21 +0400
Message-ID: <51714585.50805@cogentembedded.com>
References: <1366217229-22705-1-git-send-email-kaber@trash.net> <1366217229-22705-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1366217229-22705-2-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello.

On 17-04-2013 20:46, Patrick McHardy wrote:

> Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---
>   net/netlink/af_netlink.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index ce2e006..f20a810 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -68,6 +68,10 @@ struct listeners {
>   	unsigned long		masks[0];
>   };
>
> +/* state bits */
> +#define NETLINK_CONGESTED	0x0

    Bit numbers are generally expressed as decimal.

WBR, Sergei
