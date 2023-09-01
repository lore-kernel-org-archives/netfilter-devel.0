Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C190FCA0FE6
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 12:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237195AbjIAMtF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 08:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbjIAMtF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 08:49:05 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420E110D5;
        Fri,  1 Sep 2023 05:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jEz8bAiOVlmzGdyxUIRR9AqE3yM7qGpXifKELMij1zU=; b=bPDfqYlRZsgayZhwrUmZHK4qqy
        wOhu67FVYBlvtiJE1ufsAjbKHCH2otyMA6R2kwC7/wCmQGA0ThXopW0L1ZS8fgRXI2Wv/2jeoqmS0
        gH3nnS20aMxbu9VqkWp2NbqRWyrEcc7BHyLu1yXiqeLrbRcJKeSYeK3wqsBz0eg3SIcs=;
Received: from p4ff13705.dip0.t-ipconnect.de ([79.241.55.5] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1qc3YM-00Eyv9-Bw; Fri, 01 Sep 2023 14:47:10 +0200
Message-ID: <61ea0316-2687-4928-a4d5-de20f3205c29@nbd.name>
Date:   Fri, 1 Sep 2023 14:47:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] netfilter: nf_tables: ignore -EOPNOTSUPP on flowtable
 device offload setup
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <20230831201420.63178-1-nbd@nbd.name> <ZPGjVl7jmLhMhgBP@calendula>
 <2575f329-7d95-46f8-ab88-2bcdf8b87d66@nbd.name> <ZPHZOKwPFflnqfFz@calendula>
From:   Felix Fietkau <nbd@nbd.name>
Autocrypt: addr=nbd@nbd.name; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCeMncXpbbWNT2AtoAYICrKyX5R3iMAoMhw
 cL98efvrjdstUfTCP2pfetyN
In-Reply-To: <ZPHZOKwPFflnqfFz@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 01.09.23 14:29, Pablo Neira Ayuso wrote:
> On Fri, Sep 01, 2023 at 12:30:37PM +0200, Felix Fietkau wrote:
>> On 01.09.23 10:39, Pablo Neira Ayuso wrote:
>> > Hi Felix,
>> > 
>> > On Thu, Aug 31, 2023 at 10:14:20PM +0200, Felix Fietkau wrote:
>> > > On many embedded devices, it is common to configure flowtable offloading for
>> > > a mix of different devices, some of which have hardware offload support and
>> > > some of which don't.
>> > > The current code limits the ability of user space to properly set up such a
>> > > configuration by only allowing adding devices with hardware offload support to
>> > > a offload-enabled flowtable.
>> > > Given that offload-enabled flowtables also imply fallback to pure software
>> > > offloading, this limitation makes little sense.
>> > > Fix it by not bailing out when the offload setup returns -EOPNOTSUPP
>> > 
>> > Would you send a v2 to untoggle the offload flag when listing the
>> > ruleset if EOPNOTSUPP is reported? Thus, the user knows that no
>> > hardware offload is being used.
>> 
>> Wouldn't that mess up further updates to the flowtable? From what I can
>> tell, when updating a flow table, changing its offload flag is not
>> supported.
> 
> The flag would be untoggled if hardware offload is not supported. What
> problematic scenario are you having in mind that might break?

The scenario I'm thinking about is this:
Initially, the flowtable is created with a set of devices which don't 
support offload.
Afterwards, the flowtable gets updated with the intention of adding an 
extra device which *does* support hw offload to the existing flowtable.
If the flag was cleared after initially creating the table, I think the 
update would fail. Or did I misread the code?

> In any case, there is a need to provide a way to tell the user if the
> hardware offload is actually happening or not, if not what I suggest,
> then propose a different way. But user really needs to know if it runs
> software or hardware plane to debug issues.

In my opinion, a single flag indication for the flow table is mostly 
useless. Much more useful would be if you could query which of the 
devices that were added to the flowtable support hw offload and which 
ones don't. That requires some API changes though, and I don't think 
that should be done in this patch.

- Felix
