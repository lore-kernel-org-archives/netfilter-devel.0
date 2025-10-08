Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0629C292938
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 14:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759935044; cv=none; b=M8hjx7Tvi9hlK63keVgHrCAAQwmIfXVGGz0u37uo/GzmLMAKIzztNnLKsP7UhlK34lECGICjDe+PM6pcmrLTjwaC1WBGCiaPUh4u/JQgbNHhenecHXlzzj/EmcB7xvvGLZSEWWiANyHgq+s3lJBEpPWzzqWY9LiMoIdS0Risnco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759935044; c=relaxed/simple;
	bh=o/EXyq+fAg8rxI+xeSgSz9HDUXUOJB7OOxKBpywUecI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gxHJiuUlHh9/zZBbYubxwQETOjiWlIsagsAy1Exp0MbwryPrhUIqSRkngNO4i/rlfVV3h2Pe9POV1VPRNy51MBI0mYJDKOU2rFqCPNRqzvE7qZ2lDuDOk/hv32yEAwKi3lgWXBYrOKOfEHKWpzhs8f0lhi/QvY4rUdsesyTFDZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AimtL1Rg; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AimtL1Rg"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-4248b34fc8eso76999515ab.3
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Oct 2025 07:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759935042; x=1760539842; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/EXyq+fAg8rxI+xeSgSz9HDUXUOJB7OOxKBpywUecI=;
        b=AimtL1RgIIWJ52sj2FxoZxeFdY6/vj+wBeW6v5LFQJ98kjiLMkAQB6YRnpSZXss0Kg
         b3c14IBsuf3CxDHW4qOAsnzVwI6i3UmTx89SFucrFVJ/oHVRfKrqCzpzKETCqqvxNSQP
         hPn0ZZFULYVRQKZMTEUfjkZO5eHOvK6niioT0fX8+GcWK2RUxyFZBqkQUK3HiPvHQ8Az
         e2pGrVXSZ41AD5Ya857wf8a67CPmIBUDOdYv+s8QxlLRjOvVGGyz+ivFldN6zDvGpulr
         gVEbEtJjErSD1+yACqJJsZTfVvKvkYbXZhjhmZvLOlVN8TqaiTzY6uREkhKodS9JrVJ/
         25cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759935042; x=1760539842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/EXyq+fAg8rxI+xeSgSz9HDUXUOJB7OOxKBpywUecI=;
        b=uV/h8L3EtY8VIYrL7814pFz55vPTDH/ZCo8AuV/+Oqlnp8m9Fd0PbUgexYYJaNb3H5
         Vw6aIlu+v5ZcLZmvQndBcna9Xo5IJeKZB5R4BW2d81urmeX+yBdwoKSZmw9hL+rywDc8
         wGJn28E2pbY5MnF3kSollk8ZAPel2j7qs+7yCTi/vQOkB4278jYstdrQ31e1s1hxTfYr
         r+hmkqkH3g1NtSVn48uKXfHP7ogWvqraFEevgBcfiel6dewYXuSawD5gGVl1YJUlrdaa
         QAqDec1ddO6dAATb1t4LyJtrfxsTlHWYy6e5NGFUEjJf3hEWofGbKog2jIhED8uV9LTl
         yfvg==
X-Gm-Message-State: AOJu0YwMeW2W4XgG3jl+5CenMh0HM/2Ppg6dgRp3neza0CbpcPHJ8ppi
	P2bOXhh8WXGyvjrDC9HabDJd6HT9VYbu2j6XnpADBpCvVZa4qqV5fcHDWKgNLvHCQlEJOpYi7fD
	7uIbk5ieGqqU+DsqGlEAYz0MhJf+vSlbr7eED3v5cFQ==
X-Gm-Gg: ASbGncvy9kQ9zWJ3Ai042HamsK0972UlwTNCilbSbzV+EuRoWZBznLOvYxFFNfwlPhH
	u15mbmR9mi9IsJB2yw98mX6C5058ja4AH8qd8mw6JTsvGWPT6jkcUNlJ4kuOXpVLoRVTzB3MIcr
	PUvvt7P/lQExy/IVBLdwUyoCOdOrXxeoTkrm9owQM1FWafzJIwjV3ZOSn1bTBNQ/n0DhWDz7Wg8
	16fnPFDGzHPI7mgCzV2irDBk+agmzV/65Rjf9io2bisVuHmFir6NqkVHuRTOKVxOWMzre4hub3p
	s8trRIWLal48Nozl
X-Google-Smtp-Source: AGHT+IErGgAq5I0S9zyOgHG1LRc+RgnTXaShIKguaOceQWRki2x1p89stmzN/UXBPpA+oyptctwKvMyc0CIzD4FBAUE=
X-Received: by 2002:a05:6e02:378c:b0:42d:5d48:acb9 with SMTP id
 e9e14a558f8ab-42f8735064amr31217855ab.7.1759935041762; Wed, 08 Oct 2025
 07:50:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001211503.2120993-1-nickgarlis@gmail.com>
 <aOV47lZj6Quc3P0o@calendula> <CA+jwDR=hSYD76Z_3tdJTn6ZKkU+U9ZKESh3YUXDNHkvcDbJHsw@mail.gmail.com>
 <aOZGUPMwr5aHm66x@calendula>
In-Reply-To: <aOZGUPMwr5aHm66x@calendula>
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
Date: Wed, 8 Oct 2025 16:50:29 +0200
X-Gm-Features: AS18NWAvsAsSt5RlyB788j78FS8eIERc6285FmeEzvm4aQfIWuw6u8sEni5QZWo
Message-ID: <CA+jwDRnM=x2U-WOEEG+Ng3DQFPxy_ZM3KGDog+XaqXzCiAsEQg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi again,

Thanks for the detailed explanation. For the record, I am not strongly
for or against one or the other approach but I do think that my
approach is something to consider if batch ACKs are to be supported in
the long run.

> In netlink, ENOBUFS is not "fatal", it means messages got lost, but
> there are still messages in the netlink socket buffer to be
> processed, ie. the netlink messages before the overrun are still in
> place, but the messages that could not fit in into the socket buffer
> has been dropped.

Yes perhaps in this instance "delivery" error would be a better
description but I understand it's not an error in applying the batch.

> For this nfnetlink batching, use select() to poll for pending
> messages to process, and make no assumptions on how many messages
> you receive.

That's an option indeed although the library that I use
https://github.com/google/nftables is unfortunately limited to blocking
recvmsg calls and this is why it has to keep track of the sent acks
and validate them after. I wonder if there are more cases like that ?

In fact, that's the reason why I stumbled upon the duplicate ACK bug
and attempted using ACKs on batch messages to work around the issue.

Additionally, this library will dynamically adjust its buffer based on the
expected response size.

I appreciate you probably don't want to make architectural decisions
based on unofficial library limitations but I thought it might be a
good thing to mention that.

To make the discussion clearer, I think we are referring to three
different scenarios. I've outlined them below for clarity.

Scenario 1: Success

User sends:
Command1
Command2
Command3

Kernel replies:
Command1 - 0
Command2 - 0
Command3 - 0

Result: The batch is processed successfully.

Scenario 2: Failure

User sends:
Command1
Command2 (invalid)
Command3 (invalid)

Kernel replies:
Command1 - 0
Command2 - EINVAL
Command3 - EINVAL

Note: The reply for Command3 is still received even though Command2
failed.

Scenario 3: Fatal / Permission Error

User sends:
Command1
Command2
Command3

Kernel replies:
Command1 - EPERM

Result: Indicates a fatal error. Processing stops immediately.

Now let's add BATCH_BEGIN and BATCH_END into the mix.

Scenario 1: Success with Batch

User sends:
BATCH_BEGIN
Command1
Command2
Command3
BATCH_END

Kernel replies:
BATCH_BEGIN
Command1
Command2
Command3
BATCH_END

Result: Consistent behavior. Full batch completed successfully.

Scenario 2: Failure with Batch

User sends:
BATCH_BEGIN
Command1
Command2 (invalid)
Command3 (invalid)
BATCH_END

Kernel replies:
BATCH_BEGIN
Command1 - 0
Command2 - EINVAL
Command3 - EINVAL

Observation: This seems inconsistent with earlier behavior. I would
expect a BATCH_END reply here as well to indicate that the batch
processing is complete, even if errors occurred.

Scenario 3: Fatal Error with Batch

User sends:
BATCH_BEGIN
Command1
Command2
Command3
BATCH_END

Kernel replies:
Command1 - EPERM

Result: Matches the previous "fatal" case which I believe is what
you're pointing out does not make sense and would require further
changes which you don't think is a good idea to make.

I=E2=80=99m not trying to push this change, since I don=E2=80=99t rely on b=
atch ACKs.
Just want to make sure we=E2=80=99re on the same page.
Let me know how you=E2=80=99d like to proceed and whether I should update t=
he
test patch.

Thanks!
