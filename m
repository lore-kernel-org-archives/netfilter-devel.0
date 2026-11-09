Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794192192;
	b=X7di1LzQwjx/r4zw1XltUaPPy5NBPeI4HJwvkZg4TLrghHMBnlqt+Dye8CpddkPY+XzD
	 N7jt9hFJ2MRUV1NTvfAZU7hRRp++ugifgszlmrvtUGa1dIlHBeejQNJ3PoSDFWTUofQCM
	 89DycRE8ShvZfkC28uxg/PwejW+6bLFkvk9QCfhk8XeBjoBr2cXbnWXSPKyKy9y13Fugw
	 +8EbbshcTUfLEGZ9q5lO9djS3/zGmQ/H2trqQ2PKpcpXsshjmmnxiUor56lvT06dj+ocx
	 TDSfydL5pAYc92XK3ibI6lQw2rdW4fmNDvm+YVlWhZSTF9GCDngh2xnIcKrMbXQx4dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794192192;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NiHIrQhN1EZBJeOzVcCEIjXlI/nm5F+3CXiAQu+5P7k=;
	b=OPd0Hvt/66blieMZ6kUzgSn+obd8kJzZl88Wam4lkUxVUL9UWelqSDT79XtiNED8I20n
	 Rhv5web8tBKG/3dy0cuqf3lPXWApKhIp8XlzKWMda8FipxExQ2/FTGctgWb6NNcY9rjff
	 YbkzeBZLMbHywkA8sLHuIqKOBugz3gOy9Hyx44twTa9fDW42uq/55M/KV1q5cdC8Ll6LX
	 jdQ66LxC04z+YGwPOOzBueIyP/EejibrPo+KM2Gyoz/DXU6oDMp9jhETFbnbZxEu86kGp
	 whHyb3FUmFJ0C8rmEZt20OibhDK2ZTvke1Cz9PPTkxoyS2IqDrBpD059Fb3xNeTG2aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF369606A334;
	Mon,  9 Nov 2026 02:43:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF369606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3D46A60490; Mon, 09 Nov 2026 03:43:09 +0100 (CET)
Date: Mon, 9 Nov 2026 03:43:08 +0100
From: Florian Westphal <fw@strlen.de>
To: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: "pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: ip_tables: propagate compat_table_info() error
Message-ID: <avEzPLSvi6meDDXv@strlen.de>
References: <YEo_4lnonRc0-_Jotuzk7hOaWl3QockF3xDwJ4cE5v8uBvy1KW27Eku0fWDJycuoZ9AgGFxsxgtSWI6SE2kNJ38eVnLx-HtApOhBw0wxXGg=@proton.me>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEo_4lnonRc0-_Jotuzk7hOaWl3QockF3xDwJ4cE5v8uBvy1KW27Eku0fWDJycuoZ9AgGFxsxgtSWI6SE2kNJ38eVnLx-HtApOhBw0wxXGg=@proton.me>

Noah Weinberger <NoahWeinberger2003@proton.me> wrote:
> In the IPT_SO_GET_INFO compat path, the return value of
> compat_table_info() is ignored: on failure (vmalloc ENOMEM in
> xt_compat_init_offsets()), private = &tmp is used anyway, and ret is
> overwritten with 0 after a successful copy_to_user - so a 32-bit caller
> gets stale or partially adjusted 64-bit-layout size/hook_entry/underflow
> values instead of an error. The follow-up GET_ENTRIES then fails with
> -EAGAIN. tmp is fully initialized, so there is no disclosure; this is a
> robustness fix. The same pattern exists in ip6_tables.c; both are
> patched.
> 
> Affected version/commit: mainline fa4ad798f6f681031775266044ba1b0cf3c670bd (v7.4-rc1, 2026-11-07), net/ipv4/netfilter/ip_tables.c:968-987, net/ipv6/netfilter/ip6_tables.c:989-1008.
> Longstanding code.
> 
> This was found during an assisted (AI-supported) static source review of
> mainline fa4ad798f6f681031775266044ba1b0cf3c670bd (v7.4-rc1, 2026-11-07); every code path cited below was re-verified by the
> reporter against that tree. The patch below has NOT been compiled and has
> NOT been runtime tested, and no reproducer was produced - the triggering
> conditions are described above instead. Please treat this as a report for
> verification rather than a battle-tested fix.

8-(

net/ipv4/netfilter/ip_tables.c: In function 'get_info':
net/ipv4/netfilter/ip_tables.c:992:1: error: label 'unlock' defined but not used [-Werror=unused-label]
  992 | unlock:

8-(
