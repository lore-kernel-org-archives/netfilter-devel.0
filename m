Received: from mail-wr2-f9.google.com (mail-wr2-f9.google.com [74.125.225.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE63B55C32F
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 15:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091806; cv=none; b=Q6yq3u62wUOheqnMUqfUG1KOIPyXHSYNP/i6XDb7cMhaQqpA/uCQfVoPI7Ed6IZEwMr6+c+GjFZsHF2hcuzbGwAj2Et7K87VQmuM4hzxygM6erhpRTrwFnMQXKxcZ67wXl6ZpjWG7iSnPuF6s6BHAVZ7n4MK29tkSd1mxp6nkr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091806; c=relaxed/simple;
	bh=GRqgTHPRWnG9IwMRRfG26N3mDu61p8pYCpytvjGSY1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hwf75GCmgNKLjiZQJEbcIygVILL7nMTlonTYADZcGhl11KgKCRuOuswS1Ab16ktI3kEG4XEqaCsu/D+UYMJhlM1b7z+2CBxpxQHf/2m2agaN1/1t3cNjFHm7X7osj4icvc3l0a3tRxyaQrZ3RHKoF/+ct7QAGZ07orr1jZnCYl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr2-f9.google.com with SMTP id ffacd0b85a97d-485850cf4deso26093f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 08:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790091801; x=1790696601;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QhvTPOuk38OAJeKZ6IPjN37kqjVi+x1d9H+4Ju5mOtw=;
        b=v6i9csg3RuQKGQlDcTjW7P/jgJfXt08TuWvjmLfX53GFUSMq55Y4epO0ZuGv643cwy
         AfxbQaQSM5Kr2xfUBypmxobKtrMBYrxfjiCxDBXR0z290LAmwy+C+Rincflwqo+UXX0U
         T4vkGwiQRKnIE/N66DW8mpZHqFVxen5uhV8t4px/yuAxE7Wm2g/L9VTUsjeRS7fdEMqA
         QsI0bXPbSS96wLy6Fus3bkRrvPkMnPe38F1EEftMHWOvKrI9yx3iOqFlhOswDO8lKvUI
         vjgSrn/9tfKj/xGCLoBwPPQ4HwnwD+SgjR+Y/ZaRJgs+38msPrLXrJdkVUFTHx3OspcE
         ceEw==
X-Forwarded-Encrypted: i=1; AKwUvBzSieDu43v98PgNeC4tzKUnOR2lJrK9FE238vr2S0PGaIDhXeZ3CGJvPu2cmr2/ccw7B3P/l3tmdDBloRevYIM=@vger.kernel.org
X-Gm-Message-State: AFuF++kyIgpcjXY5Z29du81wL9LtKNzrj7bBh4qJQojvBfliBUm/xyrU
	XfL7PyqKQ18/aeYljaumF86DpCSg1vxOWQ4pBIQBGFMqBcnXARFKq1VG
X-Gm-Gg: AYBFou1iZN55Es094tgeWF/DsVqAf6B80YBf+I4BHqfw2Y072QUSASK32Pr7QLv9bQu
	rhM8uM3ua8t8p1CX2ck8VKX4hv44UOdw7e2XjiTyOVkaV+7WWBXRbtdAngzRbynVCWMvNBxDO07
	CNuy1+N0nZ7Ya8HMDlA0LcoMBZAUiKMy6CoZlszDi+tPKRKRz8KzX3w+7jwx9tQ3XYZNd2b518+
	JxUpiFbVuGt+kBR+P9mHuhMJGCW9R01H2w4yMqI5UqV0oPh1aZ3VFQmj/H1Jgs5pKLHRHRMR+43
	BUk/jRVdHjeGdoNp1d0ri9QVv/ym8OnxBSuh1nMZl7HfbG50WPjf2Hi6e0d8YoZQcpJstA11h72
	3ai/OggPBcN9LhPM7nMPHOkVig8xDnEDptYBql8FqoaYsqva3W3gBym2TSzN1XSUwI5Wapy3EML
	Bk122hu5dCFe6fSoWn27Ce6tNTvl28DqV40MGhB52lrB8CKMkLkUXXiEGU0bd6w2eJQmbJNDBGV
	kym5Lx4iICSt1PvUDfXVssMCx8nimqjOgcbLcU1FmH1Gkw=
X-Received: by 2002:a05:6000:2004:b0:487:242a:c020 with SMTP id ffacd0b85a97d-4886704a921mr11085f8f.6.1790091800734;
        Tue, 22 Sep 2026 08:43:20 -0700 (PDT)
Received: from [192.168.88.241] (78-80-107-225.customers.tmcz.cz. [78.80.107.225])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48862773ee0sm5831124f8f.6.2026.09.22.08.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 08:43:20 -0700 (PDT)
Message-ID: <51f0cbae-71e3-4b9f-af91-55a610eb15d0@ovn.org>
Date: Tue, 22 Sep 2026 17:43:18 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 3/6] net: openvswitch: conntrack: fix helper UAF due
 to extensions realloc
To: netdev-bot+sashiko@kernel.org, i.maximets@ovn.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, aconole@redhat.com,
 echaudro@redhat.com, jhs@mojatatu.com, jiri@resnulli.us,
 lucien.xin@gmail.com, marcelo.leitner@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
References: <20260921145655.3167436-4-i.maximets@ovn.org>
 <179008911935.2160803.14933035266780079917@kernel.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <179008911935.2160803.14933035266780079917@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/22/26 4:58 PM, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] Inaccurate newly added comment in __ovs_ct_lookup()
>   (net/openvswitch/conntrack.c:820-826).

Same thing as for the previous patch.  Comments do not need to
spell out everything that happens in the code.  The intention of
the comment and the code seems clear enough to me.  So, I'd keep
it as-is, unless someone thinks it needs more clarification.

> 
> Pre-existing issues:
> - [Low] Concern (INVALIDATED by later patch in the same series): the
>   identical helper/expectation use-after-free was claimed to remain…

Preexisting and fixed later in the set.

Best regards, Ilya Maximets.
