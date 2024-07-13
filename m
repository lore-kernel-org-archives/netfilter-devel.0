Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C9933CD1
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Jul 2024 09:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720862810; cv=none; b=kaiWi4PLnhg3U5lIrxF+16PI1v5fhuObJQ9cZbv+iXyhh4WYZRVcE7Lk56RoNjKNecdPeVqEu37wq9TaAab8+am7NwpWk8TBi4pWhdI/1mOatPRegT5pjuxoJgn4AjPApHtbOLhwJZB6aLI2pY6GsdNjQpm9jUF2c/IharE6VBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720862810; c=relaxed/simple;
	bh=wcPUv0c8oo1hwL1hbjmWde9oyqsIkiYNaNChtxDyrcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=adIvqWi4yvns3amubWyc2WWBO9143NTjqg7Htbi6JTQpJEkxcs/TbuuEqKbFMpCa2WGeIf+KC71ItRNiVXF7BNbxhpGmHndnic9Ucat85bx9CsEiiv6WCMoiDBX/Si+T8ULPkrcuWvRaPUT5Mil3CCJ6eUaRr2ng6Ef9d4OlkpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FmECN9w8; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FmECN9w8"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2eea8ea8bb0so52555621fa.1
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Jul 2024 02:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720862807; x=1721467607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9wWU4MbRQ7o3YxrvfXzmhID7vYnLUYZtSlf6G41L7o=;
        b=FmECN9w8GLRapYhy8pTVN8Lp/h/i4/Yd7lrs9aC+d/y9+i61UWlkcCCvr6f+XfhKLl
         dg/1bMDbLP2l7pV+aK7EVDVVyS57w1XP9c0j7bLK3FlfBiFfDmUCk9mwa7m0c3nBjMvT
         e2TKibCDvBSGTz2Zu2nTHLT5rI7VU6P1wyX3jWTgBCe2S9eatmd23oDSg0ScncCfNcln
         UiKAQXOi2mO9f/FsyQwBso5qRekhYGjv1LQrtfLLwYZmPQZ3szE3Hv5SqJf96eFrB8dh
         Xv0lN0Slg4xKHbDqGluBWaiidIySiJPifW2Wh0kWakW6ACU3iE7OHrjCer/m6uPm8+h1
         gkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720862807; x=1721467607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9wWU4MbRQ7o3YxrvfXzmhID7vYnLUYZtSlf6G41L7o=;
        b=iLCw4EwKSkxjzQkbQI1s/LIvnmLxTvZijLF6wllfmZ4GNwA5Y1sLjlsh1pVYvOTKV0
         CRviXVAlExg4FJNGMSQqUKgxAh+TJ+2CXLa0bg1ODGstLSKAuhQoZ3RRXl6BObQTSnwG
         2YLswGaqTcpiyiq3CHZXG2dlc6JYMgrPKtraYat91KiPdY7o/Y6v3El6bxpgI/jFmv/7
         O9InqWZmBGUlzWldEFUMTef1YsllzAuBOwPQUM1aSPUtHp4WryquZL6ueic6dwSkqE29
         PTKJTXVjZleJ2iiDNprpA+Te/sHCkNw5a8vdhjj55GPv0Lp+w37ShtiF1sWM0P17kT2O
         QBAA==
X-Gm-Message-State: AOJu0YwAwdpevlAQ6kwzX2O7bhgsY0maHZ8QBowuFEtiJfyMaeC15Sa4
	MzDYHqo4QXDutWyLQyMaenxAd7sFEQswnFAZddEOQLJA2uD2RXnm0gVIFQ==
X-Google-Smtp-Source: AGHT+IHAb/2KaVjgiGFFsb6DLWcg2Pd4B1/QiE7zeElqfJKxEZasc0NHKmcQKaubT+M+/E4YYzMfqA==
X-Received: by 2002:a2e:97cb:0:b0:2ee:7a54:3b14 with SMTP id 38308e7fff4ca-2eeb30bb388mr116008161fa.7.1720862806390;
        Sat, 13 Jul 2024 02:26:46 -0700 (PDT)
Received: from localhost.localdomain (shef-16-b2-v4wan-169484-cust5160.vm3.cable.virginm.net. [92.236.212.41])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3680dafbf4bsm928381f8f.73.2024.07.13.02.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jul 2024 02:26:45 -0700 (PDT)
From: Joshua Lant <joshualant@googlemail.com>
X-Google-Original-From: Joshua Lant <joshualant@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: duncan_roe@optusnet.com.au
Subject: Re: [PATCH] configure: Add option for building with musl
Date: Sat, 13 Jul 2024 09:26:45 +0000
Message-Id: <20240713092645.1110654-1-joshualant@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ZpHVYBPB5rPAIw6k () slk15 ! local ! net>
References: <ZpHVYBPB5rPAIw6k () slk15 ! local ! net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MARC-Message: https://marc.info/?l=netfilter-devel&m=172083336211283
Content-Transfer-Encoding: 8bit

Hi Duncan,

>On Fri, Jul 12, 2024 at 12:38:59PM +0000, Joshua Lant wrote:
>> Adding this configure option fixes compilation errors which occur when
>> building with musl-libc. These are known issues with musl that cause structure
>> redefinition errors in headers between linux/if_ether.h and
>> netinet/ether.h.
>>
>> Signed-off-by: Joshua Lant joshualant@gmail.com
>> ---
>>  INSTALL      |  7 +++++++
>>  configure.ac | 10 +++++++++-
>>  2 files changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/INSTALL b/INSTALL
>> index d62b428c..8095b0bb 100644
>> --- a/INSTALL
>> +++ b/INSTALL
>> @@ -63,6 +63,13 @@ Configuring and compiling
>>  	optionally specify a search path to include anyway. This is
>>  	probably only useful for development.
>>
>> +--enable-musl-build
>> +
>> +	When compiling against musl-libc, you may encounter issues with
>> +	redefinitions of structures in headers between musl and the kernel.
>> +	This is a known issue with musl-libc, and setting this option
>> +	should fix your build.
>> +
>>  If you want to enable debugging, use
>>
>>  	./configure CFLAGS="-ggdb3 -O0"
>
>Niggle: Since at lease gdb 11.2, `info gdb` section
>'4.1 Compiling for Debugging' says this:
>
>> |   Older versions of the GNU C compiler permitted a variant option '-gg'
>> |for debugging information.  GDB no longer supports this format; if your
>> |GNU C compiler has this option, do not use it.
>
>I suggest `-g3 -gdwarf-4`. This enables gdb commands like `info macro`.
>There is also a `-Og` option. Personally, I'm not sure that I like it.
>

I have not actually added the portion about debugging in the INSTALL file,
just the stuff above it, this is just included in the generated patch file...
I added the new configuration option information above the debugging stuff
rather than at the end of the list, because logically in my mind I would want
to see all of the other build options, and then at the end see about debugging.
Last resort if none of the normal build options are doing it for me kind of
thing...

Cheers,

Josh
