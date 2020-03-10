Return-Path: <SRS0=Yj8l=43=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432E6C10F27
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Mar 2020 14:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 167C0208E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Mar 2020 14:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=larkmoor.net header.i=@larkmoor.net header.b="Nj8JUnMv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCJOpg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Mar 2020 10:45:36 -0400
Received: from rs2.larkmoor.net ([162.211.66.16]:41178 "EHLO rs2.larkmoor.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgCJOpd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 10:45:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=larkmoor.net; s=larkmoor20140928;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject; bh=8bKoYOH0gYpRdbDEaAxo1P9CAj9kUFOMpPW8ErERvkg=;
        b=Nj8JUnMvvoS5oOpSGjULRGSDsEavHAup4ERjK/Ohau7LQpaef8ZcNRBC5MFbbpYftRfEtnNV+BOEwfy98nFBmMpRhDWJ0K5IaLuOueZMJvrUimvkBwhT3hiXO82UxFDovk50x+WR3t2xhetEQKrS19ddIFwIPEcK0YEfP2mqPjg=;
Received: from [10.0.0.31]
        by gw.larkmoor.net with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <fmyhr@fhmtech.com>)
        id 1jBg8S-0006wi-IS; Tue, 10 Mar 2020 10:45:32 -0400
Subject: Re: Restoring rulesets containing dynamic sets with counters
From:   Frank Myhr <fmyhr@fhmtech.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <5e5cfaed-d2c6-02e1-8019-dd6ba2613034@fhmtech.com>
 <20200310133738.zi3axvy62xqihrod@salvia>
 <11cd37e2-6340-a469-c564-d6970841b4cd@fhmtech.com>
Message-ID: <9bab2027-df96-7533-6d2a-4eaac7b5f277@fhmtech.com>
Date:   Tue, 10 Mar 2020 10:45:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <11cd37e2-6340-a469-c564-d6970841b4cd@fhmtech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020/03/10 10:14, Frank Myhr wrote:
>> On Mon, Mar 09, 2020 at 07:35:15PM -0400, Frank Myhr wrote:
>>> I do want to keep the dynamically-added elements across reboot.
...
> For now I'll stick with released & packaged (debian buster-backports) 
> nft, and use sed 's/[ ]\+counter[^,\}]\+//g' on saved rulesets before 
> restoring them.
...
For limits,
> sed 's/[ ]\+limit[^,\}]\+//g' before restoring from saved ruleset works 
> for me.

Thought I'd better follow up that I'm running these sed commands on 
ruleset fragments that each include a single dynamic set _only_. I then 
cat these together with other files that contain nftables chains and 
rules, then load the combined file using nft -f.

Just want to be clear that nobody should run those sed commands on a 
complete ruleset file; they will wipe out any counter and limit 
statements that occur anywhere in the file, not just in sets. For a 
complete ruleset file you would need to use some additional logic to 
distinguish whether or not the set & limit statements occur inside of a set.

Best regards,
Frank
