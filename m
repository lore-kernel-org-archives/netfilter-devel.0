From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH net-next v4 7/8] openvswitch: Delay conntrack helper call
 for new connections.
Date: Wed, 9 Dec 2015 16:44:43 +0300
Message-ID: <5668304B.7010409@cogentembedded.com>
References: <1449622870-48944-1-git-send-email-jarno@ovn.org>
 <1449622870-48944-8-git-send-email-jarno@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, dev@openvswitch.org
To: Jarno Rajahalme <jarno@ovn.org>, netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34464 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbbLINop (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 08:44:45 -0500
Received: by lffu14 with SMTP id u14so34554321lff.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Dec 2015 05:44:44 -0800 (PST)
In-Reply-To: <1449622870-48944-8-git-send-email-jarno@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

On 12/9/2015 4:01 AM, Jarno Rajahalme wrote:

> There is no need to help connections that are not confirmed, so we can
> delay helping new connections to the time when they are confirmed.
> This change is needed for NAT support, and having this as a separate
> patch will make the following NAT patch a bit easier to review.
>
> Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
> ---
>   net/openvswitch/conntrack.c | 20 +++++++++++++++-----
>   1 file changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 7aa38fa..ba44287 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
[...]
> @@ -491,11 +496,16 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>   			return -ENOENT;
>
>   		ovs_ct_update_key(skb, key, true);
> +	}
>
> -		if (ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
> -			WARN_ONCE(1, "helper rejected packet");
> -			return -EINVAL;
> -		}
> +	/* Call the helper right after nf_conntrack_in() for confirmed
> +	 * connections, but only when commiting for unconfirmed connections.
> +	 */
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (ct && (nf_ct_is_confirmed(ct) ? !cached : info->commit)
> +	    && ovs_ct_helper(skb, info->family) != NF_ACCEPT) {

    Please don't place the operators at the start of a continuation lines, 
place the at the and of a broken up line instead.

[...]

MBR, Sergei

