Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33426C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Apr 2022 16:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbiD1QbG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 12:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbiD1QbF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 12:31:05 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84701AAE1B
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2022 09:27:50 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D7D153200905;
        Thu, 28 Apr 2022 12:27:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 28 Apr 2022 12:27:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sbrecher.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1651163268; x=
        1651249668; bh=NgCblYd4NLTYF1abXq5VNtB2Yv0EKYqs6qQsleNlAZ8=; b=j
        gSfbZEcnyHR1I1lm6R8mFXIki+LTF7N/GWirm8zCDAYXJQrktOWlXfEKSjQBmjRN
        nDzw+6MJ+fxqIbDejXpenH4lq0KiBBev2EkUsWgmpkcYOrabZRdhNE4siguJA6pk
        K+fqB0ncX8j+4xdWXhRQ9kL2Wgr5bpjJMVNK66Y6Dj2HycXGkYaZt4CnP22O9NDH
        lURDvOcoOn98+JDUD5NsIEXmOQV6S7KfuKqoSc1Oda6khmvAoDvJnZPpMrNCIz0p
        j21U84nOMcMrH3XMvJZDY79ZK5uNtDRg8/peg7Ymkvze6ZQlLuNrpWccsEgigGlG
        du+Ow83pi0JRYRFpbDVWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1651163268; x=1651249668; bh=NgCblYd4NLTYF
        1abXq5VNtB2Yv0EKYqs6qQsleNlAZ8=; b=xHjx2+iah2jppB4xTolw+nO9wjfHJ
        hi14KlW4lbXrdT/WcX42YWAL3ldISvkj35Nj5ozV6WqCgmo1W+XSBZ5cElxfkRWs
        TIrIuELy95JZB/MneDq+fQ0JJYMaFkazT2o2Q4LyfJDlAIkiQuGHLkM19vXkvm17
        +9gp8dzoVTWG3FfucshfWTPwUXrNG92yJpJZI2xPaJyyrqSw82/bn+ramSojjQLL
        bfUwAfukpFLr5rmrG7Z1ckxDAZmTbpds/oD/ZUIlLyM6n+kCOfx0uvhZLdRk7Q8Z
        4ZGFFuuidmODlWzAWCM6Bz5FX4VQTZQXTaDjFiX7r9yPMbk+mweYwsk2A==
X-ME-Sender: <xms:hMBqYpfNA07sFsRajQKOZ4Zb5g5_RvzDxM3uBBNQiKqMd_n6E0sIAw>
    <xme:hMBqYnNPfmOJAJMQEVsMFh-AF9KyqSXyVY8NhjJed9nOOuQsgOQXOxVzvl72IUpoc
    pKh8FzP7nuokqnqxxE>
X-ME-Received: <xmr:hMBqYih-jccXBUe__Hnnhq4GVtUpkAMihd5JQW5x6hRNLU9e01k3nyX8SLUoRXwShTbFkjAO9CM6IcSboPPkGSmOs_HZppcO-Pc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpefuthgv
    vhgvuceurhgvtghhvghruceoshhtvghvvgesshgsrhgvtghhvghrrdgtohhmqeenucggtf
    frrghtthgvrhhnpeehveekheffgefhfeeiheeihfetueeuleevudejgfefledukeejgfei
    tdevtefgheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehsthgvvhgvsehssghrvggthhgvrhdrtghomh
X-ME-Proxy: <xmx:hMBqYi8TWlgidGoEYdYYwX68yCcLW8e6LMtuc8v_DjPUkk3vX15gNw>
    <xmx:hMBqYlspLjnheNorTng7WN0S-FG0bAe_-VKMR0dPvZgHrr180dkusA>
    <xmx:hMBqYhH6mVyiPgkmzP3u6MkssKVrCY8YXMNW0B3JkPfv__4JCDGuYw>
    <xmx:hMBqYj04rdYnNLQR2-2COrvj7VYIix7FxeIU2Z6XbHNurSRzX03rmw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 Apr 2022 12:27:47 -0400 (EDT)
Message-ID: <e8cc8710-488e-14fc-be89-10d562739595@sbrecher.com>
Date:   Thu, 28 Apr 2022 09:27:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: Minor issue in iptables(8) man page
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <f7f0656d-4634-caad-c562-3121756f5afb@sbrecher.com>
 <20220428161246.GG9849@breakpoint.cc>
From:   Steve Brecher <steve@sbrecher.com>
In-Reply-To: <20220428161246.GG9849@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ah, sorry! New rule for me: never trust a man page on the web. I see, based 
on an actual implementation, that we're up to (at least) *five*.

Florian Westphal wrote on 2022/04/28 09:12 AM:
> Steve Brecher <steve@sbrecher.com> wrote:
>> Hi,
>>
>> The 4th section of the page, Tables, begins, "There are currently three
>> independent tables ..." but lists four tables (filter, nat, mangle, and
>> raw).
> 
> Update :-)  This was fixed in 2013.
