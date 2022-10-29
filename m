Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991CCC38A02
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Oct 2022 08:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiJ2IpL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Oct 2022 04:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ2IpL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2022 04:45:11 -0400
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D315A15E
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2022 01:45:08 -0700 (PDT)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4MztJz4XHsz9ss2;
        Sat, 29 Oct 2022 08:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1667033107; bh=FrQa/XsiUDc72Dpj9zau9MXCkdQ9NuRgThI2X4dkltA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=odHdpmH82alYikXqDSHsSfPCvIDOECU90IUlrPfZgz70e/Im+DHv3LF1TR9+9hXvF
         H6J0MSgDIY91xnKUYpN3qn8c25gG9IWn4AcydbD6yPma1B9iVS12d+sgB8fgcqmdUE
         J4F0RfXUa3/IP1/z3+ODP1CB9iUk33sbGjDMVgS4=
X-Riseup-User-ID: 6D16A9AED903E92749F26DE9AB141C93BF47E0D258E4B797C2A57A5B5BFF9E7E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4MztJy5QBTz5vXJ;
        Sat, 29 Oct 2022 08:45:06 +0000 (UTC)
Message-ID: <56b5d608-c00e-b520-69bc-d6d25955175c@riseup.net>
Date:   Sat, 29 Oct 2022 10:45:03 +0200
MIME-Version: 1.0
Subject: Re: [PATCH nf-next v2] netfilter: nf_tables: add support to destroy
 operation
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
References: <20221028100531.58666-1-ffmancera@riseup.net>
 <Y1wfGIaFVssu+/4B@orbyte.nwl.cc>
Content-Language: en-US
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
In-Reply-To: <Y1wfGIaFVssu+/4B@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On 28/10/2022 20:27, Phil Sutter wrote:
> Hi,
> 
> On Fri, Oct 28, 2022 at 12:05:31PM +0200, Fernando Fernandez Mancera wrote:
> [...]
>> @@ -3636,6 +3642,9 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
>>   		if (nla[NFTA_RULE_HANDLE]) {
>>   			rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
>>   			if (IS_ERR(rule)) {
>> +				if (PTR_ERR(rule) == -ENOENT &&
>> +				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
>> +					return 0;
>>   				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
>>   				return PTR_ERR(rule);
>>   			}
> 
> I guess you're exceeding the 80 column limit here? Doesn't checkpatch.pl
> complain?
> 

Nope, checkpatch.pl checks for a 100 column limit. Anyway, let me send a 
v3 as I prefer the 80 column limit.

Thanks,
Fernando.

> Cheers, Phil

