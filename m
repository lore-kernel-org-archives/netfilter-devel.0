Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F6042F707
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 11:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786447676; cv=pass; b=f9DQEqccnKog7gdy316GBzrL9eWHFJEJmD6N9aBySjguJmC/4QmGsuin5a6kuVhiArUd1IPbChJy6+2KrHkgmTAy836QaAepEJd0yApjBqodsOe7BDc2PpAPd1KfweYjN8bCQ8+ORst2NwHSBTjnRlyJGJv0ZJOmkFANoUbRowU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786447676; c=relaxed/simple;
	bh=gPTYVYThqebcr7g7jbldMUzk2xfbciKkyRSUFniOnIU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=alxWYHPFGaG+c4MyDLRbSCOtagR9wuV2eolChRdnNSW9E+KeEDcOm2kPgkMtWuAR0zsYGm1zII1IpqDs3i3F8/x5/Es5uFQ0ERJ84Gv0vJ9nawID8kg7HXWlJ5eAZi5Gg+UMKiwJOGRh3yiHL8n5dyqqdnFPyfDRxuIDqahmvlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZIxT5qgu; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZIxT5qgu"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-668432fe416so912334d50.0
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 04:27:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786447674; cv=none;
        d=google.com; s=arc-20260327;
        b=s/HtSCDQFzCkjJWbJW8m4HVpgJ5Q2fIgGRGKz6mVw/JgygqFhI6+rPv6u29IB+Mf6g
         yfQXSxtfTXvHxDz5WevzogmEr9Rtvt2/qDtvVK26GL8BefA/17v5Y1Pn1Tug/v9L/E8Q
         X14QzKkc+Hrm2TjgoVKOgxWsI7Ogw1ja05bvmsUDgsGy16gOdcveVTE8KNwlB8iC15XG
         +EGKw8WkWyySSbY6siyerY8ezevICEdq0BmF2Cz7lYQKXmtpaPmmLlFUUEL2JfShY/rz
         cmq9aaFOnLShwgVTXUfylPejA9xsWwT5K5dMGeL8nzGY+68PQeAvDyVQR/ir6DxoUDDx
         lVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hGg8ESNguwrB+ZU7MPbpG1BXMHhTtkw2FRy/dmstgjc=;
        fh=PWGzacwSAWTFg5dAzjcOs5GZbHhYV60EKi+ucNQtIyU=;
        b=ouoN24YkTtNOGhHYTbSYf96AzKk800WroP5Z26YmlZY9xBVlqW5kM7sMTSlOVjIVGr
         BQDZAG/Wb72HA0krMC0zi0yoM1fKIwZ0k7c67Y44jaUfsT0x8CFp1iMfaDsgK1AI2R1g
         PsNzBfdNtOaTOIVEu9tvgiJlGBxsjc8qgTWNThrT5b7b3zNjEQ9ojcbL0UOaJYrkEvzD
         40jQVVnqNN/OgoXRvrc6IGdm12ZGPyRs2HeFMcJttbZCL5lSupkd3A7KUE3Ozxng2xZs
         1B+Vdz0FEDJ41XpR7IlVcUmwFCgapiMy46HtLGOvbEc3YvmbRKZa/thjgUfxFsi50NT8
         qlQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786447674; x=1787052474; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hGg8ESNguwrB+ZU7MPbpG1BXMHhTtkw2FRy/dmstgjc=;
        b=ZIxT5qgurIp/wIfAe026pB3P5dvU9CREJFHgOf5f9Obezx2fCC14+iNrePje3CJry3
         b2hcQUSOMpPf57wo/BflO2ItB1B0fc3z9EFJJN8M4QtDT69zARPnYPqKp7Ef/P03QK7k
         Gl/6tSO4TSJ26AagCZXkQkAE4xbPXZl1ueosfkuTTSjkyzBe+JpHxVZXw3omTYuDX4w0
         NloM4gvJLSuIjkWZ4YfxID/AbQs3uozEkFLj5uYXnmlD+zugAaOQc/4Wh//FkDw0Z8af
         whSRJBwIbCW62wPsgTlOOTZNVTleW3l1M38CTEYDyyAIycFuUHl/mASTtoeT+3wy8opX
         VoDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786447674; x=1787052474;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hGg8ESNguwrB+ZU7MPbpG1BXMHhTtkw2FRy/dmstgjc=;
        b=fWVGWRj5cT2Uxj3oaH1Xox2fyO39XPJQgttGtsO8PdrSuq5oeOJmj4VMF3KBWDZpE/
         AYc27gG+323ZqtWGkGYCpYHDagAmkTSUl6BitqCbZYFCh3Re+b5RVQcF1UxuyFotWwRk
         WbJS4h62CiOdyLJCJ414mgbPRqocNvOshi4jHGWsufejR2CZnoU1RoknnL5J++RNdyXe
         KVs8Wl7MPUQjs/P5c8JH52hdnJ5OqXDHfPRlTNrxT2byz0sSCKhfkWPC9LHuLeurPU3s
         8UldTQkwgAY5g1th3JiZziC3+/tEGrSOAlYIhlI7W8Ee6O+dmMYeHTRN6I2hHXELXhpc
         YEDQ==
X-Forwarded-Encrypted: i=1; AHgh+RoJWpeidwBJANoBRI09PHTfWnMwkF/iyIej/1W6w3iB9tO5ohnneM/82q6ENZJHNAAbb43cFGaMk4XTeQfbFiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDkB8hYJ6IE9JgJ/RFvcYHP60wckxvG/QTGYrh3Bre0UeAO1D6
	ktZ5HzsgoYTPIpQz7n3H+Z967QazAlhD7n4+d/JI93VSVxYhwrsxfJObAIVUz19JPzau6XZBmzP
	8nQlkSFZyLuUu/UACayKxQIE4h6i7b+Y=
X-Gm-Gg: AR+sD12TdCb7SD8f1TzdSycmCFOvIkcYUyNGMNqPPHYRutD8wHDM4bTp/X+ByYgcSpz
	/5mVJR1wdDih5JlOg5QKFgVjj2nAtlCMG+XVJXMA/+2RMFVFJ7l4Ymo/1OzgqmJ/Szv9kH+eCRe
	9CvCLAdPN7+EF6uk72DrPtS0mIiLwO3qpRbT+jtKyuVPidToGMIuSglZ+2GsILen66wtvljMA/q
	VhnxDA5GUJQgKOiDWuBPhk9g09f6pS4MWjELyGyvQ6KNKzCFYWmsQ7dQd1sa86apbX3uhPPeOF+
	YurHk5iDTbvJrlFQjQRpAxEM3GSnuHsisRM1qgjojH5z
X-Received: by 2002:a05:690e:1c07:b0:668:9ea4:775d with SMTP id
 956f58d0204a3-66b22e3e170mr1420801d50.37.1786447673539; Tue, 11 Aug 2026
 04:27:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANE+tVp8_NhE+KL6ZNPGjaGMLPxrCWw_A5sY0jotrvThB6idXg@mail.gmail.com>
 <anr3YZJrnS_2RbEp@strlen.de> <CANE+tVr69qqyreBbWWk_2FqpMfQAqde-JF=weECditGJF=uZ3g@mail.gmail.com>
 <anr-MVb8okTwL1X2@strlen.de>
In-Reply-To: <anr-MVb8okTwL1X2@strlen.de>
From: Wei Fang <void0red@gmail.com>
Date: Tue, 11 Aug 2026 19:27:41 +0800
X-Gm-Features: AUfX_mwvsDU-qXxy_qbgABFDC9LTIWgX6fiPFU7ZohbABZckOCzaNv_l_-hoJo8
Message-ID: <CANE+tVqc+NNN8EfpK+cEYV63Pmn3OHS81PBAGqB1RHidraChLw@mail.gmail.com>
Subject: Re: [nf_tables] pipapo: inserting an interval that strictly contains
 an existing one is accepted; rbtree rejects the same insert
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, 
	netdev@vger.kernel.org, k.chen@smail.nju.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for the detailed explanation.  I agree with the
auto-merge/no-op behaviour for the case you described: with an
existing interval 10.0.0.1-10.0.0.5, adding 10.0.0.2 (an element
fully contained in the interval) being a no-op is the expected
default.  The reported sequence is the opposite containment
direction, so I would like to make sure we are talking about the
same case.

The report is about inserting a *new interval that strictly
contains an existing one*.  On a pipapo set: first insert
[1.1.1.1..1.1.1.11), then insert [1.1.1.0..1.1.1.12).
On the kernel under test:

- the second insert is accepted (errno 0);
- the new interval is actually added, it is not a no-op: a raw
  GETSETELEM dump afterwards lists two elements,
  [1.1.1.1..1.1.1.11) and [1.1.1.0..1.1.1.12), side by side;
- the identical sequence on an rbtree interval set is rejected
  with -EEXIST.

So in this direction the set ends up containing two overlapping
intervals, which makes membership lookups ambiguous for keys in the
overlap region.  (As a side effect, `nft list set` aborts with an
assertion failure on such a set - userspace interval aggregation
does not expect overlapping intervals to exist.)

If accepting this direction is intentional - i.e. the two backends
are deliberately allowed to behave differently here - that is fine;
I would just like to confirm that this is intended behaviour rather
than a gap in the pipapo overlap check.

On Tue, Aug 11, 2026 at 6:49=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Wei Fang <void0red@gmail.com> wrote:
> > On Tue, Aug 11, 2026 at 6:20=E2=80=AFPM Florian Westphal <fw@strlen.de>=
 wrote:
> > >
> > > Wei Fang <void0red@gmail.com> wrote:
> > > > -------------------
> > > > expected: both backends reject the overlapping insert (-EEXIST)
> > >
> > > Why?
>
> Maybe I was too terse.  Default behaviour for interval sets (Rbtree) is
> auto-merge: if we have 10.0.0.1-10.0.0.5, add for 10.0.0.2 will work
> (no-op).
>
> Behaviour for pipapo is to accept a new element that is fully contained
> in an existing entry (no add takes place).
>
> Sure, it could be changed to reject but that would alter user-visible
> behaviour, so I would expect complaints.
