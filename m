Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E9F32B99E
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 10:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769769168; cv=pass; b=IIlhkMST1THVAhpq/5NqJ5hwdjaXmz5R+OT6wKlgDlI+YdEutobCcGVD5TzHej7cAFCtsqZ8fkgk+f5TXiX6pDPNG7aDtBVewEMgufOgh/i+RuxdHk4cM1vNsrhRv4Kk5SqewBHLAl+0IOQsgrz3dyobqhL5tnLDmutFEoQ/j1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769769168; c=relaxed/simple;
	bh=PM+crK4N6TQe9RH0AMdaTWLLQaP/RG3fAKprYEzGy9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tKLe+C2djMrjfIgrX7WBtJ8Aex4nWNEM7/d1Fp9QZJM7Q/QxESHZHstnEGH/z6k93weUkrts7vN5wDwDsdWAtBjkfOoFf5YUC3KNEaMXTFlh31yIWUJeJak2G50F5PhqvD/WANvww6BAhf6xE68p2qpLU+7THoQqAmG5H6ST+Sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tYdmt+1B; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tYdmt+1B"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8946f12b1cfso22548626d6.0
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 02:32:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769769166; cv=none;
        d=google.com; s=arc-20240605;
        b=OyPXRqLTvBd7jlRFOYWy4TQqiw3lpJzuXVc90QjN0WhoO2VjmMdqINF/I84zmm4nGL
         MugKzwedfVlJDSpxK2FDEmsIC/9hl0Ey2URNrbay8ElNRmThPWrbH8n9bCzn9J5PrSeK
         l1U5JmIzHbezN8DhEojiyQOiI+NhImqtIRyi2qKxK+rU2BrO6T++ofBkBsRNWyxbAHbW
         5OKZV6O8HVjPWatoQtUCuwJyPgnnR+JjkR0YwFUMo/b5avieVZxckrhwbm9xmwG6gv47
         OT+U5TvdhxCf2XGLU2Y5NMOwpgWFSf+mbh6PVBEhhhWehzPcpPTTOIvjxA4clxaOHdPj
         iDuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WKmx4RJI0M3ErZSi66Ul/ZO3J0tfze4ljxzxFgky70c=;
        fh=KARL3CxsAjwDfSu4p3gPKt/N2vzbt6Hxw0oXyWOmmfI=;
        b=CeFdkJxDXDBNL9r7dv6i4E/A4SaHamOGhqopE4dwjTyVoSr7B6HfaTYyR7ym5oun6r
         9nH3HxsWZPuMWj6+p/wMGWy7bcn8cDFsSrxIoRXjQj0KQ0pQljnzwMTKVB2tEAIAIKaL
         UH7HSH3GhOwOiMP/JYlD5iwGs0pmLogOK0xcpGHPfv4Mauje9THgtpy+osi3iPfP56pw
         OOQF8wS4IcGAhZD+1KpP2VBtIMd4/j97x0m5kVXvE0ADwnWTPM143PLm1UWbL3sPnX4o
         btn9QrLYLt7KRSw9JckIuz8oOT2wGLuTBYF/Y+DgKQXxT4+iwzCZkSrgxxsCrHKPjT2b
         wRxg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769769166; x=1770373966; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKmx4RJI0M3ErZSi66Ul/ZO3J0tfze4ljxzxFgky70c=;
        b=tYdmt+1BAKbQ882qp+R5RKM2QNVDviROFiBrxn6hDT65BKSOav9Bvsiz0aaQZvXIkZ
         87bjpITBLgHZc9BJ/NZLwkSMEQ9iOHh3PJRmqcsZn9cVu9XJ9pamuru0rwZtWtxjC/Yk
         Obg201FuUyhf7tZ98cAQ+ARdME8MhtwqzC9gt+rC93R2ViFeOlt6H0JNh0aLq1S925nb
         AWFXvY3T5Oc5BNnFx/WwnCXXPCzTsegwKea6a0fAGgrprlnCJhMh9PEJs4oNvl/l2xhc
         r5XHGShUCssEZ5Y13dH5GTCP8oJa21CKVdD/8CbQCfGjhMuihcoibf6hJSgpnm469Pab
         Xq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769769166; x=1770373966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WKmx4RJI0M3ErZSi66Ul/ZO3J0tfze4ljxzxFgky70c=;
        b=mq7qvSR0bFPweECP0smCBjeqkZm/hA+3nb5GVwOpsjxU3lkfcHowJebk8yoe5a6H7y
         YSeIJMv2A6E6CINC4TE1ZsxRvllto+0cqIrbynk9vwiLrvI39ZM3o2v6nF+y0s3/swCj
         t7RoAxKU0nxfM/ZhYleHwLmJaKuwkUZ2PJAf9nEpPs93p7k0ttC4Te87PKApsw1isj4a
         0889TQcMEWbdWyN1nd+x8wswtZwfsEFX3iI0L+avacAU/s4hbYwuAPdckkmfcbKfu8WE
         uEdPjTumRyGTb1F0SZ8lq1GxKapvT3EklSKdl4BVEJWN26lZYrXEGX5XctsXwKpdgRdd
         mgmw==
X-Forwarded-Encrypted: i=1; AJvYcCUoByiG7dEWkAtAPPBzvdoc6DkuFaPlmeuxFQ6FEo8F1aPe8aMm6EWrzKZLzet74FktSldPT5C1Evovd3q8gok=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBfJbVwW12UYKI8UihGG8zcwWdrltVn++dqTByNccQlNz6s107
	zSaKNnXZI0RiVLHG/RNlCcdN1Wtzq26tI9ZZcuJ9uIByr1U+ExkJfRLhbucH/ozr4TnR/L15S/n
	2DIRq9eNbLdXlBruLQh6w/MLCXJ+hkRzFTOuyGlqQ
X-Gm-Gg: AZuq6aLHwnF/kPW2GcdkNMqvQdDnjEvwzn+uWatwpjh9ocCwYaVGfqrE4nqqKV4ytt+
	Ba1QqKLt/CdH9InpaXC5aduKxNkzL+VLWD9qMttjSoFnxM3srJQbve7fJLD8GfBw8niDj06Ah48
	HGDtDycIM1hvb4DJcudCRkmAHGAhSCQ/uXgAwMcHwcMlnO6Lq5dKj8+/WJ1R6QQOBJf0V1705zq
	U+IpuSGf8vIETgwqgmn3jRi16NcNj2dW1GTBH2Lk3X8agzqKYQSP6YsN6t3Uk9DhZl9ixY=
X-Received: by 2002:a05:6214:c4c:b0:894:6f51:b4b5 with SMTP id
 6a1803df08f44-894e9fb0dafmr31281676d6.30.1769769165826; Fri, 30 Jan 2026
 02:32:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130044348.3095-1-lirongqing@baidu.com>
In-Reply-To: <20260130044348.3095-1-lirongqing@baidu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 30 Jan 2026 11:32:33 +0100
X-Gm-Features: AZwV_QguFHUo17T64TFpbIe9PBPhtFTxGSaH6-PWsbeemZcAQsG-P6tB82iuhLo
Message-ID: <CANn89iLetxqpxpSBpQztPcg=av38nGNr2VpOo7HARrbqubREyg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: conntrack: remove __read_mostly from nf_conntrack_generation
To: lirongqing <lirongqing@baidu.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2026 at 6:02=E2=80=AFAM lirongqing <lirongqing@baidu.com> w=
rote:
>
> From: Li RongQing <lirongqing@baidu.com>
>
> The nf_conntrack_generation sequence counter is updated whenever
> conntrack table generations are bumped (e.g., during netns exit or
> heavy garbage collection). Under certain workloads, these updates
> can be frequent enough that the variable no longer fits the
> "read-mostly" criteria.
>
> Applying __read_mostly to a variable that is updated regularly can
> lead to cache line bouncing and performance degradation for other
> variables residing in the same section. Remove the annotation to
> let the variable reside in the standard data section.
>


> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  net/netfilter/nf_conntrack_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntra=
ck_core.c
> index d1f8eb7..233a281 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -204,7 +204,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
>
>  unsigned int nf_conntrack_max __read_mostly;
>  EXPORT_SYMBOL_GPL(nf_conntrack_max);
> -seqcount_spinlock_t nf_conntrack_generation __read_mostly;
> +seqcount_spinlock_t nf_conntrack_generation;
>  static siphash_aligned_key_t nf_conntrack_hash_rnd;
>

What about nf_conntrack_hash_rnd ?

I _think_ this needs to be __read_mostly, regardless of its current
location (it might by accident share a mostly read cache line),
especially if your patch puts nf_conntrack_generation in the same
cache line than nf_conntrack_hash_rnd.

Same remark for nf_ct_expect_hashrnd

diff --git a/net/netfilter/nf_conntrack_core.c
b/net/netfilter/nf_conntrack_core.c
index d1f8eb725d4223e042b02ab86ba89b9b7caf75f5..0a705fab2bb73f7590647ff06d7=
066395e6eea66
100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -204,8 +204,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);

 unsigned int nf_conntrack_max __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_max);
-seqcount_spinlock_t nf_conntrack_generation __read_mostly;
-static siphash_aligned_key_t nf_conntrack_hash_rnd;
+seqcount_spinlock_t nf_conntrack_generation;
+static siphash_aligned_key_t nf_conntrack_hash_rnd __read_mostly;

 static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
                              unsigned int zoneid,
diff --git a/net/netfilter/nf_conntrack_expect.c
b/net/netfilter/nf_conntrack_expect.c
index cfc2daa3fc7f340937898b4bef0769fd31f801b5..4dae405527febf913af43c49ddb=
2961a8f05e0e4
100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -41,7 +41,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_hash);
 unsigned int nf_ct_expect_max __read_mostly;

 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
-static siphash_aligned_key_t nf_ct_expect_hashrnd;
+static siphash_aligned_key_t nf_ct_expect_hashrnd __read_mostly;

 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,

Thanks.
