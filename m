From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_owner: Add translation to nft
Date: Wed, 2 Mar 2016 12:42:50 +0100
Message-ID: <20160302114250.GA2580@salvia>
References: <20160301191726.GA15217@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51346 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbcCBLm6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 06:42:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6A1CE741E
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:42:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5575CDA39B
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:42:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 320BDDA39B
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:42:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160301191726.GA15217@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 12:47:26AM +0530, Shivani Bhardwaj wrote:
> Add translation for module owner to nftables.
> Full translation of this match awaits the support for --socket-exists
> option.
> 
> Examples:
> 
> $ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --uid-owner root -j ACCEPT
> nft add rule ip nat OUTPUT tcp dport 80 skuid 0 counter accept
> 
> $ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --gid-owner 0-10 -j ACCEPT
> nft add rule ip nat OUTPUT tcp dport 80 skgid 0-10 counter accept
> 
> $ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner shivani -j ACCEPT
> nft add rule ip nat OUTPUT tcp dport 80 skuid != 1000 counter accept


> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libxt_owner.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
> index d9adc12..d81080a 100644
> --- a/extensions/libxt_owner.c
> +++ b/extensions/libxt_owner.c
> @@ -492,6 +492,62 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
>  	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    true);
>  }
>  
> +static void
> +owner_mt_print_item_xlate(const struct xt_owner_match_info *info,
> +			  const char *label, uint8_t flag,
> +			  struct xt_xlate *xl, bool numeric)
> +{
> +	if (!(info->match & flag))
> +		return;
> +
> +	xt_xlate_add(xl, "%s%s", label, info->invert & flag ? "!= " : "");
> +
> +	switch (info->match & flag) {
> +	case XT_OWNER_UID:
> +		if (info->uid_min != info->uid_max) {
> +			xt_xlate_add(xl, "%u-%u ", (unsigned int)info->uid_min,
> +				     (unsigned int)info->uid_max);
> +			break;
> +		} else if (!numeric) {
> +			const struct passwd *pwd = getpwuid(info->uid_min);
> +
> +			if (pwd != NULL && pwd->pw_name != NULL) {
> +				xt_xlate_add(xl, " %s", pwd->pw_name);
> +				break;
> +			}
> +		}
> +		xt_xlate_add(xl, "%u ", (unsigned int)info->uid_min);
> +		break;
> +
> +	case XT_OWNER_GID:
> +		if (info->gid_min != info->gid_max) {
> +			xt_xlate_add(xl, "%u-%u ", (unsigned int)info->gid_min,
> +				     (unsigned int)info->gid_max);
> +			break;
> +		} else if (!numeric) {
> +			const struct group *grp = getgrgid(info->gid_min);
> +
> +			if (grp != NULL && grp->gr_name != NULL) {
> +				xt_xlate_add(xl, "%s ", grp->gr_name);
> +				break;
> +			}
> +		}
> +		xt_xlate_add(xl, "%u ", (unsigned int)info->gid_min);
> +		break;
> +	}

Could you better split this in two functions?

> +}
> +
> +static int owner_mt_xlate(const struct xt_entry_match *match,
> +			  struct xt_xlate *xl, int numeric)
> +{
> +	const struct xt_owner_match_info *info = (void *)match->data;
> +
> +	owner_mt_print_item_xlate(info, "skuid ", XT_OWNER_UID, xl, true);
> +	owner_mt_print_item_xlate(info, "skgid ", XT_OWNER_GID, xl, true);

The idea is this looks like:

	switch (info->match & flag) {
	case XT_OWNER_UID:
                ret = owner_mt_print_uid_xlate(info, xl);
                break;
        case XT_OWNER_GID:
                ret = owner_mt_print_gid_xlate(info, xl);
                break;
        }

There seem to be very little code we can actually consolidate from
what I can see.

Thanks.
