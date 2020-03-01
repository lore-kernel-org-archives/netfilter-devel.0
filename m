Return-Path: <SRS0=wwvA=4S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58351C3F2D4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Mar 2020 08:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F64624677
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Mar 2020 08:44:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="HCeQHqzM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgCAIor (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Mar 2020 03:44:47 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39512 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgCAIor (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Mar 2020 03:44:47 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so8607664wrn.6
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Mar 2020 00:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OhCnyvX4fMCwKA/4hedL0ChmXZc2TNAFj454NJr/ZJ8=;
        b=HCeQHqzMQbn9Y/6/K0Mdgv7eWulaUA7ppEUyqnou5TpHMD/rmBXDgPyMcDMx72+MQ/
         YOmI5bPxqe2LYjHw+q5ahpY0TgBkqT4B78H6AQWLx6S9jm1ZrPF4RBkLji/faarcdKBa
         v8mzpo3/UQ7BczLfHoGfr4tL0+zMYQ51/aLBM3r3a0tVziGTutk6/FZBFuk/b6n3PCXe
         Ppkd/IwCM4uF3h87w6vYdDeqjxwuqDkAPSVGAHw3w3Di4yOyfETRvhFqZPXUHZbs9SJX
         rBJvscXoxgpS/23RCyTpuQPX4jZJEo85MbdPXrE+BwP0g5qHliYqi+JdvOXKk9w2vSLu
         oVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OhCnyvX4fMCwKA/4hedL0ChmXZc2TNAFj454NJr/ZJ8=;
        b=IR+HVjHp4hfx56YfN7fEiCYw0u2TgZScZoDkY5sEYO1cT2jIG4SVUPP0KiNH/6Mm6Z
         QwJ04nm10ovxMMRhcKHyPqq+44HUZnWzJv2ONh4WV6Zutv8TYmb4hFPpoa9emdNHTSbQ
         q3lkNwyOXsxR30/ccYLcLaLa2fCSXqrMuNnQjkbcZXVr/ThuNC60iAVqQa38UBbeRkud
         46KO4GyP7lQaXssOEZbadGlw8TQmItBMcyHXClNEecJHV5Of3inGdzjifPo1yoN5XAG7
         fPfFy+bxArWJKGj/gxOyrkMY8RsWmwXCCRm73L9UNg6VuSli4ZoMRWaHg3yptkQEQ4j+
         ma5g==
X-Gm-Message-State: APjAAAWSW/hAB8ite/VHHRHtdnD93YcawJ7fgjc7aG9ceGjeXAgAZ3oq
        HIvN54eABxcA9A3Ae7UmQfeEop+/yTc=
X-Google-Smtp-Source: APXvYqyvP7eP1XCbyeCOfac57ekrIJtE2aETPYTBL5BLEfQkXaEA1VPfhsOmJ50MUvccJlChytEo8g==
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr16170884wru.220.1583052285344;
        Sun, 01 Mar 2020 00:44:45 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id y185sm10196832wmg.2.2020.03.01.00.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 00:44:44 -0800 (PST)
Date:   Sun, 1 Mar 2020 09:44:43 +0100
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
Message-ID: <20200301084443.GQ26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-2-jiri@resnulli.us>
 <20200229192947.oaclokcpn4fjbhzr@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229192947.oaclokcpn4fjbhzr@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sat, Feb 29, 2020 at 08:29:47PM CET, pablo@netfilter.org wrote:
>On Fri, Feb 28, 2020 at 06:24:54PM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Initially, pass "ANY" (struct is zeroed) to the drivers as that is the
>> current implicit value coming down to flow_offload. Add a bool
>> indicating that entries have mixed HW stats type.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> v1->v2:
>> - moved to actions
>> - add mixed bool
>> ---
>>  include/net/flow_offload.h | 6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index 4e864c34a1b0..eee1cbc5db3c 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -154,6 +154,10 @@ enum flow_action_mangle_base {
>>  	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
>>  };
>>  
>> +enum flow_action_hw_stats_type {
>> +	FLOW_ACTION_HW_STATS_TYPE_ANY,
>> +};
>> +
>>  typedef void (*action_destr)(void *priv);
>>  
>>  struct flow_action_cookie {
>> @@ -168,6 +172,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
>>  
>>  struct flow_action_entry {
>>  	enum flow_action_id		id;
>> +	enum flow_action_hw_stats_type	hw_stats_type;
>>  	action_destr			destructor;
>>  	void				*destructor_priv;
>>  	union {
>> @@ -228,6 +233,7 @@ struct flow_action_entry {
>>  };
>>  
>>  struct flow_action {
>> +	bool				mixed_hw_stats_types;
>
>Why do you want to place this built-in into the struct flow_action as
>a boolean?

Because it is convenient for the driver to know if multiple hw_stats_type
values are used for multiple actions.


>
>You can express the same thing through a new FLOW_ACTION_COUNTER.

I don't see how.


>I know tc has implicit counters in actions, in that case tc can just
>generate the counter right after the action.

I don't follow. Each action has a separate stats.


>
>Please, explain me why it would be a problem from the driver side to
>provide a separated counter action.

I don't see any point in doing that. The action itself implies that has
stats, you don't need a separate action for that for the flow_offload
abstraction layer. What you would end up with is:
counter_action1, actual_action1, counter_action2, actual_action2,...

What is the point of that?

