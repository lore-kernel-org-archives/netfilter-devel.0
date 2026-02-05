Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB72212554
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770257061; cv=pass; b=swJWMRI23v3kM8vpLUc3xAd+BOLeK4FI7h/Z2DcP/7ODWXzaDql7kJ/L5j8z6qpCsafXoGxU08yaa/7ijuScd9aCN1TnNEGM2zQwC+rHYvMJVpxRL/h37onXqwC5Y6+cdx9lIZ7Lq+3adO4QVnYoJaibUyMfrDxelrk07WFk6Nk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770257061; c=relaxed/simple;
	bh=UL8HjFcvJZYtSbXnRCkLuZHjyKWfUxq7e7ZHcZ/zres=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tl0vu57V1snc/kHQZbxp+y23vll4Ja/b4QDaJAriCefUuY+cj3MRtClysZX41OezKNEUpkMobCT8i64BrbyQc7/GYmLEQ4yQINuzucKccDK0exzBuWJn27DXQwcJ5kwVdgQ+pn2wB9vER49Y4oiAdGtksC6UW21on0W0xHWgj68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NGzdX4d+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VlwFPZnj; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NGzdX4d+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VlwFPZnj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770257060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UL8HjFcvJZYtSbXnRCkLuZHjyKWfUxq7e7ZHcZ/zres=;
	b=NGzdX4d+5eXRi99SR9mZxxrfhbXQnnz1y6fVXxcG4QbfC3tm67LU2bFUXUhJQRUUTciGB8
	qSlGLsOvCyABoiBVRNog0aWVci866Qoboe9iSEcAVBgdCsUZl6hBbDGWCJjTenia67VobC
	qEVIJkTP8tY6litCAR//WqiVh8i52lE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-ttiw_jgsNOe0NhZuI-v0jg-1; Wed, 04 Feb 2026 21:04:19 -0500
X-MC-Unique: ttiw_jgsNOe0NhZuI-v0jg-1
X-Mimecast-MFC-AGG-ID: ttiw_jgsNOe0NhZuI-v0jg_1770257058
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-352b6ad49ddso249140a91.0
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Feb 2026 18:04:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770257058; cv=none;
        d=google.com; s=arc-20240605;
        b=QVhOm+2BE75iafp+9ttoYC+yE9F5KXOn3TQzir6WGiXxGWsOyB6OYAHLw+7mG8fo8N
         Cj4LuhSwXh8ttE9h52qgf9c9Wkd101ttXhZy5IE5IOxGNrIXL4pNvbnjLsPLM2ZxyGWm
         n/EvmtLEzt0V2RLjKkIhjVOXl4HtasjzQpb6vjUrWPHEeOz3x6Y268fID++53J58kW9q
         +ObcXSWWy9m4TCtuNnJhtzLxBY2Q6RsxVvhWPrbfEjzdnnWLsdE2cRGUHjcHO9f6ZUnc
         e8PKLMxz49qVqOoBTKPD1fuTNWkYHrJa4XrQkCfqA4t7gUbsMJHufF9YqJxYiWUbkebQ
         lw1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UL8HjFcvJZYtSbXnRCkLuZHjyKWfUxq7e7ZHcZ/zres=;
        fh=i609X/cByo+BurEWfu/CLegShhMFz4dUuRQ9RGwPNEY=;
        b=AJXv6SkyZef7sLQyQrUYaXrXkIzJITNmE7+LTuaEXvouaAk/fP00Hd7yi1xft0IN0B
         HPingBSBq0WO4wFP7YT/RYDHPUux5BMEfyBR6Daj13baECNSt1IKA2HTu77G/UcJ3nVs
         azQDgQ+QF3BWQsNFzbZhG+wyg4JnK1wpkk2M642e5WHePEmAiEkYkYwQIo8V8WRKvX4t
         15ABgLhy3Jid2IMbf+EjJcAXV4LeVhDsEfYsAgGOqjXXm0MpcQ/o+fG7mnig+ZgVdiUJ
         zqjM/grzRf8NRQYftvFnRXcaeaTNWgAxJc64TBYtLVnVPccwIzEwxv1FzgI2qgO68Gm1
         f1Kw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770257058; x=1770861858; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UL8HjFcvJZYtSbXnRCkLuZHjyKWfUxq7e7ZHcZ/zres=;
        b=VlwFPZnjK9surHK5/+rpGD+9H/+jX1DumCJQ0Wn313bpilyQqfmarS3lhqDGWvQDxo
         t+3jaE13SwdKAIzmX9K5YRkmfm2xpEQ3schQ7zn8Dz87rx8EkitIODzqcavc9voHmq0C
         nz1knpknB2yxD0d5b5cdNds1F+ujsY7Y1XNSoT9t9cud3wRE+Y9w13gH+GwJncvs3RoZ
         MiIQI83ySnKQS1lD2AaoawCAaScXxP9MBc93rg41/zgYH7VmDu/2/gCcNyRK/JabQX9G
         ZkmtGmD9J94st/QYhO1/G+8SLfPNW+1n3Rvuw6Q6UCmL8YC9i+7HYDcfU8N+VfiTaLUZ
         FS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770257058; x=1770861858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UL8HjFcvJZYtSbXnRCkLuZHjyKWfUxq7e7ZHcZ/zres=;
        b=txu+eRbBQOg1sNp3k3I2qWqMLgddysayMPt8GxkVsSKF5GLXHxUjmrSHQOkpgJ0QtK
         uH/LoLVSjGGNaaVo/H+r4Jg9a5JJGEYmsBbZjrvqfro/qpGZnS5AghdxLQ3LeQalxMQs
         MLjigHoWFfSziO+4TAMtZ2EUlFfbp+aZsjaaMpucqwkgAaAoiS0RNrO8LPP1/qbQIh4G
         CSi1Y/e0G/PJCEVXAa3oCKuVax3FJBRlS7vCwkoLcjMu23kD0ZV3L1AqvPwjr2UNMBOO
         vCvaUnFCqY8LQqvQwkIRWR4UZmRa6yXTR8yk5x3Zz79cDB4j5nR5mERR2O6+SfX6KDbx
         rWPQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7OO3u0cxlSo3Wh+rkRrQCqNvPn//3QSqs37GEWc/yFgUynQMKZd83Zlv5Ermd986b9JaNZmMDKIqK+f4ehlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWvbZM4aACtjNLbZOiPxn14mnO0mwXQ9dg+AU1N8sHemrwcCLJ
	r15EKnkRPKuiJMOY+au7WCHLNdGAY+Ubi2XpD44tJZYV5+t5jK6m52bY58STDFYic6mmq3TH/t3
	lNSukvrJcAniqwNxWHCc0FiMuWPR+fTt+0RqGJZjwzU4Coq/scMgzJj01HPl3fFCpS7qCKNYyWe
	47r7xSUhHPeJkf7jLa1oSg1ubIwXKiCh5HewhQZ2+rBvLxQQolFypK4/03Cw==
X-Gm-Gg: AZuq6aKBpMLHUgnQf4ZJB4S3ZxMB0n5DhEry5GuNNz5Oot5aHrSyvQ823qVIIZYK41O
	IpzOo0R8vIlcW9Kw/a80OmWhsdbT52ewZYmtCRocZNDV+ZcxxTzwosORs7taJFzG0d3hhxQqyw4
	3bvJyjQV6ZuhcU5vW4PbR7KfXbVDmg4qyKYdpVU4GUhHGMUQgBH1B2u2sseuWjSWcUUl8=
X-Received: by 2002:a17:90b:2d8c:b0:343:c3d1:8b9b with SMTP id 98e67ed59e1d1-354871ae504mr4460677a91.19.1770257057740;
        Wed, 04 Feb 2026 18:04:17 -0800 (PST)
X-Received: by 2002:a17:90b:2d8c:b0:343:c3d1:8b9b with SMTP id
 98e67ed59e1d1-354871ae504mr4460660a91.19.1770257057287; Wed, 04 Feb 2026
 18:04:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204144940.63422-1-yiche@redhat.com> <aYNgX-nh04sAQdU8@strlen.de>
In-Reply-To: <aYNgX-nh04sAQdU8@strlen.de>
From: Yi Chen <yiche@redhat.com>
Date: Thu, 5 Feb 2026 10:03:51 +0800
X-Gm-Features: AZwV_QiwF1qZmC4koiqlX4Q7-vh43kxQ09njc6KZZBjhZOIqXGBn-0j51IF8EdI
Message-ID: <CAJsUoE03i1S6QmnSC++Qijh-q3J+QXdHek=j6E46R7+8-oZ7=w@mail.gmail.com>
Subject: Re: [PATCH] test: shell: run-test.sh: introduce NFT_TEST_EXCLUDES
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Some patches may be considered too aggressive to backport to
downstream releases.

For example:
netfilter: nf_reject: don't reply to ICMP error messages

When this patch is missing,
tests/shell/testcases/packetpath/reject_loopback reports a failure.

In addition, introducing this exclude feature makes it easier for
downstream streams to run this test suite while excluding known SKIP
items.
This also helps to quickly detect newly introduced SKIP items, which
may indicate new bugs.
Therefore, I suggest adding this feature.

Apologies that one line in the patch uses spaces instead of tabs for
indentation.

On Wed, Feb 4, 2026 at 11:06=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Yi Chen <yiche@redhat.com> wrote:
> > Introduce the NFT_TEST_EXCLUDES environment variable to allow excluding
> > one or more specific test cases.
> > This is useful for some releases where certain tests are not yet suppor=
ted.
> > allowing them to be skipped directly in the test script
> > without modifying the run-test.sh itself.
>
> Wouldn't it make more sense to add a feature test for those?
> Or is this about test cases that fail because of a real bug that
> where the fix wasn't backported yet?
>

