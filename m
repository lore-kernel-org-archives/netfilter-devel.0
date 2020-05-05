Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F1CC47256
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 18:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DA4A2078C
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 18:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588704382;
	bh=aH0UNzPg/9kLER+V9dVWQxAola4B5LI8RxYusZuvzR8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=sp0yGAwSzlr4cpO1+FteYIVpZG070kQRWGOoG8hgo2LH3heBtEVhbAq2CnINp3WzW
	 y8j160fTsUQdj0SYQtm4uz5ULQ1uv6L+waA/gV2hgHUqkdc6FPLrIQW6o9OthN4mQo
	 fr8J+2TSyPH9l9dcN5pnu0AfUJgS8aO7KcOaFd+A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgEESqT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 14:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgEESqT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 14:46:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA2CC206CC;
        Tue,  5 May 2020 18:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588704379;
        bh=aH0UNzPg/9kLER+V9dVWQxAola4B5LI8RxYusZuvzR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YmoPHZeHSy02tkM7lhZfBFyxSNDIBHfqyO35SeGRNOrPrZbESEFPqdrVPNc8PZKbw
         CdAkUVzPbTvuFxbJcoMyDGe8DONkg0Qnc3xxBLWbNPgvCtNDdQvLuAP01zhlGPFG43
         Sz+1O9CXOmDv7+a6ECRtzV7pgx/vSqlMfgFHIH00=
Date:   Tue, 5 May 2020 11:46:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, ecree@solarflare.com
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505114616.221fc9af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200505183643.GI14398@nanopsycho.orion>
References: <20200505174736.29414-1-pablo@netfilter.org>
        <20200505183643.GI14398@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 5 May 2020 20:36:43 +0200 Jiri Pirko wrote:
> Tue, May 05, 2020 at 07:47:36PM CEST, pablo@netfilter.org wrote:
> >This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
> >that the frontend does not need counters, this hw stats type request
> >never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
> >the driver to disable the stats, however, if the driver cannot disable
> >counters, it bails out.
> >
> >TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
> >except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
> >(this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
> >TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
> >
> >Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>  
> 
> Looks great. Thanks!
> 
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Is this going to "just work" for mlxsw?

        act = flow_action_first_entry_get(flow_action);                         
        if (act->hw_stats == FLOW_ACTION_HW_STATS_ANY ||                        
            act->hw_stats == FLOW_ACTION_HW_STATS_IMMEDIATE) {                  
                /* Count action is inserted first */                            
                err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);    
                if (err)                                                        
                        return err;                                             
        } else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED) {            
                NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type"); 
                return -EOPNOTSUPP;                                             
        }

if hw_stats is 0 we'll get into the else and bail.

That doesn't deliver on the "don't care" promise, no?
