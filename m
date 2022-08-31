Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F33CECAAD4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Aug 2022 15:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiHaPfl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 11:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiHaPfk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 11:35:40 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D1B6BCED
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 08:35:37 -0700 (PDT)
Received: from mx0.riseup.net (mx0-pn.riseup.net [10.0.1.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mx0.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4MHpCr6n38zDrr2
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1661960137; bh=hEEYnFG6S/pLehGkDNYwQDxH/rjl/VcqthrXfQaHMs0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qsT/T5fEI+IFc2mt8wNNhAtNfmisOyItPvyqoU0x3WT/Uw6pu4yu7E110sfCAKXOf
         CkBhWiT6TpbO6svLcZCoQ8opA0qf4LjmxubDooRwttEQ+rERKQKXapsmcSKdysokCs
         +8DBpCDLijJjNbfI/nF36GCg3Wl9amCEnxbqrwPI=
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4MHpCr1wktz9t41;
        Wed, 31 Aug 2022 15:35:36 +0000 (UTC)
X-Riseup-User-ID: C8D68DE14B9C27DF8500C4A148C6D4C800F80CCAC47453742F179FB61AB7DB60
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4MHpCq43ZFz1yPb;
        Wed, 31 Aug 2022 15:35:35 +0000 (UTC)
Message-ID: <5d2dd31b-831c-158f-57f4-de611315fbdd@riseup.net>
Date:   Wed, 31 Aug 2022 17:35:33 +0200
MIME-Version: 1.0
Subject: Re: [PATCH nft] json: add set statement list support
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20220831123731.26249-1-ffmancera@riseup.net>
 <Yw94Gux4j02HzCh2@salvia>
From:   "Fernando F. Mancera" <ffmancera@riseup.net>
In-Reply-To: <Yw94Gux4j02HzCh2@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On 8/31/22 17:02, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Wed, Aug 31, 2022 at 02:37:31PM +0200, Fernando Fernandez Mancera wrote:
>> When listing a set with statements with JSON support, the statements were
>> ignored.
>>
>> Output example:
>>
>> {
>>    "set": {
>>      "op": "add",
>>      "elem": {
>>        "payload": {
>>          "protocol": "ip",
>>          "field": "saddr"
>>        }
>>      },
>>      "stmt": [
>>        {
>>          "limit": {
>>            "rate": 10,
>>            "burst": 5,
>>            "per": "second"
>>          }
>>        },
>>        {
>>          "counter": {
>>            "packets": 0,
>>            "bytes": 0
>>          }
>>        }
>>      ],
>>      "set": "@my_ssh_meter"
>>    }
>> }
> 
> LGTM, thanks.
> 
> Would you also extend tests/shell? There is a
> tests/shell/testcases/json/ folder where you can add one.
> 
> One example test can be found here: tests/shell/testcases/json/netdev
> 
> If you also create this folder:
> 
>    tests/shell/testcases/json/dump/mytest.dump
> 
> where 'mytest' is the name of you script under tests/shell/testcases/json/
> 
> Then, it also checks for the expected output via 'nft list ruleset'.

Sure, let me extend the tests too. I will send a v2 patch.

Thanks,
Fernando.

