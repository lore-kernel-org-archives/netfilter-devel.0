Return-Path: <SRS0=kOBD=7V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8302C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 22:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 858E62074B
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 22:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgFHWhp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 18:37:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:51218 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWhp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 18:37:45 -0400
IronPort-SDR: RQDllMmbhxAn+SntVGYimOJM0UJl3TNXkTdtc+z1H8NUE1Gxu+kFcZKg2RG8muUs3OWz/7GPHu
 8MP0xVZUJO2A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 15:37:44 -0700
IronPort-SDR: IVxxPubATQpyQMdXAnAzT3pn4ZjvL99rPnDvRXnSD21QgCOBnQEf6xnVAi6TV8gK3qEM1/TtS0
 efFyrQxu+RoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,489,1583222400"; 
   d="scan'208";a="446905549"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.71.222]) ([10.209.71.222])
  by orsmga005.jf.intel.com with ESMTP; 08 Jun 2020 15:37:43 -0700
Subject: Re: [PATCH 8/8 net] net: remove indirect block netdev event
 registration
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, paulb@mellanox.com, ozsh@mellanox.com,
        vladbu@mellanox.com, jiri@resnulli.us, kuba@kernel.org,
        saeedm@mellanox.com, michael.chan@broadcom.com
References: <20200513164140.7956-1-pablo@netfilter.org>
 <20200513164140.7956-9-pablo@netfilter.org>
 <59884f4f-df03-98ac-0524-3e58c904f201@intel.com>
 <20200608214739.GA12131@salvia>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <dd6aaf74-d7fc-9f84-f872-7ee4e3a971c3@intel.com>
Date:   Mon, 8 Jun 2020 15:37:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200608214739.GA12131@salvia>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 6/8/2020 2:47 PM, Pablo Neira Ayuso wrote:
> On Mon, Jun 08, 2020 at 02:07:57PM -0700, Jacob Keller wrote:
>>
>>
>> On 5/13/2020 9:41 AM, Pablo Neira Ayuso wrote:
>>> Drivers do not register to netdev events to set up indirect blocks
>>> anymore. Remove __flow_indr_block_cb_register() and
>>> __flow_indr_block_cb_unregister().
>>>
>>> The frontends set up the callbacks through flow_indr_dev_setup_block()
>>>
>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>
>> This commit failed to remove the prototypes from the header file:
>> include/net/flow_offload.h
> 
> Thanks for reporting.
> 
> I'm attaching a sketch, I will submit this formally later.
> 

The sketch looks good to me.

Regards,
Jake
