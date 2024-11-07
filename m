Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8441521645F
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 16:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730998268; cv=none; b=LYurB13H+BaW0bYVQTmkKjXPAjTzmBSGhO6WQp7TEBBpFC6KvpRe8Os8d9HrCFd9k8PiWqP6JCgSmznsiQx5xe0RtICq4etuNqBtC/CUbRQqRWicejguRuGbJ2vOePkRAZX4mWqm3g/xafftAA7wwBmi8DqkYdjGfkk6Ad4z+gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730998268; c=relaxed/simple;
	bh=Ax8PvKAaeBz7uyhKXl4G7yQAQQk2QLZPg2Qmn7dBvlw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=uJPpyJFEbG2zkfKP4a4kVAj/iHXoapAkUd1Qp1g++/acn4dKdhBVTgL89+Mqq9vHSE4fPAvqML/ZgSHLFCPsZWynPfOfKMkLPmtYp0XtDl0lW/8MMf4qZ1YCU/3+mQ0KHuZH/54HEu2E+65KGsXIV8pA0rYDokLln+qvcudX7So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 457A91003C5013; Thu,  7 Nov 2024 17:43:10 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 45357110931000;
	Thu,  7 Nov 2024 17:43:10 +0100 (CET)
Date: Thu, 7 Nov 2024 17:43:10 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
    coreteam@netfilter.org
Subject: Re: [iptables PATCH] libxtables: Hide xtables_strtoul_base()
 symbol
In-Reply-To: <20241107161233.22665-1-phil@nwl.cc>
Message-ID: <8361oqo4-qnss-089n-885s-nqqq6520r6r8@vanv.qr>
References: <ZyzYApZKx79g8jqm@calendula> <20241107161233.22665-1-phil@nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thursday 2024-11-07 17:12, Phil Sutter wrote:

>diff --git a/include/xtables_internal.h b/include/xtables_internal.h
>new file mode 100644
>index 0000000000000..a87a40cc8dae5
>--- /dev/null
>+++ b/include/xtables_internal.h
>@@ -0,0 +1,7 @@
>+#ifndef XTABLES_INTERNAL_H
>+#define XTABLES_INTERNAL_H 1
>+
>+extern bool xtables_strtoul_base(const char *, char **, uintmax_t *,
>+	uintmax_t, uintmax_t, unsigned int);
>+
>+#endif /* XTABLES_INTERNAL_H */

Don't we already have xshared.h for this?
