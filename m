Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C5925A357
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2026 14:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773670644; cv=none; b=SwSX9gBryKhkxuHqdZgx/5yXvGqElHckHN7twkn6vO6KZ0GsS5lqEKkRPN4/ff6cIzRMXeXcUxaUuyy7ZqvvW+EN1w3EqMiKLbKe4FogoSrp6Qui7wYgwD+Y3lVtF0GOp2CLMhW5eJ3+tgu59efFHfNUCRMjlaBnyLxcLH9ay/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773670644; c=relaxed/simple;
	bh=4Z2qzk5Ei6buOSvL1uoB7WYzWktw+4PTaBBcJFiSR88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ilI4N82j5sizO1es0Wq8C9qyQRx+woisOkPtDjccCyRxFIFFBuHFM7xqF54sH2hll0zkSUkrXKkcOcwWz1p1jZ1mK7bGawON8siCpQg2fqlxImC3yWJ0Ax1nwKwvivKhiWJUUooyOQ2YLjIhY0I98YsQOfPY/TP9uraGNBoxMJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZPnm+8fO; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZPnm+8fO"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c739561f0d3so2916934a12.3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2026 07:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773670641; x=1774275441; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QSv1Zj3lLaPDzLH9nA9KrRnqBcKvmT/TBKcQ0cJ64Bc=;
        b=ZPnm+8fOjpmAC0qxw0X6BnYPOQzwpc0XzM3hsRY/wmVL5+5YYd6vM0qMRgUPAZnEPg
         hNvgZvxzvOObTkD7PFw/x4vZ7bAK1cZsfZPPbbniye7uNfXxwpzNvkuujWlWrfTF71bT
         MQ3hlpxK6SMWXocONat9sUG+vGS0I2MYFfkSOmUxysC8ZtlfMUgNdqtJpCSq3mUl+Zig
         yZZFp8HKYYUOICVZCm4YnW8o+2MQ2oET3dJSHhcG2oXc+A6xrbZnKJ//DwFMX2NgXNc8
         bYPrKC/O3aocLNdqcaEVjihAJ8SJeZIAq1QTxloWUmIDsKeB6eAMfAN5Kh+udpSnN/KS
         ZYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773670641; x=1774275441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QSv1Zj3lLaPDzLH9nA9KrRnqBcKvmT/TBKcQ0cJ64Bc=;
        b=UYM7VfVyn8D6mi96BhaUDIsf9w3gW6B/A/HPzdI0JE0Jt02LBCVsGIIleqORdGyGQC
         Y7IkkFYqimVvNQmmvf8rQMEPOSapmm2SvOq/fGjuXd4noPsUR6kwZQBUW6EYCdsqlvgI
         uY4VfksIRJI8tJOYLeJnlNmGZimAzaIQLFQM2K388DGfqFyskrdSU148riF+Ky30Wr92
         K1fxEbZyp6xS8MroaZefF6jnNtMhZ7vQz4v/iJJHIWbN3f2SN6G2keb8Cs+BzDSSP4qC
         AuRI6t3MFFPjKFqI+QwAiD7s510OCNoAkYPLwiZcj7kD25YdOcKmgvp3QnKx8tp4PhIJ
         Hmsw==
X-Forwarded-Encrypted: i=1; AJvYcCXtq9r427AfcKz7brAwyMK5qhPQYJggJBrCS49n139sWMIpiUKRwbL7YVbQk1HRcizo6LcqzZiT9CAiC1TRA68=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkteU23sRNh8XRBv+2RJTYEFPe6/qdGMz+1u1NwEGxKvY+n+Mt
	v0KdP9APkfNd8ys4B9jCJOTPU2K0cs78TPj48sgAbmB+TMkeTLmTY3pc
X-Gm-Gg: ATEYQzw5KwWvUrQwEPqMe2UU5Ji9JjqfQQqlkKQ3jFxZffpfR7q9c40MERvonjPwIA5
	91qKdN5kPBmkg1iZxn9DHhWLX9T/VvJVCF2hyeVMwfx5UMqzlXMyC5Qp0CW04kMO7DzDR2pXYtn
	YCT6YcGxHkjRZWbzEmMPGLFBdOELZi20NMPPCQGye49zfA97JFx0/o8DGnfXe4ZwcOTvae/fxqH
	k5xGBS0X2CxoJ+npnk5N02V5wyHe1MOwU//xccoNMzbo1J+zfzie31MQnmb/8ZQwr8LqsYw0P8B
	HjjFRwUcg+ZXsgFqFwUy8jIX7GX+16L46zVVpDM3HUY8IxS0UZrnup8ov7TDxcdj3Z4FUNKiyo0
	vVQzB55yRZuCwImGC+LKmebv/FBHghWaH8O2LjBPbmexo+tb8VpRrqzG5Wv6/+4LdrgIrbDpQuO
	6OVU2mIuJi1X5BMFabNVjJpB1kLUCN+AqdlNQUvq4BUQ==
X-Received: by 2002:a05:6a20:6a0e:b0:398:9042:724 with SMTP id adf61e73a8af0-398ecddc025mr12516918637.67.1773670641362;
        Mon, 16 Mar 2026 07:17:21 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7401588f0dsm4385618a12.23.2026.03.16.07.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 07:17:20 -0700 (PDT)
Date: Mon, 16 Mar 2026 23:17:16 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org, imv4bel@gmail.com
Subject: Re: [PATCH net] netfilter: nf_flow_table_offload: fix heap overflow
 in flow_action_entry_next()
Message-ID: <abgQ7GSjz2v2_QnX@v4bel>
References: <aaxe-uH2Qr6qM4E9@v4bel>
 <aax2yZtJce0d19gd@strlen.de>
 <abfhRFfZ1LOgWEsf@strlen.de>
 <abfoTBGLhav-iPQb@v4bel>
 <abfuEe_PpDCyA64B@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abfuEe_PpDCyA64B@strlen.de>

On Mon, Mar 16, 2026 at 12:48:33PM +0100, Florian Westphal wrote:
> Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > > Ping.  I'm not even sure if there is a bug to begin with, see Pablos
> > 
> > Sorry for the late reply.
> > 
> > To clarify, I triggered the overflow using a dummy device that accepts
> > TC_SETUP_FT, as I don't have real offload-capable hardware. The 17 entry
> > scenario requires double VLAN (QinQ) + IPv6 + SNAT + DNAT simultaneously,
> > which is unlikely in real-world deployments, so it is hypothetical.
> 
> If you triggered it, its not hyptothetical and needs to be fixed.
> 
> > > Normally there should be a check that prevents such a configuration.
> > > If thats missing, please add one instead of increasing this define.
> > 
> > So, should I send a v2 with a bounds check, or drop this patch?
> 
> Yes, please send a v2 that prevents the overflow at configuration time.

hmm. So, based on what you said, I assume the run-time check would look 
something like this?

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 9b677e116487..69ffefbdd5e8 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -218,6 +218,9 @@ flow_action_entry_next(struct nf_flow_rule *flow_rule)
 {
        int i = flow_rule->rule->action.num_entries++;

+       if (WARN_ON_ONCE(i >= NF_FLOW_RULE_ACTION_MAX))
+               return NULL;
+
        return &flow_rule->rule->action.entries[i];
 }

However, if we add a runtime check in this way, all callers of 
flow_action_entry_next() would also need to handle a NULL return value, 
since none of them currently perform a null check.

Because of the potential risk, this would require modifying quite a number 
of call sites carefully. What do you think about this approach?
