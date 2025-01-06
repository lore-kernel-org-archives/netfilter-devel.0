Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F9115665D;
	Mon,  6 Jan 2025 15:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177281; cv=none; b=rsj+g4b306o2sgpkUF9iwM3KxqzW0+h4O3VUcUYH4enCL10pUD9WmVPerjVUkI8ewgzfwqUU1/EZEKD+0pFq9paly53dvrfauUNc9bHXMhVa46oi+dkyQi4jB7O/ME+8bdxSDCAB333Z4Wv18rpSRXYrogBizDMhjDt3EiCuT7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177281; c=relaxed/simple;
	bh=ZpGHfXJzYyi3RZNBlhgNiJe2kBFbc6YPAClKvu+MjAs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Gk0BmgptibcvflET+RJnOcqwKAKcDm7rxa1wbDdOhmBsGjxklAqGsV4gZwZR68Y0MbTSWoiVtzvIUW3i9R9Dy3HyF62Zx3wrsh9N4bYwOhS6rxjXG7ctIuL1GMUFmfJRi7cBht2YiXxc8gslDbKjWo1wEhVNZfpnCcoLnMv5+hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id A9A1D1003DFA62; Mon,  6 Jan 2025 16:27:49 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id A7EF0110073C1D;
	Mon,  6 Jan 2025 16:27:49 +0100 (CET)
Date: Mon, 6 Jan 2025 16:27:49 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Andrew Lunn <andrew@lunn.ch>
cc: egyszeregy@freemail.hu, fw@strlen.de, pablo@netfilter.org, 
    lorenzo@kernel.org, daniel@iogearbox.net, leitao@debian.org, 
    amiculas@cisco.com, kadlec@netfilter.org, davem@davemloft.net, 
    dsahern@kernel.org, edumazet@google.com, kuba@kernel.org, 
    pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, linux-kernel@vger.kernel.org, 
    netdev@vger.kernel.org
Subject: Re: [PATCH v7 2/3] netfilter: x_tables: Merge xt_*.c files which
 has same name.
In-Reply-To: <6f276b2e-de9d-427e-a3a3-aac9ed340357@lunn.ch>
Message-ID: <7ppss971-6406-82q4-3371-1q8n9299qrq1@vanv.qr>
References: <20250105233157.6814-1-egyszeregy@freemail.hu> <20250105233157.6814-3-egyszeregy@freemail.hu> <6f276b2e-de9d-427e-a3a3-aac9ed340357@lunn.ch>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Monday 2025-01-06 15:22, Andrew Lunn wrote:
>> x86_64-before:
>> text    data     bss     dec     hex filename
>>  716     432       0    1148     47c xt_dscp.o
>> 1142     432       0    1574     626 xt_DSCP.o
>>  593     224       0     817     331 xt_hl.o
>>  934     224       0    1158     486 xt_HL.o
>> 1099     120       0    1219     4c3 xt_rateest.o
>> 2126     365       4    2495     9bf xt_RATEEST.o
>>  747     224       0     971     3cb xt_tcpmss.o
>> 2824     352       0    3176     c68 xt_TCPMSS.o
>> total data: 2373
>> 
>> x86_64-after:
>> text    data     bss     dec     hex filename
>> 1709     848       0    2557     9fd xt_dscp.o
>> 1352     448       0    1800     708 xt_hl.o
>> 3075     481       4    3560     de8 xt_rateest.o
>> 3423     576       0    3999     f9f xt_tcpmss.o
>> total data: 2353
>
>So you have saved 20 bytes in the data segment. A 0.8% reduction. If i
>was developing this patchset, when i see this number, i would
>immediately think, why am i bothering?

Before:
$ lsmod
xt_TCPMSS              12288  0
xt_tcpmss              12288  0

After:
$ lsmod
xt_tcpmss              12288  0

which is a 50% reduction in run-time memory use.
