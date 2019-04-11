Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78149C10F14
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 13:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E29282133D
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 13:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=policy reason="signing key too small" (768-bit key) header.d=online.net header.i=@online.net header.b="r+5BydLm";
	dkim=pass (1024-bit key) header.d=online.net header.i=@online.net header.b="5QeqrPzH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfDKND7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 09:03:59 -0400
Received: from bounce-2.online.net ([62.210.16.44]:49506 "EHLO
        bounce-2.online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfDKND7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 09:03:59 -0400
X-Greylist: delayed 3290 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Apr 2019 09:03:56 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=online.net; s=folays;
        h=Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=lPJrWQ/+v+ZcnELUXgMHHGTb0gbjzS6TtsBgCdYW8U0=;
        b=r+5BydLmfi3sPM/nnPCYfSl+h47a76f/Z7x47WzuwyiwWRR5v1ELGfV326QWIpcK3M6iYY8XWwekEGR/+Fnm67Jch/18d6htGpjhQsS1/lZn9I02xXE2q9OT9ZLdRpu4;
Received: from [62.210.16.40] (helo=smtpauth-dc2-1.online.net)
        by bounce-dc2-2.online.net with esmtpa (Exim 4.82)
        (envelope-from <alban.vidal@zordhak.fr>)
        id 1hEYVu-0003YN-UB
        for netfilter-devel@vger.kernel.org; Thu, 11 Apr 2019 14:09:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=online.net; s=folays2;
        h=Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=lPJrWQ/+v+ZcnELUXgMHHGTb0gbjzS6TtsBgCdYW8U0=;
        b=5QeqrPzHwFYXAk0nWzELSVC6YLwncgUHmWsC+umBudogpMjEVk4aC6X0m6ujsw/OIgvbeobNaEk6cnmtxr1LRFXRIrPArwBSz7PupnHQTSpyIqfr62Qd4/sVcOxLmiws7sKSZ3Qyrzj/0wITFSS1fpHZz3rFGSQtRZO52qWUVrE=;
Received: from [90.3.255.61] (helo=[192.168.0.157])
        by smtpauth-dc2-1.online.net with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <alban.vidal@zordhak.fr>)
        id 1hEYVm-0005I8-5Y; Thu, 11 Apr 2019 14:08:58 +0200
Subject: Re: [PATCH v4 1/2] iptables-save: add option to show zeroed counters
 when saving rulesets
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, ao2@ao2.it,
        Alban VIDAL <alban.vidal@zordhak.fr>
References: <20190217235554.4647-1-alban.vidal@zordhak.fr>
 <9179b69f-3253-97a8-2dd1-f88c745068d3@zordhak.fr>
 <20190403182108.dhfo54lhosmm7373@salvia>
From:   Alban Vidal <alban.vidal@zordhak.fr>
Openpgp: id=AE48C0F59B1998A06292A69996BD4FF64E709FDE
Autocrypt: addr=alban.vidal@zordhak.fr; prefer-encrypt=mutual; keydata=
 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 3XJT
Message-ID: <a99123ce-83a7-5566-e5f3-289944e8a84e@zordhak.fr>
Date:   Thu, 11 Apr 2019 14:08:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190403182108.dhfo54lhosmm7373@salvia>
Content-Type: multipart/mixed;
 boundary="------------65435618DEDD66FBE5765663"
Content-Language: fr-FR
X-auth-smtp-user: alban.vidal@zordhak.fr
X-online-auth-user: FLEX_OENFTXFVRVVJbXEydzBzQQ==pfS37Gyzc1iS8ubo6TrtvFXVKDhyDQ==
X-online-auth-smtp: FLEX_Q3lRRzh1MlU0SUl1czZVbw==ugxH9KPr95a457fDihNBQWLodcF8+7vtnMet9U8AcQ==
X-online-bounce-smtp: FLEX_VUF5bVdvVVc0RTZzMG0wSw==HNTn39+8Z8NUzvyBUNcJfkrJE7Jxfaik9El7RabgKw==
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------65435618DEDD66FBE5765663
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

[PATCH v5]

Hello Pablo,

Le 03/04/2019 =C3=A0 20:21, Pablo Neira Ayuso a =C3=A9crit=C2=A0:
> Hi Alban,
>
> On Sun, Mar 03, 2019 at 02:31:30PM +0100, Alban Vidal wrote:
>> From: Alban VIDAL <alban.vidal@zordhak.fr>
>>
>> Add a new '-Z' (or '--zero') option to iptables-save to show zeroed
>> counters for chains when saving rulesets.
>>
>> This option is particularly useful when using a version control system=

>> (like git) to track the saved iptables rules, to minimize the delta
>> between different ruleset versions.
>>
>> The option is also added to xtables-save to keep compatibility on the
>> command line, however the functionality is not implemented yet.
> This patch does not apply, it seems your mail client has mangled the
> attachment.

I've compressed the new patches in the attached .tar.gz file.


> I wonder if this -Z semantics for iptables-save might be confusing.
> Telling this because iptables -L -z makes an atomic list and reset, so
> first time shows the existing counter values, so next time you call
> iptables -L shows zeroed counters.
>
> Probably you can use -z (lowercase) --print-zero-counters, so we
> reserve -Z in case we ever need something similar in the future for
> iptables-save that matches the exact behaviour of iptables -L -Z.
>
Yes sure I understand.

I've modified the options as you proposed: '-z' and '--print-zero-counter=
s'
I could not compile, I've an issue with nftnl library --even before
those patches-- I hope it will be good for you.

Regards,

Alban


--------------65435618DEDD66FBE5765663
Content-Type: application/gzip;
 name="PATCH-v5-iptables-save-add-option.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="PATCH-v5-iptables-save-add-option.tar.gz"

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

--------------65435618DEDD66FBE5765663--
