Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2112F3600
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773153963; cv=none; b=Ktq5tvrh79FmER4ESmxPvByObR3+mpoqtMwjqgkvB+hEXsehzkdOtVmlRBXpHfPL6aoRWbx5pQg9zAfvxtAevkwb+HmTA2ad+2aG6FUFb7j2TCEaxYVPZHYXzoK2TB94pXBZS6/V4jtpK7d1IZBACApOZq4Ax8edWfI49cWC0fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773153963; c=relaxed/simple;
	bh=HZlTBfj5C5jPnL+M+rmR7f/idHxLeIXhL3fjpbzYEY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U3lbki+6iEzZLwcIoziclEHHfdHxvxL1qqU6FHMjqNR6e0lCYe1q0uGPKs64zK9liVe2QntfkRejuTQreD8zamee3YftJFwjGr5xbnBWYBvf5tQ45e7GEwIFpsfxXe5JfEGwnpRTZLHfGDONcEsxc5afqt9xGgYkikPwR3cFQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bq3qnf1y; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bq3qnf1y"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-660a58841d4so9448371a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 07:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773153960; x=1773758760; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CWH3CMUFIFMeq8nn8KXOAOVclVcB6lNc+6mCHT889Jg=;
        b=Bq3qnf1ysiOSfsES55b5HcbXofKz+RvL9SM5lr5wSMfZBMLYMuwsuaC6FaVma2IUSY
         wlSlL8fgALpACPaFCoNbxfDlnsFXqX/J9VvbtuQKkKRMXxaa6pjfxL8oVLQoQKZR8VJb
         rKVzuy8UOYOdCvnxNNAqu+QC52blKdc8M4CnXs7S9Xr9mlipPhleIZWwtA4WQFDNkkwb
         0omPdA5yVSW9+zyu1sueT85q13SuSMMqy+aLF0kXLeLYi+sQ/hnOW1roeYRja2iQpN2p
         heSy6nDN2XPKdWWKyzGPcB+pzT4MY8tZa42xSUu9anv14MGlXj/wdPvLjyWqkn2kN9cU
         QkZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773153960; x=1773758760;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CWH3CMUFIFMeq8nn8KXOAOVclVcB6lNc+6mCHT889Jg=;
        b=tkUsFbIQrSRI+aSg79z5JIGxd086sjM4n+m5FfmAvnlMg8UDUWkABAeZwqR5BEdkQZ
         UiKU5YXB3Uj2243RscHxqXCk9qSs3edskI2Al/kKhuMUX5E3bFnGaXjTBtfkv8Xi9wvv
         PqM5rWsA9t1/5j5J+tV62sut41OXETynvIcZP7K4xwT8GhDukd/9H8HloAfoUU464CZe
         Om4vvnAxTZ6U/ZiF6MX6GDUpniRU+agsk1/pCLG6zy7mxoPFhxabDCxzZJPkGT5YQnFJ
         TPhuRlj2qiuTMW3wRjuKlY7/R06yMzteTCUiFqq0Xd6wK1GgSpdJd4sjtxjWOkVI9ppG
         ssoQ==
X-Gm-Message-State: AOJu0YyiKUay1QFURBgKnbPdOsXxoTwPrZ6QXlaaE4lIAd+6his78yh6
	5rDEOULYkUJ34YF8Vmtvx+yGXKiJ3Ho5oOioP4F2hmcaQ+q/usl0pS7XVXiFrw==
X-Gm-Gg: ATEYQzyQ+za8rejHFBd0EiM+PrzrXT5YbCyLhNSe8JPq8lFdXCcELCjWB5S61oPeStQ
	SbSw87TpgVnY7WAAALJ5Y1mH+ykk/GOCORtii8waSIqqq1qqQLviwiVoF3VDRfanmaXKWIQT9rh
	NRQc/aOamxkOQqs8RiBYM5RPfj0Jzfrei6kipVTOUb+JiylZqAzszrapUEqiSh8MoVnsNNtKMxa
	Jd8wLr4ewsFXWsQq2oW/hH5lAtgD2JgyGVEe1M6SLBCiHSKvXmE43ETEfJZCZDHy/qOIPLd2KD2
	blXqZn1TsccvrB1fnjJB+l7fPJQB+NLKXsLk9Cr1sJhHps/q7zUvyXD7IaVw4er322O0CeGfD3A
	IC4xOVbG0uHvRQpNvEU9zrMrqMcYBG5ObkCrCFt7TH/jtXs8M9XygXcFlL0K5bJdtzp7zN5gvx0
	Z4xFpntxJgl6/9oAV6awADYGFp6YjBORi45Ed+6p0Nj4Zc3VbMlmlXIrnSuTU3NONHLliJPAq8V
	adspjYQy/32LGKHuJCjbRRqpaGOIJjXLuD41fbQJ/6+MWVFIDfu787LVjh20R1KzIf28xSgc52D
	yeH3psnu/+jDh9HjHi8FItyD+ExQ3rNO7Q==
X-Received: by 2002:a05:6402:398b:b0:662:e9d0:6248 with SMTP id 4fb4d7f45d1cf-662e9d06433mr699467a12.31.1773153959901;
        Tue, 10 Mar 2026 07:45:59 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-661a2b801a3sm4432325a12.0.2026.03.10.07.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:45:58 -0700 (PDT)
Message-ID: <58cc080e-1e55-4a51-8c3c-16d6b87794b2@gmail.com>
Date: Tue, 10 Mar 2026 15:45:57 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 nf-next 5/5] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <20260224065307.120768-1-ericwouds@gmail.com>
 <20260224065307.120768-6-ericwouds@gmail.com>
 <76b3546a-37c5-4dab-9074-4df0cbe48524@gmail.com> <abAOwZDmHjcLIbj1@chamomile>
 <f69a9456-5047-4044-aa8d-1bad3bd81f4b@gmail.com> <abAcBtV9WbEIDgCt@strlen.de>
Content-Language: en-US
From: Eric Woudstra <ericwouds@gmail.com>
In-Reply-To: <abAcBtV9WbEIDgCt@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/10/26 2:26 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> I misunderstood, as Florian pointed out he is waiting for a response on
>> the AI generated review.
> 
> Yes, I also try to keep patchwork somewhat up to date.
> 
> If its not listed anymore, its been dropped from my radar.
> If its in new or 'under review' state, then its still on my list
> and I will get to it.
> 
>> I now understand it was not forgotten at all.
> 
> Well, it was forgotten, sort of.
> I depend on patchwork tracking (and on submitters checking
> back when they are unsure (so this ping isn't bad)).
> 
> Would it help to add a netfilter process document to
> Documentation/process/ to explain the expectations and
> nf specific patch workflow?

For me, most is known, as it is probably not very different from other
places using patchwork.

What was new and unclear were the AI generated reviews, and what is
expected in response of them.

