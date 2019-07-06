Return-Path: <SRS0=/Ma8=VD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD380C0650E
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 12:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93D3D20989
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 12:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="UHM+VHpw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfGFMLr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Jul 2019 08:11:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51576 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfGFMLr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jul 2019 08:11:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so11535669wma.1
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Jul 2019 05:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g999pEtD0FzSaL6N2yZxnu1/NtRd71+QrEpF9P4ldP4=;
        b=UHM+VHpwAwdLD4joN7tLl/jxi0KshZBnLutF5EHC4s9ioNUMD0HuDbanq5lbiGu9c7
         IfMT1moTcP3xXlwQ9Eub75jS4WBmZS9kSFG0IDktIKP0BUVVqGMw64l7PavdG+B4kKsI
         gSjWA50/3eNwN9ivaeeuctCp4JLUz9nupp49w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g999pEtD0FzSaL6N2yZxnu1/NtRd71+QrEpF9P4ldP4=;
        b=TIvr4C+IdOhmHwP0cVB9sMmKXz19Ov9UsuViuuduMC8wl1LNgf0nCvlEcP2Lha0l+M
         +fIdFVaDq+o7bcGB/Imj8owmnBxaJSGLeZjlklS3YTfkigq1gEw0i9od8dLY7Lhnzcnx
         RikjDfRE9b9Ina5m9b8EIuLNI+CvTYwgAbmnMQSvcT4Mc/3VjFTC2HrzbyYljfwjTN44
         kKKIMmzN2K2gwJH9i6HRvd4z6lSAId6WdWQIv8SZwqBiDA3eLBrNDZ4fSzKomYmnqvit
         q3IMafobxW1oB710mN/+5bdXZUmGfDzNFUL9GehbZKH+Kz0BkrxS7ZkVZ1Jm4skfy1Jj
         s1sg==
X-Gm-Message-State: APjAAAUxTkIYM/nagaawQKe+iaS2LSqrO9jiH7MnyldW2Jfs1Yk9ExGG
        XWMHrL/WCnGCij4Z6vOMVqMasA==
X-Google-Smtp-Source: APXvYqxyxIKYYs+ixRHiwhEfmT4bufHMONxBlK+LPfSOX4ViWsuGc58UMlmNb+JVkoqZv4+535Z9qg==
X-Received: by 2002:a1c:7e14:: with SMTP id z20mr7847450wmc.83.1562415104876;
        Sat, 06 Jul 2019 05:11:44 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id n125sm16134723wmf.6.2019.07.06.05.11.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 05:11:44 -0700 (PDT)
Subject: Re: [PATCH 3/5 nf-next v3] bridge: add br_vlan_get_info_rcu()
To:     wenxu@ucloud.cn, pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562364550-16974-1-git-send-email-wenxu@ucloud.cn>
 <1562364550-16974-3-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <114db8d1-2267-a338-688a-61f7f6db53ac@cumulusnetworks.com>
Date:   Sat, 6 Jul 2019 15:11:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562364550-16974-3-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 06/07/2019 01:09, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This new function allows you to fetch vlan info from packet path.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/linux/if_bridge.h |  7 +++++++
>  net/bridge/br_vlan.c      | 23 ++++++++++++++++++-----
>  2 files changed, 25 insertions(+), 5 deletions(-)
> 

Hi,
This patch will need more work, comments below.

> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 9e57c44..5c85608 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -92,6 +92,8 @@ static inline bool br_multicast_router(const struct net_device *dev)
>  int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
>  int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  		     struct bridge_vlan_info *p_vinfo);
> +int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
> +			 struct bridge_vlan_info *p_vinfo);
>  #else
>  static inline bool br_vlan_enabled(const struct net_device *dev)
>  {
> @@ -118,6 +120,11 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  {
>  	return -EINVAL;
>  }
> +static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
> +				       struct bridge_vlan_info *p_vinfo)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #if IS_ENABLED(CONFIG_BRIDGE)
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 021cc9f66..2799a88 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -1267,15 +1267,13 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
>  }
>  EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
>  
> -int br_vlan_get_info(const struct net_device *dev, u16 vid,
> -		     struct bridge_vlan_info *p_vinfo)
> +static int __br_vlan_get_info(const struct net_device *dev, u16 vid,
> +			      struct net_bridge_port *p,
> +			      struct bridge_vlan_info *p_vinfo)
>  {
>  	struct net_bridge_vlan_group *vg;
>  	struct net_bridge_vlan *v;
> -	struct net_bridge_port *p;
>  
> -	ASSERT_RTNL();

Removing the assert here doesn't make the function proper for RCU usage.
You'll either have to split it in two and use the proper accessors to
retrieve the vlan group based on the context (rtnl or rcu) or you'll
just have to add a second version of this function which uses the proper
accessors. Also note that for the RCU version you need to check if vg
is null.

> -	p = br_port_get_check_rtnl(dev);
>  	if (p)
>  		vg = nbp_vlan_group(p);
>  	else if (netif_is_bridge_master(dev))
> @@ -1291,8 +1289,23 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  	p_vinfo->flags = v->flags;
>  	return 0;
>  }
> +
> +int br_vlan_get_info(const struct net_device *dev, u16 vid,
> +		     struct bridge_vlan_info *p_vinfo)
> +{
> +	ASSERT_RTNL();
> +
> +	return __br_vlan_get_info(dev, vid, br_port_get_check_rtnl(dev), p_vinfo);
> +}
>  EXPORT_SYMBOL_GPL(br_vlan_get_info);
>  
> +int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
> +			 struct bridge_vlan_info *p_vinfo)
> +{
> +	return __br_vlan_get_info(dev, vid, br_port_get_check_rtnl(dev), p_vinfo);
> +}
> +EXPORT_SYMBOL_GPL(br_vlan_get_info_rcu);
> +

This should use br_port_get_check_rcu().

>  static int br_vlan_is_bind_vlan_dev(const struct net_device *dev)
>  {
>  	return is_vlan_dev(dev) &&
> 

