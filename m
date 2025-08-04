Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B862459FB
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Aug 2025 09:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754298342; cv=none; b=amONIpiiAGyyI9dU6Xfn1RqZ9kpP80bQSwXMAtY/l/DdcbZ0/yLITIjoP8o1v5RmvAVfUsrN3gY4Dowl0z7nk3FZlJS9J+7SnW35VvMaxEHhx0phuo54dxLhF1q4aVySRPJTNtaajWtykZNlEHJqPLvpZDVCsdY5hlg71VsqtlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754298342; c=relaxed/simple;
	bh=W66Ew0ttV9jwaL7xfBSlvK56EHKwGj1ftyRMRvCbtC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bvZfXcMAygiAIpYFPh+GuPZVPzxWZz9AabzpY0iUp+hcEQWbfy690jLK3tz8sXOmHCjRlIY92TrAR7ATzp6sXfAp94ka+So3uLz93uJd57goPHLAr8uhx17Bu5PszwG964M694O97gBCj5Yyl0K42otiHilJKwwafROH0LWI5KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sz2AO7n9; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sz2AO7n9"
Message-ID: <0e275ffe-e475-40eb-ac19-d0122ba847ae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754298337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NapXP2Jph+pLsihjmqq0NOSKBA6gNq976atLp5ZQGbw=;
	b=Sz2AO7n9lT0KuglY2g40VwyrdAefOcp9fBLrdRC1ghcK4VVw1He58VNVRucIIpmEu/5RK7
	eeV7VoMvlbqGk7JIuEwN6i4QGMa/OYmv9VxlHrqc1oZPIvaMsfsgIyzhWvEf9Skd7QCRI7
	JDXvjBmDz+XplMr/N3DQHNIv8NqswQE=
Date: Mon, 4 Aug 2025 17:05:32 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [bug report] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Content-Language: en-US
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: netfilter-devel@vger.kernel.org
References: <aJBtpniVz8dIRDYf@stanley.mountain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aJBtpniVz8dIRDYf@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2025/8/4 16:21, Dan Carpenter wrote:
> Hello Lance Yang,
> 
> Commit e89a68046687 ("netfilter: load nf_log_syslog on enabling
> nf_conntrack_log_invalid") from May 26, 2025 (linux-next), leads to
> the following Smatch static checker warning:
> 
> 	net/netfilter/nf_conntrack_standalone.c:575 nf_conntrack_log_invalid_sysctl()
> 	warn: missing error code? 'ret'

Thanks for pointing this out!

> 
> net/netfilter/nf_conntrack_standalone.c
>      559 static int
>      560 nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
>      561                                 void *buffer, size_t *lenp, loff_t *ppos)
>      562 {
>      563         int ret, i;
>      564
>      565         ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
>      566         if (ret < 0 || !write)
>      567                 return ret;
>      568
>      569         if (*(u8 *)table->data == 0)
>      570                 return ret;
> 
> return 0?

That's a good question. proc_dou8vec_minmax() returns 0 on a successful
write. So when a user writes '0' to disable the feature, ret is already 0.
Returning it is the correct behavior to signal success.

> 
>      571
>      572         /* Load nf_log_syslog only if no logger is currently registered */
>      573         for (i = 0; i < NFPROTO_NUMPROTO; i++) {
>      574                 if (nf_log_is_registered(i))
> --> 575                         return ret;
> 
> This feels like it should be return -EBUSY?  Or potentially return 0.

We simply return ret (which is 0) to signal success, as no further action
(like loading the nf_log_syslog module) is needed.

> 
>      576         }
>      577         request_module("%s", "nf_log_syslog");
>      578
>      579         return ret;
> 
> return 0.

It's 0 as well.

Emm... do you know a way to make the Smatch static checker happy?

Thanks,
Lance

> 
>      580 }
> 
> regards,
> dan carpenter

