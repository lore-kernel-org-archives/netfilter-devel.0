Return-Path: <SRS0=hj4T=4T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D288C3F2D2
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 13:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F8832166E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 13:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="KXuFf1Im"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgCBN6y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 08:58:54 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46408 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgCBN6y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 08:58:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id j7so12625993wrp.13
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Mar 2020 05:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=37tJ1WWoA+O7u34iwkULBKZOx8EG6BjIvyNTVarR5og=;
        b=KXuFf1Im9io17S3N1EFMl1UrMJzY78+OCUJEwEkB443D9VOLyQZspLYoNGznXvK0cd
         Xn7keviS7T38mFE/lp88Gw9hMij8QuCZn6mAcQpMjuoogb4F+XEKPAtKihMY63xIwrhc
         0yfVPiOHZeiM4O+3qDCn03i0NbFubX3TfJ61OdhEb7qyLslfn4WzRu1BKeWBHJaevwGC
         kD9g83ZniIEvgCuZkPqsP0H+dJ+OFenKd6WlJkfWnUbNohlFrn/g/1hKBUZAoLamQQGw
         pClEflofbjCvL7ylZfFyf3mX3KlSmc2jZnqzwAyp/9RJ1mrFCewI5l0HBEVdTrxrK7kL
         +ycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=37tJ1WWoA+O7u34iwkULBKZOx8EG6BjIvyNTVarR5og=;
        b=M+F7LR7VdPBEKoa1pXu/aW7cX2eMyfFJ41U0+AdJN/py7H5VAKLJyVRz5Ha4MqPsOi
         /zK3OvM7Z+j7rB+iCOfsGtqMOPoNAwMv4aIOhes0Z8kFoIlfAqU2UUWgylKRHlLZYlhH
         T1EsPMLWASqimt+eHuA4dd8URbpfeEjMhjkb42v0ff+KhLk9fo/mczDCl11YHr+1INvy
         uTY3tQWBRy42auOYqPFb8Xjx9yFbUatHAOWgPGm+/FAdjAHOAQeBBKoCt14OlfmXFdhN
         B0/qD3qxNDHF4KU+QuASJl0cKiTUDPCQtkk85JFGnS1NWNcMlpcpK+un6F/lL4nWE5Fw
         j5Eg==
X-Gm-Message-State: APjAAAU7tsb7nNUGIh/64ir6F6PFoeSA3T69tt1y/H5onuXvNRazzEKr
        SwfXz5xQvNCsFVBMDscz/qTceg==
X-Google-Smtp-Source: APXvYqz3JXIQtxCxlFWB0+pAjW61J9kq3eXosJsHpEEY4eqKO1UF/vnlKjFdfp/kYuH+CCgmpvyD+g==
X-Received: by 2002:adf:f686:: with SMTP id v6mr13799086wrp.176.1583157532066;
        Mon, 02 Mar 2020 05:58:52 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id t3sm28333051wrx.38.2020.03.02.05.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 05:58:51 -0800 (PST)
Date:   Mon, 2 Mar 2020 14:58:49 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ecree@solarflare.com, mlxsw@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200302135849.GA6497@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-2-jiri@resnulli.us>
 <20200229192947.oaclokcpn4fjbhzr@salvia>
 <20200301084443.GQ26061@nanopsycho>
 <20200302132016.trhysqfkojgx2snt@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302132016.trhysqfkojgx2snt@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mon, Mar 02, 2020 at 02:20:16PM CET, pablo@netfilter.org wrote:
>On Sun, Mar 01, 2020 at 09:44:43AM +0100, Jiri Pirko wrote:
>> Sat, Feb 29, 2020 at 08:29:47PM CET, pablo@netfilter.org wrote:
>> >On Fri, Feb 28, 2020 at 06:24:54PM +0100, Jiri Pirko wrote:
>[...]
>> >> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> >> index 4e864c34a1b0..eee1cbc5db3c 100644
>> >> --- a/include/net/flow_offload.h
>> >> +++ b/include/net/flow_offload.h
>> >> @@ -154,6 +154,10 @@ enum flow_action_mangle_base {
>> >>  	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
>> >>  };
>> >>  
>> >> +enum flow_action_hw_stats_type {
>> >> +	FLOW_ACTION_HW_STATS_TYPE_ANY,
>> >> +};
>> >> +
>> >>  typedef void (*action_destr)(void *priv);
>> >>  
>> >>  struct flow_action_cookie {
>> >> @@ -168,6 +172,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
>> >>  
>> >>  struct flow_action_entry {
>> >>  	enum flow_action_id		id;
>> >> +	enum flow_action_hw_stats_type	hw_stats_type;
>> >>  	action_destr			destructor;
>> >>  	void				*destructor_priv;
>> >>  	union {
>> >> @@ -228,6 +233,7 @@ struct flow_action_entry {
>> >>  };
>> >>  
>> >>  struct flow_action {
>> >> +	bool				mixed_hw_stats_types;
>> >
>> >Why do you want to place this built-in into the struct flow_action as
>> >a boolean?
>> 
>> Because it is convenient for the driver to know if multiple hw_stats_type
>> values are used for multiple actions.
>> 
>> >You can express the same thing through a new FLOW_ACTION_COUNTER.
>[...]
>> >Please, explain me why it would be a problem from the driver side to
>> >provide a separated counter action.
>> 
>> I don't see any point in doing that. The action itself implies that has
>> stats, you don't need a separate action for that for the flow_offload
>> abstraction layer. What you would end up with is:
>> counter_action1, actual_action1, counter_action2, actual_action2,...
>> 
>> What is the point of that?
>
>Yes, it's a bit more work for tc to generate counter action + actual
>action.
>
>However, netfilter has two ways to use counters:
>
>1) per-rule counter, in this case the counter is updated after rule
>   matching, right before calling the action. This is the legacy mode.
>
>2) explicit counter action, in this case the user specifies explicitly
>   that it needs a counter in a given position of the rule. This
>   counter might come before or after the actual action.
>
>ethtool does not have counters yet. Now there is a netlink interface
>for it, there might be counters there at some point.
>
>I'm suggesting a model that would work for the existing front-ends
>using the flow_action API.

I see. I'm interested in 1) now. If you ever want to implement 2), I see
no problem in doing it.

