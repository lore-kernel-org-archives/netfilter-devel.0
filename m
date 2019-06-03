Return-Path: <SRS0=Me6e=UC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2BFC28CC6
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jun 2019 09:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E6C628020
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jun 2019 09:40:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="Inh5mDIJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfFCJke (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jun 2019 05:40:34 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:40814 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfFCJke (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jun 2019 05:40:34 -0400
Received: by mail-wm1-f44.google.com with SMTP id u16so5053803wmc.5
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Jun 2019 02:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GYzaKSryFkfhjuQK88NWJ7iWek8zyptGyqPn6HQSwRc=;
        b=Inh5mDIJpwsrVxoeUPthxQgdKt1/nP6Ct2FFAZSRLdJc1MpHeGVLL+bPZFzCWefgj4
         i+bu74xi9q81WrjTB0Jx4GJ8YQ19TR5/CzjT/qt8hLQKNwp0mjfHlOJfNM2gc0pRhmyp
         vkN42zewivEPqJyC6k0mid9cPt0VUmpkMQLixFY2Ya5TuFbX9McI0MeCQNF5jRs8D2uZ
         4nQ/z9qGk0ZVX07eLmfzNlAUygNh2gCMhgLmpWpGVNncJhgS0o3XMIGuhlg4PprGdaH7
         F7xyF9ez5JB3N2KwU8554qiHqx/C6VSt4vIvkgz2UU7GwRXo3aZxm1OMIw/st3AXeC5t
         7URQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GYzaKSryFkfhjuQK88NWJ7iWek8zyptGyqPn6HQSwRc=;
        b=Tuumzo9GU6OMyod3k5Pc2X56gPN3lt7B3R6+AIblJLKowbHp6IrVb72miSoUyizd8K
         wLzC9nAvDdMqF+sylhU+dEm8vLiKWuA2JpVxqi9WHf3ufeDWHzzl6fnxHpRu0LYTGYtz
         IT5Du3DG3p5PchgfYaoBoMyImDgDSw0vpgk5e+cGGRNuus8PKsGeT84MwI7syMGY4y5d
         hIP03VVJK0wCib3twypxli8Ys9AYFGiBBkBaj9DsDOotxpXLQzAqt1Gxili3tNztAvFO
         7mldW0WpAGf2Lg39V+nA8HtanU/5vPUIVOcHyuh3KFQlYvVr5Nkh3w+2YvKRwSZCrC7B
         dNxA==
X-Gm-Message-State: APjAAAUHf1mWXXtQDQN+f1vIHxIYVrF5lI/qygWM+nMameKVadsDWT27
        cPd9UXsj9hlisrz9uJOYMtzOBFinsYk=
X-Google-Smtp-Source: APXvYqzpibE5/yen1M9IS5VlYp6wLU4wAqO4UMZbIPlWsWN+kVyLhUgh/cfYoF61+/eCAobVNxHx+g==
X-Received: by 2002:a7b:c001:: with SMTP id c1mr13660426wmb.49.1559554831965;
        Mon, 03 Jun 2019 02:40:31 -0700 (PDT)
Received: from [10.16.0.69] (host.78.145.23.62.rev.coltfrance.com. [62.23.145.78])
        by smtp.gmail.com with ESMTPSA id y12sm6457970wrr.3.2019.06.03.02.40.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 02:40:31 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: nftables release
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <65ec483a-b8d7-530b-373f-6dcdd5f668c6@6wind.com>
 <20190530211628.lxufmb3gqizywkxe@breakpoint.cc>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <9b87afde-8ae5-2d06-f90e-e085dc797ade@6wind.com>
Date:   Mon, 3 Jun 2019 11:40:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530211628.lxufmb3gqizywkxe@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 30/05/2019 à 23:16, Florian Westphal a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>> Hi,
>>
>> is there any plan to release an official version of the nftables user-space utility?
>> The last one (v0.9.0) is now one year old ;-)
> 
> There are a few bugs that are sorted out right now,
> a new release should happen soon once that is resolved.
> 
Ok, thank you for the answer.


Regards,
Nicolas
