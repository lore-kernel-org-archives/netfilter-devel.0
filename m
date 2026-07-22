Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1FD2F4A05
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2026 05:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784699826; cv=none; b=H6zBhjQ/mU5ZSM/6K0oIXEd2/Z+LhyYHEl9Y3D2v9F5fQO5Jy19GtcsQgNRxzA7uX4RpxWAmwf/ilbkOS8lYGGs93SYH/Gn6MMeDnlLLkO/SuO0JKR7DnCltchitWTjG4lzjXyGa+mSgYGR4RIjjoDZo0jXyMGYBnY9Wj922B1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784699826; c=relaxed/simple;
	bh=YKC57Tn7V6O6WggFRnULrGIV2uWfieJNXcI/UdE7HsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uE6jbhr/DQrglsg293sjFxEVXkq2v7A5uCTAeRElfyU11Z582yMhmJtjGUxwDh8UgxLT41E+qp44aW6imNv6BeURLweKRmYk3W6UC9CKMjB1aKzXQEwB7JjTKNeRKY0yMg4bvX4Ahl7GTLcJ5s9rt2vHFDGtMYxm1Lx2cevTckc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MK1Dce5Q; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MK1Dce5Q"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-495437bb891so47399975e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2026 22:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784699823; x=1785304623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ttX8FXTnAt6zLrk8P+jdetam2dCFEWqzZxf9WP7T3z8=;
        b=MK1Dce5Q2XcFqoQ6bzK9LViIlEw86ZodE+eKy5wxtgusgDMeE81+v0AkfN6CYZQyxS
         wmXM3SaHnJDazjhUGfCK5f1ax+YMvJYXnFcQXljr4mj3UEWvtlTBJZ0rU7JNptQWOiyt
         MoX/NMz5TrD34LHREJhCYXiHhmzeEnH/TNe0Uj4dfCWwmMAFUE8Ta4yV3VKBFaLYU563
         8014WkhkCJ7jp0x5Xkqlw3gVrB0Sn3PyJI7BBQRS/uDyfnth8r3AcQqGCN88ii3porth
         8KnEeSTX51bbqBSY1hlutupLHpss0I+lS4hiYjSR+erHMzc6UTVHpCbzuoRxGpDweBYj
         ImDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784699823; x=1785304623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ttX8FXTnAt6zLrk8P+jdetam2dCFEWqzZxf9WP7T3z8=;
        b=Eq5ZG1kz9t4H2DmSOmPxoZA01jFNfpiG6gOkI/Lamdo3rQTJBFCZGFV9BRDstHTUER
         jvaUblA6bqD0TZPUjkPosjjE3Dj8nt9B5pdZGzgXXiGdHq5FlML/dBKgHoFgUk22sOhl
         1an4vlq+EQJDdfd1Ja991VqulbODoa5T0iIOkomf5sWNwnn1/DWXq5BHiDDRlByI6YN1
         KXDHEbOFgbELEvCLcy2qMCpZHChswLuH/zLT1DVgI2//pWmyNQ5lvz5ZMKG3+S+/+YLZ
         ZnK+CiZ0lHxtxX/s7+8pKbGDcpGdsZ6hNcxKiOwUQ8LfxV0Ur44ExXwhy/FM3sm1xyuB
         qj/A==
X-Gm-Message-State: AOJu0Yz5C2lxe2supUjSksn+u45JddFPQRCTkqub73zWdwVrGwNKoS+0
	qylOvrRUfOlz1s5wkQ81BS3dvi2a9uD6S5t7hPmMO7y54ig/4xx/LRjRF1zj4ZelUM45zw==
X-Gm-Gg: AR+sD12CU1dmxt1fjD76X1478cGSG9YTOiMnDzxC/83Tctjapf7BGPi6cld86n7Ohhy
	pNDZH/5SpNdi/EodADr0jgaduUrVGXE4mmUGyW8knGQ/UwoSivNUVFJw9AnE7kJu6+1wfw+b/Up
	qjMQ5bsPtIkPaD0P5tG4aTG96sAopSifX0QUnaf2wO8Y+unm7ISbeFb1P+sYXsSavBn1+zub/pr
	SSqsA4qHqdJnvc/jFjW5kONnJrkbhDSChL/bregaB7rpsITp0Qff7iG4fWrGo+I6j9DrZwdneRP
	KXqhAGTx3JP70HrFRK2bHFejMd1thHcZ1xFCESyQyVIVEeM/YUZafB8aoZDHDSSDLJM/yhkalTM
	BdFIYRb4XJOx7w1YKtiMe84odbwF/2viORfw2uSNjfEhdnMrPJei2MoWtUo7Sk2MnO43FG/ysDV
	BWuddLvMl43wzTzaT8p6HEnN6Vik04QP5nP6MY90aD0DuaR1vESGmlrea81AVROEppr6tNgw7Wv
	v0DgA==
X-Received: by 2002:a05:600c:3107:b0:495:648c:a1 with SMTP id 5b1f17b1804b1-4956a4ee0bamr28436545e9.3.1784699822645;
        Tue, 21 Jul 2026 22:57:02 -0700 (PDT)
Received: from DESKTOP-VQ38ID8.localdomain ([85.153.228.203])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb5a46sm2950671f8f.9.2026.07.21.22.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 22:57:00 -0700 (PDT)
From: Talha Berk Arslan <talha.anything.info@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	Talha Berk Arslan <talha.anything.info@gmail.com>
Subject: Re: [PATCH nf,v3] netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH
Date: Wed, 22 Jul 2026 08:56:54 +0300
Message-ID: <20260722055655.654-1-talha.anything.info@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721205256.28769-1-pablo@netfilter.org>
References: <20260721205256.28769-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Jul 21, 2026 at 10:52:56PM +0200, Pablo Neira Ayuso wrote:
> [PATCH nf,v3] netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH

Hi Pablo,

Sorry for the delayed reply, I am based in Turkey (UTC+3) and saw your v3 this morning.

I tested v3 on Debian 12 (kernel 6.1.0-50-amd64) by building the patched module against the 6.1.176 headers.

Before patch: both a rule without XT_HASHLIMIT_RATE_MATCH and a second rule with XT_HASHLIMIT_RATE_MATCH sharing the same table name were accepted silently (exit 0), leaving rateinfo.burst uninitialized.

After patch: the conflicting rule is correctly rejected at .checkentry:

  iptables v1.8.9 (nf_tables): RULE_APPEND failed (Invalid argument): rule in chain INPUT

Tested-by: Talha Berk Arslan <talha.anything.info@gmail.com>

Thanks,
Talha Berk Arslan
Artfical Security Intelligence
