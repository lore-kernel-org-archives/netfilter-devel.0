Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDD3F9D6
	for <netfilter-devel@vger.kernel.org>; Sat, 16 Nov 2024 21:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731791499; cv=none; b=Bn71uZg/2VxJr9Kx5CC91g0i/Zf+kYlkPNc3pHKcuR5spJWC+OkC3m0lz4K1pTljKtUppLqpIEFuugf9mdWDwmL9VTbEQNzawkQCYsZx9pXDszmnPOAiWDAGwO3QBJ54hKWgShQNCR0tFkdT+o6emM+8doAFY/IdvM2BWcM6/rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731791499; c=relaxed/simple;
	bh=Jja5oyLx+Cflb4/t1Z8mfccq/Zrs3NNCaktHei5QWv0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=HqRZVwzIdOnCpA/d/PA0ulFhmpW2mq9vP/Vtqo8hKh9LPUKXHkCGL27lR6I8iyxCfg4jJTGylaTudCN+h1XhqOxnvCk3RVi/sjYXFpY1LcY3gy8czl+wadpixB70zi1GFZ1t5p6qVxAsfsHwHrMDlvT9LgeNTYGDtB3WbBRuMnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QkPDKGYm; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QkPDKGYm"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9f1d76dab1so500220766b.0
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Nov 2024 13:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731791494; x=1732396294; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Jja5oyLx+Cflb4/t1Z8mfccq/Zrs3NNCaktHei5QWv0=;
        b=QkPDKGYmpAEyWS2XPOThKFY+r/azO9XSAGKH2tpVjmJqJVG7uYVw4qlT/1zoeZwb5I
         TZcZPeRNSwHA10pbAq/2+joSoyYq4p59XOEIl8P2kuLzzqLs6WPL1Cny/aNlbU+5LnOC
         H3WbARTLoDn2XHxaSb7qmri8LTM82M8H0lVwJ+xOTrKYeBAHCt75XJBQo9hUXE26ENdI
         sVlkptnmNN8Auj4Hn4h0qDOT8LvZAP6+KgXu98QyqTIwCRRBfevddEerQe9bpMy4lnne
         TFAWYNSiPmY6WHIURmo8xX6K7nTrIRfbNtVlRBog5EiGnmWPQ/cNF1a1QYMd7rCfWLP+
         Wecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731791494; x=1732396294;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jja5oyLx+Cflb4/t1Z8mfccq/Zrs3NNCaktHei5QWv0=;
        b=NTqtIrCGFk15pr0xqF92ABUrOL906y+iRSgGFXk3qqS4nr92O6YDHO/mYTfSfiXq+u
         j85AMYWDdD5DnC8Aizy7yRAjg2ejp+UHCHk9xHXc8v8qh2funW3yk7cMrnwi7BD+uaoL
         hxLl7e5xEso9gPr14TZF0tNnS+HTdiuaXgoByGbNRwiAJm63EoX+kiiRHaZnaUeVWtzg
         t9ahvsuePcMhtsPQv9BYJ9y0jt6OHXSt/5Ly+twZ6B2cqbn5mKVNqbGj2QK+Khmgi13F
         htpVCWa/6/w5wVyb7WgmjCpE/KLktylQhiIL3uYfJjJAYXjDAYo1vc0X8ybafad8AKvL
         FOZw==
X-Gm-Message-State: AOJu0YxydUG/xI9miL7hhNf3wYgFK7inrqcPZzDSX+yvaSyLzLeovSxx
	FWC90ERr7xYvFDhK3D/STlU4tzYuax713gMRp4dt/Q0xj8REyD3zbqE67lFAw6Nq0kV21vpywjz
	g2nQ2dg2l043gb3PYyH2R/QvvGCf7aLox
X-Google-Smtp-Source: AGHT+IHTUIwUO12/XjP6hCCuJ4pna27dK4K+1Hg7OKFtqlnRW6jRik0RF/9eP6m+B6BZIU3+V+R42vInJgRGP8A6sLM=
X-Received: by 2002:a17:906:6a07:b0:a9e:471e:ce4a with SMTP id
 a640c23a62f3a-aa4833e8cfbmr686503366b.11.1731791493893; Sat, 16 Nov 2024
 13:11:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jim Morrison <evyatark2@gmail.com>
Date: Sat, 16 Nov 2024 23:11:22 +0200
Message-ID: <CACSr4mSaw+M65HpZE+_Rotp=YuWugU9h0vokGyb-14pvoc+-Xw@mail.gmail.com>
Subject: DSA and netfilter interaction.
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In net/dsa/user.c in the function dsa_user_setup_tc() when TC_SETUP_FT
command arrives, dsa_user_setup_ft_block() will be called which calls
ndo_setup_tc() for the conduit device.

What is the rationale behind this design? Why isn't the corresponding
dsa_switch_ops::port_setup_tc() called?

More specifically, what is the conduit driver expected to do when it
receives the TC_SETUP_FT from the DSA subsystem?

It seems to me that the conduit's driver can't do much as it doesn't
even know for which switch port this ndo_setup_tc() was called.
