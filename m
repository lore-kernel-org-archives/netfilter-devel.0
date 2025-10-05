Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D8554279
	for <netfilter-devel@vger.kernel.org>; Sun,  5 Oct 2025 10:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759661052; cv=none; b=lbLkdARfYkVYM5G6ubU99WXt3JrgllRyJjahHPXRb5kCo6ItNDLt9yuI+WPmj8j7v+SDX3oE/+ZPVr/osuhbyCrmGdMIsM/C4Toih65ZYD6S5vuRxqcLZmCyzZyXPV6WxxkUQoJzF1xHHuBAKq+jsbn/dJyv4RF0chMiaO8Sovw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759661052; c=relaxed/simple;
	bh=R21iG4z4YvL91BJh6qdGL4U6gxDqqdL2OZRtOH5Ipvs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nl8vrkpiy+AAb5YZ75mq5dHiA+FXooQH4r6t5fHy/e4kg0KLS5eW2jePL/efUEudRsztz57Fcf08nam+qH2uGHHp+S0mr04PyCWmM9ZMXbEn3y8u+z+EO8sqCCUTFAyy0qmna4HF3QE3eyGrkBWT2kQXHyYJU5Qxy62LzjsfTsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O9DejeHM; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O9DejeHM"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-4259247208aso25329905ab.3
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Oct 2025 03:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759661050; x=1760265850; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R21iG4z4YvL91BJh6qdGL4U6gxDqqdL2OZRtOH5Ipvs=;
        b=O9DejeHMqBdmD6XF9iwIcGrNclVxeIdBTp8ShXMbFs8SskS9v4GXlCJsSgVJhioXiS
         vHk7qCp7dOdpJwiMFDRfR11EvOMkA9FVzTm2+n0yDgyRs5NuBp3Yc/bkZVstXVOIrIF1
         otL8n6Iyoq4fl8oAtI7gzMb2KbW8aWFpa+AZJxLI8Fr1mZRhyn8MgPjaM6gpIx2CKbgU
         NshYJ8cxUrZXfuHvTP8EADsUPfAaUIBUiEZy+WjoQlKfWXf5GPfszxgiDeThsIA2kMyx
         RhioIiQIcicv5DGgCGJjMHL4WYKl0Jm8M89LG3GSGXMON5CFWbZS4cIKuWOvUiExWLrA
         pI4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759661050; x=1760265850;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R21iG4z4YvL91BJh6qdGL4U6gxDqqdL2OZRtOH5Ipvs=;
        b=oAPY/GCNvYOxcEVDyovI7+AmQNn4ZERCnSIRb/RoLnG3RADDntuZFlJP8Nk7AJkZ6q
         gq6IUJAuQ0+kJedF3XiIJHLVdsiRopzddnU0gGPNdZqOjL+z61/1/w44T111W4JrKqtA
         /0xK3mdt3q34IjbOBe19bSU632VsbDZENYbZAHJ8UjdtCK9IIhThFw8c9IRZHwN5gI6e
         ooCqMDW5Vmca/g/1B7KT8BxwZGi8UL9mrQlLRmCYZaMsSPT2BmM9Wx2D3oSYgMjNny8r
         +n1QrIbvx1qDLWiN9SCE0Hx33f3ktQNREDdyRlHDOHYNbpDhxVR/MtiRcR9CF+dpI6Yp
         3jtw==
X-Gm-Message-State: AOJu0Yz745ISTtQSsWCS4joaBC2xOcSbwTnyFGFgaAZSTedyILDJz9gf
	IsPXEZfhvLO3iAw/kthuLy7LerbEGC5g02lQfYaHnEU0Y7muQC2LosMIUe/M+TxfQbhhdbh3UUy
	ncvSgNNzy0QbCTiH8KskeAtPm/gBunf4=
X-Gm-Gg: ASbGnctShd7m+o83lnn/eCgth71CkPNBHRer8W6m7tQCq1PZrmsLhC6oSsYWdoGQ9jj
	GhJNbdeCB+B4m2nXhjFezCS12MF1FFou8cP/o8xN12GGE0SZ7NTtdlJ2UR+0ELCfTwQJqQW0rs7
	vjzSFzR+h91TdNtgAeSwXS6HLSHjlijfvgIEwgc0P02ORL7aaLAVV3g7hymaWNiWUiM1RnAtJ59
	coyfUbofoQdh3xvdVvjvTOMOSVC94335e7lrMU77eFb7f8PSp0EOzIulWRvnJTmHf1IFMnGP7di
	kk0Xot6HIrPmZXDi/nep7R3MUwdpIQlHrbf3Clf7n3JN4nU=
X-Google-Smtp-Source: AGHT+IGyiWqfBsX58jmbGKnhtfF42Y17OUJ3lUEkgDKx6ihMT3qqSuQTI3k3bcD7TwHY/bAgKC5TZv4hFTXWqHFErDQ=
X-Received: by 2002:a05:6e02:18cc:b0:425:8d9b:c430 with SMTP id
 e9e14a558f8ab-42e7acfbd2amr128976755ab.6.1759661049805; Sun, 05 Oct 2025
 03:44:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de> <20251004092655.237888-1-nickgarlis@gmail.com>
 <20251004092655.237888-3-nickgarlis@gmail.com> <aOD7IaLqduE9k0om@strlen.de>
 <CA+jwDR=0riXXHig1wcq4BjbGDUngksrUTxdgJgD4S8PUqAvO=A@mail.gmail.com> <aOEScmNyuP_k_YsU@strlen.de>
In-Reply-To: <aOEScmNyuP_k_YsU@strlen.de>
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
Date: Sun, 5 Oct 2025 12:43:58 +0200
X-Gm-Features: AS18NWAlncIzxkuGVmSqthT63PSzE_2DpQmbWrs-qScmR7lJAyMveZ_eO0-CYFU
Message-ID: <CA+jwDR=ryt_yTj7Y7B9ZdbKVeb7XsN40zASO1MXC75suYaceXA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] selftests: netfilter: add nfnetlink ACK handling tests
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fmancera@suse.de
Content-Type: text/plain; charset="UTF-8"

Florian Westphal <fw@strlen.de> wrote:
> Is this to exercise replay path?
> Perhaps add a comment to the subtest that depends on this.

Yes, that is the goal. I can add a comment to the test explaining that.

> What happens when nft_ct is builtin? The test should not fail
> in that case.

No, the test does not fail when nft_ct is builtin or missing. It only
verifies the number of ACKs returned and their order, which is what
bf2ac490d28c broke. I have tested both builtin and non-existent cases.

> No, if you need nft_ct to not be loaded then the rmmod has to
> be used, but there is no guarantee it will work, e.g. because
> nft_ct is builtin or because it's in use.

What do you think about something like this?

+++ b/tools/testing/selftests/net/netfilter/nfnetlink.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+# If nft_ct is a module and is loaded, remove it to test module auto-loading
+lsmod | grep -q "^nft_ct\b" && rmmod nft_ct
+./nfnetlink

I can send a v3 if that looks okay to you.
