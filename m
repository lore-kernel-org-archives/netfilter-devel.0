Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793521049;
	b=U2s1buspdfb9p82oISivM9pxvIonJ/MwQ5K+rDqW7/KETrZWUAbppYeZ1e9MdhQk9cOi
	 gV9ryhC732WYtRMQK90wnVckumRjICWwdbeo0A0fTDSeCHj6Vg35Z9tOxM1MoHuJlSTJi
	 397qUAn9Bx/7JKMe67mUhMwnqhhJd7mt41rgrNsyAvU8iXb8VyhpRRkU9KIhJ+oheXby6
	 1aRwZPkNsej+uSLI7k4RufzoxtcTMvninDGmyPviDxGUXT94ozlAGUcaw0cMWy8P+alpC
	 BG9x7DPTRr2su6M1UvPuKx5io8+6QdHTbQLqdENAhLs9v9l2KxW5FOFioAzC0PAWbfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793521049;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l+hkzwCpvpQgrUCpeG4tt9OeGdPww69ynoVOKpj/83A=;
	b=Wb+/Xsvp6MzvMQUDfQ7i/69wjqhcHk0PCG2MehTAnv9c03kDt4w1CZVrcppWGIk71jUn
	 EZhfTuZWBbprAAsu8peTkFUjQPja8+EOXW+xJos4+g70vO2TXVNyWDheLy3lipoSG0VGv
	 kpYk9Dch2RtoqE1jB1Ex/mrElFXp0mbIdK6fEOO5uE1zau5AodicBGeLAu+bOm6rZ6YT7
	 9m68VNlB1gzTe3HOLpOmLA96fE5s/tNUFH0H680k2JgpTEM9N/6XMLrDaVVgQLtEBTEW0
	 s5WXbmQZ+DE20hnSRtpX22zaV9DZawFpPiMa7w34z2t6kEAg5ZBNqLF2mCrPBi8qcGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r1O5o+j+;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E9A606A325
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 08:17:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3E9A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r1O5o+j+
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdb15cd8558so233701a12.2
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 01:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793521048; x=1794125848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l+hkzwCpvpQgrUCpeG4tt9OeGdPww69ynoVOKpj/83A=;
        b=r1O5o+j+DhaI1igvj1ETrTNrpYZ4cW7jYwzRRdbtVjVWvaxG4RWlyY/0yxooMG6oTM
         GhBDtLjgO14j1yftZzCs7YZ+HAlbiKgM3P3rqT9J376HwsADT6SCjVzOQXqFRRk4s8mm
         uj0Pj2m+g2/VdMprvzlKdSo+V8fGXPY8aVXSyghBHBje+0X3+oMZfquTdCMesEK5H98l
         SRiiWtYUoHKSZKwQCgc3M0WxmwYWnj38TiBcxOPN7v6XyVXIEiXci/Esr31TMYUnVBYx
         AoFyn9XAZt+5Al8DUvymg5xtNNNtZf2WWAjGPCTqMYmNoLPFzGxvf7bjLnv2gw0frPaH
         8M8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793521048; x=1794125848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l+hkzwCpvpQgrUCpeG4tt9OeGdPww69ynoVOKpj/83A=;
        b=rwFk+z7O1kuLZdYmCagQpMReXWgPA24cnY4JzFrCk3nYjYG7wlyOLPJCVn7Zc0xPEu
         lCYGyQiVnEAgcRFGxr1tZzmNLHwX6EFVrk9saf6itlJcLFiwG6ZY9GvwMeAn1GP0T2v7
         Fu9VQ+wVmkuCNFVmqaTnX+3A/+luy0C5lSohYJzqRuA2MlqGeIbc9TiNwBJ0j5P/2/yW
         5b3iby7EE/71ib8/SdlXgYH7sYLbKV1KmfOduJe9Bw+Y8j3l9ehy5/jFwAETu7YHkpKk
         Mu/Fzjxz0gUBnzrUCKb9Uc6zaVWV1iAeledM2g5gB6OjKl8kkSXBcLuOHeSec9toMaXG
         Czyw==
X-Forwarded-Encrypted: i=1; AKwUvBxpvQI2MfN7M+/Pw8jhTou7HMqnUQ8xaDoRzaIzfGiQENw1nVc2YzP4xmraMmYDYYt6mwNmp+CM81XuEk4y6g4=@vger.kernel.org
X-Gm-Message-State: AFq9FYKOjv1bUNsCJR6R5bnsS7T4uTMM03CROc6M62qDjwswKSx4rnwf
	3yx9rFywayYFABfDXnc33BS8uVgc1oJDO2kZz9vDYn9ncL+YaiGAdCN7
X-Gm-Gg: AYBFou0NkLmLD1h8vp1ZRMi3ukE8FEYTz9cJbFF7za2k+UMMXP/XtlXfpPu+riv3vca
	Ap0TD3sIAjSGc1JoR6IdwHqG2yPjKofpD67VRSfAP530jm+3Ldihv3RDWkZjB/JpojvsU+NmgxO
	LD9XMEAdBImkjUlSncNuRVf5dIYukmRcMo1E4zdYUHH0uD9O+T9vEx9DnC+MGbt5vPQVVILPK+I
	BxEEdPGskYRo/QsUwHVkWKwnB7ca474QE3TqprVt4K1M1UbEDPU09u0xA4SE0PGRex0NvaizdcZ
	AIUcMBg0sCcgw4tNaGwGHYYaJeMIi+OSH6XD1j8L00NpySoy1pvje2IYlaLLZmFWyc1MABxIRsv
	5a6+o/660I76wG83bUjDUkr56xyyUoG9w+PrmsSp4xjUkThbsec+ZU+3QD3wRlJzZUryYObtqcy
	/oPHtu7YPnmOFWXF5AfxxEcD047X4GV0lGXJt3AKppoigoyjwbsJFLzKiyBESIVdzmrsErb91As
	1b2YTUhZTUBuEBzY1RR0pagK5bsj6W91/3yvD5P6E1JLfTHferzVHDjxrMKc5467bwDANKehOlp
	BncmGWxjHSOoLdLXrahvgS9gZw1o4jLb8PnVbgJdTF5sgQqnxwCK0w/l3qeW5xJgsTnovXLxNSt
	CDo66O7jyIgOiSyMOtXzb2Hc=
X-Received: by 2002:a05:6a00:2e21:b0:8a0:20e0:b131 with SMTP id d2e1a72fcca58-8a9be490997mr5082579b3a.19.1793521048212;
        Sun, 01 Nov 2026 01:17:28 -0700 (PDT)
Received: from LDYT9Q2G2M ([2a09:bac5:cad2:3228::4ff:28])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aad9d067cesm1104467b3a.29.2026.11.01.01.17.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 01 Nov 2026 01:17:26 -0700 (PDT)
From: Zhiqi Zhang <zhiqizhangg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Finke Lennart <lfinke@student.ethz.ch>,
	netfilter-devel@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] lib/ts_fsm: preserve token types when exporting patterns
Date: Sun,  1 Nov 2026 16:17:19 +0800
Message-ID: <20261101081719.51784-1-zhiqizhangg@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261031202211.22f18bca7819dbe2d107d17d@linux-foundation.org>
References: <20261031202211.22f18bca7819dbe2d107d17d@linux-foundation.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew,

> The main user of textsearch appears to be netfilter, so please let's
> keep the relevant developers in the loop.

Thanks for bringing them in. The affected userspace export path I verified
is tc's text ematch in net/sched/em_text.c. I have also copied the tc
maintainers and netdev. xt_string retains its original pattern, so I am
not claiming an iptables-save/restore regression.

> Zhiqi, a thing which is missing from the changelog, and it's really
> important, is a description of the userspace-visible runtime effects of
> the bug.

Agreed; the changelog should have explained the tc consequence directly.
I have added it for v2. There is a runtime effect: restoring an FSM text
ematch from its rtnetlink dump can change which packets match, or return
EINVAL when an exported character-class mask is not a valid token type.

The additional automated test uses a tc basic filter on loopback in an
isolated ARM64 QEMU guest, a DIGIT/MULTI token, and four-byte UDP payloads.
The original rule matches "7777" and rejects "AAAA". Before the fix, a rule
recreated from its dump matches both; after the fix it still rejects
"AAAA". This is measured with the classifier's evaluated/matched counters.
A PRINT/MULTI rule also fails restoration with EINVAL before the fix and
restores successfully afterwards.

> once the issue is out there, LLM-using bad actors might be able to find
> ways of exploiting the bug, so please discuss that aspect also.

The trigger is reuse of an affected exported pattern when configuring a
rule; dumping alone does not change the running rule. Creating/restoring
the rule requires CAP_NET_ADMIN in the relevant network namespace. Where
matching selects a filtering action, changed matches can make the restored
policy differ from the administrator's intent. The tests establish the
matching error, not a privilege escalation or memory-corruption exploit.
I have not established a production deployment or a wider exploit path.
The test source and detailed logs are available if useful.

> : Related finding: BM/KMP also export transformed patterns. With
> : TS_IGNORECASE, repeated folding of 0xff changes it again

Thanks for the pointer. I have kept that separate from this FSM series;
I have not independently validated that additional finding.

> : One small test improvement: after copying the exported pattern, add
> : KUNIT_EXPECT_MEMEQ(test, exported, pattern, len).

Added. The updated suite fails 13/15 tests before the fix and passes 15/15
after it on ARM64 GCC, with 15/15 also passing on ARM32 GCC and ARM64 Clang.

> And I'm thinking that a cc:stable is justified here.

Added to the fix. I split the fix and KUnit coverage into two patches so
the small production change can be backported independently. The matcher
change itself is unchanged from v1. I am sending v2 as a separate series
with the v1 and review links.

The additional v2 tests and revised text were prepared with OpenAI Codex;
the recorded automated runs were driven by Codex.

Thanks,
Zhiqi
