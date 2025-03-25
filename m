Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E770318BC3B
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 09:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742894465; cv=none; b=j1Wrsl2YGzzv4923gKisgv/Ul1q89jlpeCu7+u/Db5UiD36FHoXsCTMyqQ2QWgqKrKZng5t/4O4dpDJ0Ng0ahF+5ALWnjZUsIoJDs+Uq6UB5qXzb82ExOGfNOonbyUuHbjgn03fS65Nq9UZEDXeKFYXWuPc1ddHTqYq+lCj9/6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742894465; c=relaxed/simple;
	bh=pqObpeULzxNezvRKJMNcNN1JYF9ygEOKhmQ9/T8n8/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWaMKx+jddQZhXfqgT2t+q5B5HcWq9U+SZh16vSRur5u756P0v+rP+warroDKxDxCVTUtqel8I6Ai6tfwTr+SXIZrqYoNIVpwz/lhWSlbgZIrId0uQj7NOxgSdAJWQ6TFc/2LRBew0M+KRJ1mOOT+HjkFAnEgVwjov5D/wRWirA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=V3cCNAdZ; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="V3cCNAdZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1742894460; x=1743499260; i=corubba@gmx.de;
	bh=pqObpeULzxNezvRKJMNcNN1JYF9ygEOKhmQ9/T8n8/k=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=V3cCNAdZbiVznQ15SMn+pqxCzzG6kTfrgsgxLzHIUkE3FjHm4LfpCRfBkUZ4vW/f
	 6U3d7yLfZoGhDSQVZF+lpY8XNYoDSH7oqGelk9w1coJzH8Xjg28UKu+95+mf18fHH
	 owcvKmvu54bhfAopB0u8dgoFtUzmEttS2GlQnn7+AMpTYjKN34iEOT0s96pyKxTQS
	 eSN+oa+7EZCIzcyH1r1ddgZPpGyRMgIkxEZ+YAjUuLmOSOhwM6YIMWSFPVti/x6tU
	 ngQTs7Q6YKSFU19NXt9tGs2rNrh4haiTSRb2Xp1Jg8v24+Fy7uPI49iELIw5dhAGK
	 Rw7TLKS7e/IC6NjErg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MV67y-1tX3Jl2cOE-00N3XG; Tue, 25
 Mar 2025 10:21:00 +0100
Message-ID: <fb5de8d9-f106-4352-907a-461f3323ac88@gmx.de>
Date: Tue, 25 Mar 2025 10:20:36 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH ulogd2] nfct: fix counter-reset without hashtable
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <ef47491d-5535-466a-a77b-37c04a8b5d43@gmx.de>
 <20250325055651.GA4481@breakpoint.cc>
Content-Language: de-CH
From: Corubba Smith <corubba@gmx.de>
In-Reply-To: <20250325055651.GA4481@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:p3AD94MPyFdUjoBGdHv8B4YU8YwlDJIkvbFxF7cfK2eaSI1c0GO
 fjO+dqqL+6su+rhPvwDCrnVAuJaEOwTCnsEUqlbbacRJuD7i6gA9IDE4yICbJx3/I6IIi2/
 33DCSj1z+nc4Huk7Ex4HlzWkBvM8zdVxzT0arPvgsO0o44HRLGyXqeVfKVYclTKAmOAWnyQ
 0db2IFXsnb9YsFA4b2wsQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hivmW4EHQlE=;uExYAI20sRhnMcW0ujdh2bdUS84
 gmT9/gnA+augA89Xzag7K6zeRMSYa95Lq5hgvaJebXFnvec5+LLVuHC+hiv1xVequkSVWg4kS
 qYJJTGJoSTloVPZ2zfn69E/WEfs6ajEhzqS1OIIgVme7ydOuFqifzbYWijLTeqAEY2v7SWzK/
 Jm4c6xWxDrPH9T89rAqP6L+8XAZo+M1w7qVqriSS/tAudox2hxktOkbrHeM6UTMQDd31NIgkq
 EVSsx54NVsBWo+DWIaNDsNDyd5vB5cXjVRV5vYT72c7RFxfA5wc+Oj43HC6XseryDiuX8rQFv
 Qqe4Ar0572dJCYplIhzeayy5eTfmUg/b9C1o5umj7RhNnZdm0XXW4mBxVTsycAYCdIbBEEDdD
 GTgqRBI3opPYgHuu9fgukHpTPzMTIvEXTDI/E7ZFAw9We54SNWI8Eh+NioaKFPf5Gfvr/96ML
 xpCC9CNe9mv4ap/upkHneWVv+dJFhSXHl5SWuW13YlDXXjlVFrPPS7I2k9QXZkSzl95ONzJqg
 4S5nCwn3+bfWDwhkbh+iDUxwVh62+VcTXkGC/95afBZR8SmcAZGnvbvJB8PL9NZAmlb9o5VIT
 jBG8WU1cqyf/GFuazPKcrp+6rRDVDZC4+KFYUjmAwcdfqGFr9KUolisRSM34G9qJrVDYN2148
 nd00xrpg38P0zAxrTZJ8lDMdKqONO1RxWMrOq7IxBTVtO6SDBM+u8zB2/XuYh7RR7FdGpRku0
 PropAXVg/0gZ0lcDoKssUKCdT5gRpFMXnSGdjUgiQpODhKtslMzHfVwXycwihvkN5nwTAntWZ
 TBpX/oDqK+C17d+5qdQvKfkAG//bUtKCDRIyIFeI2aXkTeGVWQPzRG+4ZbuKMQX//uTalfF4y
 iJY63vrGuDiHrmZ7UHIHYtJuJxfM+lejvCJ5U/HCIRaWH+RtmW1EtBgXzD2XLfZkGqBUxpYAu
 Xx0y6H3KKjJ1hRDo5shXpvkPwlvjoGdC+TCMLorCxwOYiKAPxOjR1j8pRzMzZQHGxw1YgIu9C
 urF0Z5+cxyGcHK+IOP3dScTxlUrDDMxu42BexmTwj+J9r2RWLZXXiKijnPrsmXAotTq3bwJh6
 utz69dYcCoVWsKw7ibaG7PXH2TkYQqC6NI7gK8WM7fsqx+MPjkqmZYjoNL9dLI3T14OHbpeiI
 Mx/DLmCJuS8IupZTDJ/+E0XZrruLMEH62IhY7wc0exNRbxvwFqbVTvAyVOVGqLhENNZk9rK6W
 iBRJKRONgJm4YIf+HOSHJ4+LXhyd15fPWtcYe0vpqBrkIdE63qBFzqEzJmZEw791h/WhZChBC
 hsuwr4xwHxTr+ghaOSL8peuI5vDF2i2DU+dbubF48VH20kmef030G1PY4QoMuu4HwONt4m/++
 1qweGvSQwKYC1JDXoRWIEuiDIThd61kn0spIC5Cs4i7ZubsHQJH7h45B34PxRDYqCctoAehK2
 XBlBFzhrncLlMH4CRlgQvwkh7r0c=

On 3/25/25 06:56, Florian Westphal wrote:
> Corubba Smith <corubba@gmx.de> wrote:
>> The dump_reset_handler will try to update the hashtable regardless of
>> whether it is used (and thus initialized), which results in a segfault
>> if it isn't. Instead just short-circuit the handler, and skip any
>> further result processing because it's not used in this case anyway.
>> All flow counters in conntrack are reset regardless of the return value
>> of the handler/callback.
>
> How can this happen?
> constructor_nfct (->start()) will return an error if ct_active table
> cannot be allocated/is disabled?
>

In event mode the hashtable is optional, and sending SIGUSR2 to ulogd will
call get_ctr_zero().

=2D-
Corubba
