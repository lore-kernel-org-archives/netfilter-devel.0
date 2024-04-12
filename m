Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD79513C3E0;
	Wed, 17 Apr 2024 12:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358343; cv=none; b=XnfZemMLD9JFnagHVEtvJczs3c3EnrMyu4WLN8Kj3OiUrJE5OwkOUtXTxpzYEr8tJQ4z4XhCwKobpFPwqs6UsUB/33b6VoubdTRBh+eIbR62OiTfO9cr7CLc41RNJ/kl81AJVzRZcWgN4XkXh16U0Vv9d+5YPA9A/0nZXDottUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358343; c=relaxed/simple;
	bh=GKwwC0OJ8qTLZqlAyHGWZALDR76oktdMPcYkUMRED8E=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=ejDKXXeWYrywJXKBWTK4L9Jwf5iIDj+krnHh/1JWOfOUMSScQRk58DN0MYgt0Kh/Gm7VuBVvDHsExzdWWzeIuwG2uGxazipF7p/3HHd5q0Eh1Jj8QJdm+Dg47xdA8cs//ar2CcrxQ1Nr7Gxq+Sk33Z28G8UTjNm6LyMj2MK5x90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yz+FmA7O; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yz+FmA7O"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-78f04924a96so24288185a.0;
        Wed, 17 Apr 2024 05:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713358341; x=1713963141; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EuBc5E44cBkpe2s8uTRcWQCylcIMSOJ9KujKuoAaf8c=;
        b=Yz+FmA7OIzi+nO+DF2CY/3tGI5HNm0nkKMJQynHAsMOBSefcFC/qbm/ERCm7c+YR9f
         7s9oKGLtG4xDDfyG/qO6ETZ9N1VEzIC2xMQYAUwMgh/+G6ubJI5J1eUIQQSLEaCDTpfo
         D9iojA6J+Gm0apekpk9ihG7okC1YQmRzkHkIcyL4BmWrw14e0qKwFB16Ym7CFuad8b8/
         HOYdLHky9+o5ul1uUO+7ojzxFE6X8xxwNi1BPfAVZYhm6oZebN287MGdd1OmAMGIsc+e
         r/KaKJnrqYfd/ca/EkDp4QKG9mFPK1Lf2yIXkUma0lExai65ScbuBrWKfO+cAmrNaeaG
         Wv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358341; x=1713963141;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuBc5E44cBkpe2s8uTRcWQCylcIMSOJ9KujKuoAaf8c=;
        b=gftgBHudmojWCYiAxsoBWW4jJ7ilbVgJSIqQV7c2pSEwa/rw5NakKdHFCccI+kpd04
         ZX8lfYOSMiw/6FlXekPigoeezfPlvNfNteqJKOpSKk7tyPVAU5sL+FNer5792ZRlBbeB
         2QB30qaQFps4bAbNJb+OsBrhW5+FEHQD6DUPUvP/AGO8WLwBqfOdtDrt9OZKHTtgzylB
         bmJ1mAaS8GD3TVo27owiLjPm09BM6wiHzeg1+hbtfFRGz6wRT65KnB9Wfne0tvq/ZEP0
         1DP/lmK5CnzxYs3XoKHIhu891VaCNu23YKSC8H9uearXjN5mzUaD/ZJMGccuGQdZ1I0Y
         Wtzw==
X-Forwarded-Encrypted: i=1; AJvYcCUGibQceb1Nkv/jGgM8ZxiKNJI765l52A6MudZKa0tM/x13Qc7oFYyfxsWzjfp2qwkXAPuk1TqyDKKv17nJX8KfrTvMRv4f80nMlt51KUPF
X-Gm-Message-State: AOJu0Yyxcj0iyZy+Z0Lv9v7fY8vN3YEGEfWKCwFrTcz+XBo92E776h53
	Wl9V7hRN0TN7XKmlWa3dnfmJWzx06EsLF2O5WlVA/Z/cCrRB749G
X-Google-Smtp-Source: AGHT+IFuFjOChlyrCu41ENDj5+wqqR3go1+czOgkWcys0ry5WI4/gVhKVbXToQn760THaQDnWneGDA==
X-Received: by 2002:a05:6214:528f:b0:69b:695f:ad20 with SMTP id kj15-20020a056214528f00b0069b695fad20mr13634790qvb.16.1713358340809;
        Wed, 17 Apr 2024 05:52:20 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id v7-20020a0ccd87000000b00699413a7386sm8204953qvm.114.2024.04.17.05.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:52:20 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Eric
 Dumazet <edumazet@google.com>,  Paolo Abeni <pabeni@redhat.com>,  Jiri
 Pirko <jiri@resnulli.us>,  Jacob Keller <jacob.e.keller@intel.com>,  Pablo
 Neira Ayuso <pablo@netfilter.org>,  Jozsef Kadlecsik
 <kadlec@netfilter.org>,  netfilter-devel@vger.kernel.org,
  coreteam@netfilter.org,  donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 3/3] tools/net/ynl: Add multi message
 support to ynl
In-Reply-To: <20240411102522.4eceedb9@kernel.org> (Jakub Kicinski's message of
	"Thu, 11 Apr 2024 10:25:22 -0700")
Date: Fri, 12 Apr 2024 10:53:43 +0100
Message-ID: <m2r0fahpp4.fsf@gmail.com>
References: <20240410221108.37414-1-donald.hunter@gmail.com>
	<20240410221108.37414-4-donald.hunter@gmail.com>
	<20240411102522.4eceedb9@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 10 Apr 2024 23:11:08 +0100 Donald Hunter wrote:
>> -    def do(self, method, vals, flags=None):
>> +    def _op(self, method, vals, flags):
>> +        ops = [(method, vals, flags)]
>> +        return self._ops(ops)[0]
>> +
>> +    def do(self, method, vals, flags=[]):
>>          return self._op(method, vals, flags)
>
> Commenting here instead of on my own series but there are already tests
> using dump=True in net-next:
>
> tools/testing/selftests/drivers/net/stats.py:    stats = netfam.qstats_get({}, dump=True)
> tools/testing/selftests/net/nl_netdev.py:        devs = nf.dev_get({}, dump=True)
>
> "flags=[Netlink.NLM_F_DUMP]" is going to be a lot less convenient 
> to write :( Maybe we can keep support for both?

Good catch, I overlooked the generated methods. I'll make sure to add it
back in.
