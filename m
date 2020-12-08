Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6005DC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 20:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 334AA23AA8
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 20:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgLHUdT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:33:19 -0500
Received: from alva.zappa.cx ([213.136.63.253]:53200 "EHLO alva.zappa.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgLHUdT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 15:33:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=zappa.cx;
         s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version
        :Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2E1VTc2aE8QunBovujwSrT3jshLNIKCOHA9vIrFyJ8w=; b=frEBhHNKTBtHZ7NaXqyYCrDcEY
        o1ScvWlbRPo06xmHfG99pmB2sUnNO7SjXrsLH6mNexrw1tRK8AOwyhZlpl2NYx8tAzDSNN6jEVzlY
        MZlQoQLU2cL/bHshKJ4KC9tZfgZWZ9Zl6ugKtTNOIG9+CjbORDf97vo5Pbm7EcqhLf4I=;
Received: from [195.178.160.156] (helo=matrix.zappa.cx)
        by alva.zappa.cx with esmtp (Exim 4.92)
        (envelope-from <sunkan@zappa.cx>)
        id 1kmjf2-0007RT-1E; Tue, 08 Dec 2020 21:32:36 +0100
Received: from [192.168.20.140] (asu-xps13.zappa.cx [192.168.20.140])
        (authenticated bits=0)
        by matrix.zappa.cx (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTPSA id 0B8KWTOf028888
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT);
        Tue, 8 Dec 2020 21:32:33 +0100
Subject: Re: [PATCH] Remove IP_NF_IPTABLES dependency for NET_ACT_CONNMARK
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <c9657e87-731c-3219-62eb-0cc15b0ff4cd@zappa.cx>
 <20201208163926.GA10267@salvia>
From:   Andreas Sundstrom <sunkan@zappa.cx>
Message-ID: <978c5ab8-a0ff-76a5-0549-1b0617eb7e17@zappa.cx>
Date:   Tue, 8 Dec 2020 21:32:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201208163926.GA10267@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.11 (matrix.zappa.cx [192.168.20.100]); Tue, 08 Dec 2020 21:32:34 +0100 (CET)
X-Scanned-By: MIMEDefang 2.84 on 192.168.20.100
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-12-08 17:39, Pablo Neira Ayuso wrote:
> Hi Andreas,
>
> On Tue, Dec 08, 2020 at 12:55:30PM +0100, Andreas Sundstrom wrote:
>> IP_NF_IPTABLES is a superfluous dependency
>>
>> To be able to select NET_ACT_CONNMARK when iptables has not been
>> enabled this dependency needs to be removed.
> I just looked at other dependencies in the Kconfig file, these need to
> be adjusted too.
>
> NET_ACT_IPT actually depends on NETFILTER_XTABLES.
>
> Is the patch I'm attaching looking good to you?

Yes it looks good, I can now also enable NET_ACT_CTINFO with my config.

Am now running 5.9.13 with it applied.

/Andreas

