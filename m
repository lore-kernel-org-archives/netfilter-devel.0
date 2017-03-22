From: jeffy <jeffy.chen@rock-chips.com>
Subject: Re: [PATCH 2/2 nf] netfilter: cthelper: Fix memory leak
Date: Wed, 22 Mar 2017 10:43:30 +0800
Message-ID: <58D1E4D2.3060207@rock-chips.com>
References: <1490100094-32269-1-git-send-email-pablo@netfilter.org> <1490100094-32269-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: zlpnobody@gmail.com, dianders@chromium.org,
        briannorris@chromium.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.136]:49732 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757425AbdCVCoK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 22:44:10 -0400
In-Reply-To: <1490100094-32269-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On chromebook kevin:
Tested-by: Jeffy Chen <jeffy.chen@rock-chips.com>

On 03/21/2017 08:41 PM, Pablo Neira Ayuso wrote:
> From: Jeffy Chen <jeffy.chen@rock-chips.com>
>
> We have memory leaks of nf_conntrack_helper & expect_policy.
>
> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Heavily based on your original patch, so I'm keeping you as original author
> for this fix.
>
>   net/netfilter/nfnetlink_cthelper.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
> index ffb51b91e646..bc43d8635cb8 100644
> --- a/net/netfilter/nfnetlink_cthelper.c
> +++ b/net/netfilter/nfnetlink_cthelper.c
> @@ -214,7 +214,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
>
>   	ret = nfnl_cthelper_parse_expect_policy(helper, tb[NFCTH_POLICY]);
>   	if (ret < 0)
> -		goto err;
> +		goto err1;
it's safe to kfree a null pointer, so we can use the same goto label 
with err2.
But it's up to you, just matter of taste :)

>
>   	strncpy(helper->name, nla_data(tb[NFCTH_NAME]), NF_CT_HELPER_NAME_LEN);
>   	helper->data_len = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
> @@ -245,10 +245,12 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
>
>   	ret = nf_conntrack_helper_register(helper);
>   	if (ret < 0)
> -		goto err;
> +		goto err2;
>
>   	return 0;
> -err:
> +err2:
> +	kfree(helper->expect_policy);
> +err1:
>   	kfree(helper);
>   	return ret;
>   }
> @@ -676,6 +678,8 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
>
>   			found = true;
>   			nf_conntrack_helper_unregister(cur);
> +			kfree(cur->expect_policy);
> +			kfree(cur);
>   		}
>   	}
>   	/* Make sure we return success if we flush and there is no helpers */
> @@ -739,6 +743,8 @@ static void __exit nfnl_cthelper_exit(void)
>   				continue;
>
>   			nf_conntrack_helper_unregister(cur);
> +			kfree(cur->expect_policy);
> +			kfree(cur);
>   		}
>   	}
>   }
>


