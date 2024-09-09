Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C0918A925
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Sep 2024 22:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725922122; cv=none; b=IHrnAg3u5SjfF/qQM7TpXYkAWQrzrweHU1QJHeURnnOJavwAOpbHhe+vd9MBDN4Ed7Pw11CIY5zgrK97WXMOuttud5dT7ltZTujPbRjra12TNdn51eSh246ne+HqUduKwfLayrR8LQJQ5JCd92OotGoyKQH5lKv/4GpKMmCBAc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725922122; c=relaxed/simple;
	bh=rkdImjUZtrp4ImzZRS226DW6+1fYM9yBBOJuj2dWu6o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mC+KXiRW9v2MjZR8aWgg4bPmH39vMKaqqzf9k8of09f/iXPf8lt68HCLAIMWEq6AFqfN+07jj0o/a0JC9d7jG2SOVkBDigjQKHOG9G8JU4grlqHR9Y4pqte7x2qksuy7LwiNUIVC37eKWrq1jdwWy9ny7Y+SDhFn4f50HLTcE9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I+yNb2kM; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I+yNb2kM"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-82ad9fca614so496390739f.3
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Sep 2024 15:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725922120; x=1726526920; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NLDyWzTfZuqsLoIb9DG2Ov0GNSs+nA5mIhE6ZJufYmM=;
        b=I+yNb2kMUloQgz1J5RZqZrtDFuSyw4WcBY0P/JUr11mQeUJjWKmYrRcvXTny183w/g
         C9kwjcgDJmNssFRYi0Vl1P0ZskY85GxZTMaG1T8ijkel+Gmn+4Un27Ukwuy+NEOd37HF
         mcQ7zUrK6ctUs+C+R/0mEuz+HRdNgxuLIs0ycNpObZRcz2J8VVtJnivK186IL7pDLvYV
         PAVB129z87uiuUjLTsOjwyFPTzqivjbprktfPD5RZB1MlRrdAjRe9+EItPCtPCLzjXhJ
         qH99VlhYTOvTV8Kt0C8wYAMqf2xRJE+UGxbJigyX46Kxg81GEIwqU6oyg3QgDnjq+kD4
         T6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725922120; x=1726526920;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NLDyWzTfZuqsLoIb9DG2Ov0GNSs+nA5mIhE6ZJufYmM=;
        b=FRA3ci6ZmPx7rAu8MYMbEXTEYwvbdxqm7y3FR3QVn4akxzIZgKfkmoF0zYnIKELpJJ
         T8Dp1IIUKYhQ5LXGb+wK9GrwjZQPOkMAOeyKL7lWnR2kgmsLoqV8KlQe3Ti2wWFBMtue
         MkdkesmbN/NwKWsLz1CGH5SsRBb9VXtUArJ7asSUj3lpoy2+pY+6Ckuc78mIoujRkKjx
         5vXfKda7YwEhTaXM35JJfs/h4tlDSu04BP/8biDjHiJ8Ffvqv9D2Bvd0r+k7OmCXC5t9
         CNOiC2pLYIBoL3S3rf7Jp4z2Fvi0v9c2v8xc1mSBzjVrETdGJ8TFD0EBNhS/GoOjVvjb
         ydvg==
X-Gm-Message-State: AOJu0Yye427cH1Mkj0pdvAFvcDu44ZBH/HRUQ/itvhnZEkVex/LKYbVg
	wdYFx82hz8rt0MXGv2imqqXl3XIFoQmCgOMLZ2sUrFEafnMwLUhBcIsZyUQ43gqporqRQCp+Mry
	gAVvbe3bmsdDBHKUB61ocow==
X-Google-Smtp-Source: AGHT+IHW9HlvXZZMt0RnOBn0kfRYjrcTlLFf/BWUyQHziXtf3ECYT6VFohieaTDTa3LBmOc4V5HiWGQM4zyJT8JI+Q==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6638:204a:b0:4c2:7945:5a32 with
 SMTP id 8926c6da1cb9f-4d08501de57mr562213173.5.1725922120651; Mon, 09 Sep
 2024 15:48:40 -0700 (PDT)
Date: Mon, 09 Sep 2024 15:48:39 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAEZ732YC/y2NUQrCQAxEr1LybWCtIl2vIlK2m6wGNJbsIkrp3
 RvEv3nMY2aByiZc4dwtYPyWKi912O86yPekN0YhZ+hDfwwxRKzNNM9fVG44mZAbHos8GhtqaeO TWxr/TcYQiYaUEh2GE/jobFzk8zu8XNd1A/k72yuAAAAA
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725922119; l=2091;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=rkdImjUZtrp4ImzZRS226DW6+1fYM9yBBOJuj2dWu6o=; b=RpBy5WGk7841aMAXjLBUnNV+WM74QAmVjxplAH9jkIJQv+5Ll3/fWHnPQ4vkG0vDP88xEPF8T
 nCGCLbpgdzoDWhCuqbZ6sFgO7Ai3Stk/gJZ1EJbZ9wU5CpMLoIBzPon
X-Mailer: b4 0.12.3
Message-ID: <20240909-strncpy-net-bridge-netfilter-nft_meta_bridge-c-v1-1-946180aa7909@google.com>
Subject: [PATCH] netfilter: nf_tables: replace deprecated strncpy with strscpy_pad
From: Justin Stitt <justinstitt@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Roopa Prabhu <roopa@nvidia.com>, Nikolay Aleksandrov <razor@blackwall.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	bridge@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="utf-8"

strncpy() is deprecated for use on NUL-terminated destination strings [1] and
as such we should prefer more robust and less ambiguous string interfaces.

In this particular instance, the usage of strncpy() is fine and works as
expected. However, towards the goal of [2], we should consider replacing
it with an alternative as many instances of strncpy() are bug-prone. Its
removal from the kernel promotes better long term health for the
codebase.

The current usage of strncpy() likely just wants the NUL-padding
behavior offered by strncpy() and doesn't care about the
NUL-termination. Since the compiler doesn't know the size of @dest, we
can't use strtomem_pad(). Instead, use strscpy_pad() which behaves
functionally the same as strncpy() in this context -- as we expect
br_dev->name to be NUL-terminated itself.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://github.com/KSPP/linux/issues/90 [2]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html
Cc: Kees Cook <keescook@chromium.org>
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.
---
 net/bridge/netfilter/nft_meta_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index bd4d1b4d745f..2a17e88ab8ee 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -63,7 +63,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		return nft_meta_get_eval(expr, regs, pkt);
 	}
 
-	strncpy((char *)dest, br_dev ? br_dev->name : "", IFNAMSIZ);
+	strscpy_pad((char *)dest, br_dev ? br_dev->name : "", IFNAMSIZ);
 	return;
 err:
 	regs->verdict.code = NFT_BREAK;

---
base-commit: 521b1e7f4cf0b05a47995b103596978224b380a8
change-id: 20240909-strncpy-net-bridge-netfilter-nft_meta_bridge-c-09dd8aaad386

Best regards,
--
Justin Stitt <justinstitt@google.com>

