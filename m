Received: from mail-yx1-f66.google.com (mail-yx1-f66.google.com [74.125.224.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACE63815D5
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 08:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782377017; cv=pass; b=B3Bwq0x5GO9xdqdUNYS/pRGgEmq2KANFTm3m5rMCOHHvRFtkSxyqT51tuBc83CtcZuy32X4VC9fBWzOxvkv6hcl0cK2kmsc653K8uwJKb8quOiA04/NXd3QIuOBmHCl37F1nDZRZ1UVK3QutT4JVPXL4ZIhoQfjzC5Wa6huO7JU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782377017; c=relaxed/simple;
	bh=QF4CFkiFtWf5pol3PiHKkOawbyVbmewI1fKdQzqlLNM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=S6tSGUf5MgWu9u535QX0xynhkQkshhYg6DZG83m8NXu87+w7Sir+XMzDmYO+om8oonQw514x2JDcKjar7Lo/bZvHm4MCLF/cBsDqMdSTM9V19PGp04cMQ9wIxhyvgSBAvj1nioNTbPOUwDs9ka6SNK75LzsIskTG3t41+BvxkRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NZ798ZGK; arc=pass smtp.client-ip=74.125.224.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NZ798ZGK"
Received: by mail-yx1-f66.google.com with SMTP id 956f58d0204a3-662e7fed068so1396216d50.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 01:43:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782377015; cv=none;
        d=google.com; s=arc-20260327;
        b=mA8ZjYt24omso0E88JGvJoIsjAOBPJfx759qpzJ0mG1e7DRw+4AazwiM9oietabsfX
         bXNszGO0tL5JNcXZTLDOV+qmuH7WTY/8vHaGP9XcuprmTQNto5KyLJN2VrEmXutEPNWn
         SAziECIs6F7ryraxqL+KawVMfga9je7UaABrALisbVw8zL2v4ZJvKQK/5Rr7tUK4rS5E
         MBLAnlnpMoq62C524iaKlnlpUBfBSHhebIlOAsxqq4r1RM4H5/1WbzlYMPS+QIi0NgFV
         Wka3B0zbiONLsBPxS7y/YLnds+PF31qyE85FHGC+II3cUoT0+OVe6+zs0ur6a+ckDdtE
         h6qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Csdx6jcfWm5S64GVEUEwal6j1TVLCYhcFQIq3suVZ/U=;
        fh=i8nWucUDDcuJZrAc5F/lTqZ3W31vqALi8eeFadgPUj8=;
        b=nK7qZCI9StyhKfjT+8xtKhnDxuYrUoKFvaNC1MCSY7dJzcZoqqVibKqdXp5Km4ySFN
         jKpGfjAXZPCqhPtgRcMNc6MsybH/pxKVp1XofIb7p131PARSKFWHs6t0hD4JnUsXgVlh
         a5e+uxvwDQGYBGpVbG87Il2naTVA49wWwZVuSFZn9PKfvJlUyvW8XAHDmv1lcoYD1zDc
         dpX7iYQPvTe9EpT5XBcIqiW774bEoYqmxyLHVVAkEjwgXmz151Y4gLTXMjscq8NttSjK
         J4PnUy90O6v/zAsg6+W76FwvzZbSIqig8JSkNZm1wsUGUVzJJS2WLN+7H7LXk83Ebl+l
         yh/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782377015; x=1782981815; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Csdx6jcfWm5S64GVEUEwal6j1TVLCYhcFQIq3suVZ/U=;
        b=NZ798ZGKYRzjlktkb6j720bjcYAul8T6ULLLDqoDEh1qvz7AbYcPDw1nvVzDaeodnc
         E1Kb8fiUf5N+u444KcpxzF61/2H9o93h1hcpDoknINqZUBbgnRR7hcCgxAA+aVmOGLhJ
         92vXZJhzmTKw18JVhAasCnkG1KgnQUYaDIOe5xb92JFehmOIk3NXTUAYQiOFR05W2xWw
         q5VY05VTMP2Maqg3yXL4Ng9mDrurEoNpbD994lOnTYcW/9w/T6Od4QFkZcJk7MYVn7/I
         2EALUUWzXZAToUcfLCZaAgbSWHfZH70qjM2+ZypsnoDD57LkZVJ852oabtBu8lxzZHTn
         vsJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377015; x=1782981815;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Csdx6jcfWm5S64GVEUEwal6j1TVLCYhcFQIq3suVZ/U=;
        b=RVO06TuXxO6QQM8IVOBP7tHsWpWLgh7JJ2OUyeKsowPPMBKc0euuqi/fneQqWPfzPs
         /0fMEKaIaL0YhsivT2lpZA7zwZcS0/+ViS+Le3zwhJR2KDJcASXbvrFI5Oj9WvIzg3Lq
         xd2am9Yf7XmSf9QY8h0YCPzRZwsoCdEMMLsRVQ8vfaBFKm48GDZsd16RM47A2WG0yoWD
         pAlYImZmOCDj20FOB0d004FajclhAYGMB3tdRJVAKw2XdjtxrolAtVmpV077zhJyUUpE
         nYMRxV7X6GbwkSWvW2q6Q7n6d9ijbLpQy2v3FQCB2RBi279srujmHGFtbnfpH/G5d8jB
         t5ew==
X-Gm-Message-State: AOJu0YyFIEBl7uXt0zgKFt06pA5BAmBxcHNdcPqKpaizrhOnz3yj2DjH
	5tR9AVPq0clSAFQm42WgvJbBgzu/YpqlNo5Q3LeqpfRqWUXu65CXlGrSOtqbycRhAlUviNCxYeT
	lPPzRqDtGPqNOjsz7k+FtUggi0QbE22ZUi+nYFN8=
X-Gm-Gg: AfdE7cmI1jkgWdCvG/C0rD1/xhuACS/UoVeJuse+6HEAI+W3K9dAF+dV7dig561btZT
	1ViV9uqghz5Tf1uQjbpUCby7MXL3SzTVvgEb3xK35YEx/pEYN1xOD5/p/GyvvUZujn1GHhV8/XW
	3KLMn8/DbJZ7MhK9OevBMhu4dXskpDjgs2qVrYBgCUevP4JJI2ptcAo97j8fJBA3XrNHXxB/FgK
	+GsgupW9rqzjPR2aaQ+p3H+bCNcVHZLQW7zD2eotc0pwTZX06asF4dG6VlbLKABkaxho2t8svQ=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:690e:4381:b0:660:321c:46af with SMTP id
 956f58d0204a3-66487e9c9c3mr777975d50.59.1782377014523; Thu, 25 Jun 2026
 01:43:34 -0700 (PDT)
Received: from 487349027555 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 01:43:34 -0700
Received: from 487349027555 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 01:43:34 -0700
From: Feng Wu <wufengwufengwufeng@gmail.com>
Date: Thu, 25 Jun 2026 01:43:34 -0700
X-Gm-Features: AVVi8CeguG-HI5DfZk2gIfvZ6eJLttmpX9LTGVnAIo5ahBdl4acpOCNXM2N4pR8
Message-ID: <CACK3muo02e6N3Yrwu+twkcEOSd1FMD55-ATkPqbeFutk=0jHkw@mail.gmail.com>
Subject: [PATCH nf 2/3] netfilter: xt_dscp: add checkentry for tos match
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

The 'tos' match registered in xt_dscp.c has no .checkentry callback,
allowing userspace to insert rules with a non-boolean invert field
without any validation.

Add tos_mt_check() that rejects invert > 1 and attach it to both the
IPv4 and IPv6 'tos' match registrations.

Signed-off-by: Feng Wu <wufengwufengwufeng@gmail.com>

diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index fb0169a8f..878f27016 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -49,6 +49,16 @@ static int dscp_mt_check(const struct xt_mtchk_param *par)
 	return 0;
 }

+static int tos_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_tos_match_info *info = par->matchinfo;
+
+	if (info->invert > 1)
+		return -EINVAL;
+
+	return 0;
+}
+
 static bool tos_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_tos_match_info *info = par->matchinfo;
@@ -82,6 +92,7 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 		.name		= "tos",
 		.revision	= 1,
 		.family		= NFPROTO_IPV4,
+		.checkentry	= tos_mt_check,
 		.match		= tos_mt,
 		.matchsize	= sizeof(struct xt_tos_match_info),
 		.me		= THIS_MODULE,
@@ -90,6 +101,7 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 		.name		= "tos",
 		.revision	= 1,
 		.family		= NFPROTO_IPV6,
+		.checkentry	= tos_mt_check,
 		.match		= tos_mt,
 		.matchsize	= sizeof(struct xt_tos_match_info),
 		.me		= THIS_MODULE,
-- 
2.50.1 (Apple Git-155)
