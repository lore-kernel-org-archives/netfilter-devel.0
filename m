From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH V2] netfilter: h323: avoid potential attack
Date: Thu, 28 Jan 2016 17:11:18 +0300
Message-ID: <56AA2186.1090208@cogentembedded.com>
References: <1453971597-4811-1-git-send-email-zhouzhouyi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>, eric.dumazet@gmail.com,
	pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	davem@davemloft.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.or
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34515 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbcA1OLX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 09:11:23 -0500
Received: by mail-lb0-f181.google.com with SMTP id cl12so24033045lbc.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 06:11:22 -0800 (PST)
In-Reply-To: <1453971597-4811-1-git-send-email-zhouzhouyi@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

On 1/28/2016 11:59 AM, Zhouyi Zhou wrote:

> Thanks Eric for your review and advice.
>
> I think hackers chould build a malicious h323 packet to overflow
> the pointer p which will panic during the memcpy(addr, p, len)
>
> For example, he may fabricate a very large taddr->ipAddress.ip;
>
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> ---
>   net/netfilter/nf_conntrack_h323_main.c |    7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
> index 9511af0..ccd08c5 100644
> --- a/net/netfilter/nf_conntrack_h323_main.c
> +++ b/net/netfilter/nf_conntrack_h323_main.c
> @@ -110,6 +110,7 @@ int (*nat_q931_hook) (struct sk_buff *skb,
>
>   static DEFINE_SPINLOCK(nf_h323_lock);
>   static char *h323_buffer;
> +#define CHECK_BOUND(p, n) ((void *)p + n - (void *)h323_buffer > 65536)

    You have to enclose the macro parameters in parens when used in expression.

MBR, Sergei

