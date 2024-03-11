Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12587481C7;
	Mon, 11 Mar 2024 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710172877; cv=none; b=Pd3B1RPQVcAPxB4UJYdcApx0eJyhnA/O6u8CXUN8vUjEvp/IMIqsL6s+Ohus8SdV1vI45WK2YvvsTF3GYj2SIOjfThTeAO5hgaQwmm7KJonVY0PcWoCinI06l/dvcIUFC6cH5m+F44aWRmlR/nOpRElPGBI/ZyBhibfJw02Zoog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710172877; c=relaxed/simple;
	bh=41zQ+Cg5MleRSicMlSKoc5t0f5kKFmpCToYhvnKVog0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eOrz6HnzXHvKo59J/xJq3Yzxorum6brE9CgBOhkOjRCV3bCDVszbdjT4eFayz8sQjt3cP8rqZmCKan19YhVeVpLUcprtVqJOF5LlWjAsuyG3SPjTHOw/XJZcW3a9MW4QDIyW+A/puoP+kFknB40ErkdCtq+EHZrRLJyBDNLID+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LVm7v3Q0; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LVm7v3Q0"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-563c403719cso5481994a12.2;
        Mon, 11 Mar 2024 09:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710172874; x=1710777674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=41zQ+Cg5MleRSicMlSKoc5t0f5kKFmpCToYhvnKVog0=;
        b=LVm7v3Q0nyEEvDH0HcDCtPrmDx2hsc+6vv/R2ILYdcn0VLdzH4xenw9f2WT0/73mfd
         ipHmdZqJ9mV+k8lGuoFhLnh52gOpJ6ezmDn67AbVV7p2bLTqMoR6MJ5pt1CI1oA0Sq2p
         wHPFBlJkWDDoQF+j2+tioIlkWFxjMqwIFkdgHXIuXaclgqsc1VJa16WdnYmSNzV6RaA5
         btkB8fPbV596cXOqrNJDzTBS2iIObRt4W2k+bmabDxTz8j+272VKQFrk96PheKeVc+LD
         FeSYXbGpnhKb6nUOr8JmhkW76dKL70qLFAEYvMW//6rbb9gJxQpRKusXEEF+a/tbFXDl
         frJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710172874; x=1710777674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=41zQ+Cg5MleRSicMlSKoc5t0f5kKFmpCToYhvnKVog0=;
        b=YLsh3aATjRSWRh3Xe2nGr2MUo0WL14hK3HyYloY7h0U17lbWdm8cWqRYVIEwoOozUo
         8n9s5mUZpLWiuzwr5+OXcxqyn2a63InaxzHiEjy3c5xxeKw+PQ6DFSRrLf0NngsYu+DQ
         yRQmzAj/m3jFM38W6WWdn8HJuJAv1boQmpBpt+BW+HnYvVpQH69wQMMOLgOVbHAvcmEn
         D00Gg/OkpNubVR0YyxrIepusLbgKPBOuM/a1fMSIHJKmSdac4npCTXjJRLKiCgRZ/5aK
         EzO7DeEIRGcnDPQB2D1r4NSyzTVoks18TYwJyBcaskBNJZ/qHSj5EgclDWmj4TY0vFQ5
         UEQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIMc61b74/bW4yxBxzXXLIoFQO/hxp40nDze1f3Ily8GVhTcbm2lHSX/uuFCZpF71eMC+k2XSXiGnlzWbtvH/pZiavdu50frOVFN3Grl2YwDqg6seoXwrbB0WUtMQkP/0sQ1xzcTda
X-Gm-Message-State: AOJu0YyNHunRA6qXkshJcwgZnLWhaIDFUZ3eI2yFxGkdTOtfgF0xA2IQ
	MGxEYiveGaon5rTrKG33KPunt8B9vuT+jiYhCOjiZAFqPT3Pg3ZhFve9bViZpK8l88yFI5UHe+o
	FbwVVb3rX64pdebgJahKxUd2M36E=
X-Google-Smtp-Source: AGHT+IEnl1HMkP8uN8zzAUacU+gQbLT6o2a0BYYMzppWl3gat0wOwOYaShNr8zSLjLtEZkIyN5isMSlMi1SVVADQS30=
X-Received: by 2002:a17:906:71cb:b0:a46:2729:c42b with SMTP id
 i11-20020a17090671cb00b00a462729c42bmr581058ejk.71.1710172874178; Mon, 11 Mar
 2024 09:01:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240308092915.9751-1-kerneljasonxing@gmail.com>
 <CAL+tcoBsTjTRMiFzq_EHyYSBr9rROO-QFY5PZ3Aj-M4YDLpr=g@mail.gmail.com> <20240311085632.2d0742e6@kernel.org>
In-Reply-To: <20240311085632.2d0742e6@kernel.org>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 12 Mar 2024 00:00:37 +0800
Message-ID: <CAL+tcoAv=nBRyRVFhgKkAWu1v5Uhs4aNxBxTRPs5YE89R7sf-w@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: dccp: try not to drop skb
 in conntrack
To: Jakub Kicinski <kuba@kernel.org>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org, 
	fw@strlen.de, pabeni@redhat.com, davem@davemloft.net, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2024 at 11:56=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Mon, 11 Mar 2024 14:37:25 +0800 Jason Xing wrote:
> > I saw the status in patchwork was changed, but I've not received the
> > comments. So I spent some time learning how it works in the netfilter
> > area.
> >
> > I just noticed that there are two trees (nf and nf-next), so should I
> > target nf-next and resend this patch and another one[1]?
>
> I don't think you need to repost, you CCed the right people, they
> should be able to process the patches. But do keep in mind the
> netfilter trees on next patches.

Thanks for the clarification :)
