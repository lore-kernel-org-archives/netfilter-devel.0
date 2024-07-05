Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB5A14AA0
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2024 15:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720195004; cv=none; b=Yg4Gemn11wyqFRk5OjUUq6zVRPpsxvs1SslufPI8F8/0auDAsRs1AL25qpMl8DblhCN+kIk/3Y6IjDqoVL3Z75to/t7k7x92JtnmPIt8bM33uYqMY+piF2XtberGJDpFPZ3Uag89CgZPi3boRQr3pdLB1j2U6Y8Lx05MD4tsays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720195004; c=relaxed/simple;
	bh=C0u4zo6MV58JrrqQFCG5TEn75gXJ9kD4bFArJXFvLn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=VgAtBziQbQuNr0fFyqFM31PRs6EO/Usod0TILkHqJD4h79h7yptWJcnmZXqXCXUaTQNlLwstaC4AG/wy7DRt1Bylae5MQyGtM2rsKy7d0PCn6t4lwElUVt9fWUkdBgYU1XUhoXFBYcLHyXOgTmCVR2356NmyAe49L0QRSSBBY6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ZTGSQO1n; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ZTGSQO1n"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52e9a550e9fso2554875e87.0
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2024 08:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720195001; x=1720799801; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C0u4zo6MV58JrrqQFCG5TEn75gXJ9kD4bFArJXFvLn0=;
        b=ZTGSQO1nkmma6vaCizUe58tdR2EgJ2JxLKrjGiP289FRmgl3KeE6NX5fYucNQBfcKJ
         SyIMP7QBFGdWbGaxDV9zekvkOR925oJuinKx4z4jiWwwKfwXPSHgLZPaIFZQq/MhFLeP
         4Rhv9YPghsDLwRbwKWcev9x6CsPfc0W8PnJz4vwg+2CI51AFsq4pFN0rSIKicoyolYl7
         VMJPFs0ZkgFI6rPZkNhGil0Xk9QzS2Iptyk235NJ0Px+LFqBK02mshaArfJJVyIX17rn
         KTg9KgEwq/DbooesR9wYMgh3h1jVv+HnfW/21emC9PzhPl5NkFxvqHrrYNNw95rq0yX6
         d06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720195001; x=1720799801;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C0u4zo6MV58JrrqQFCG5TEn75gXJ9kD4bFArJXFvLn0=;
        b=ZAn4GJAu85uH6frL4sQ3vq1hboHNiPx9PLh6hc5CoCtsRmc2Q3y/WDBiW8IfmxJuhY
         jWxOucJYWae0YaxuFFaAss7YK0i0rogHAYVcfPd50YoHfIbntFk8+RC/Wbfqw3P9gWgI
         EMBJBR1eqqH3of276qZY9rycUn14OnzlSVKwSG1vDDzFzgAYCshWlY3tmdrWST74WqDP
         BZnecO0z7kNaE1IKuSqsbqaCb8eUIhjCFVumhLME2xs8xTIqT+TaBpVYAz/vYAdyI/rN
         20U9tOc7CIlg5sZ55/YQEsn+TDkurjR/kxXinEM8OVvzg8uYHcF08388QLaRpvZA1wbt
         JDPA==
X-Forwarded-Encrypted: i=1; AJvYcCWbiYYd+KKScKV3ycyoeVaQT3Ugrm69ibEm/NcKqlMuXs+5gsGtE8JVJrLBn1HBLrsVDzQOFkVlnjw2w6HpcGaiMNdGtJT5KwbkbRrF/4p9
X-Gm-Message-State: AOJu0YymaTass4xbL7IF/+yO2wzr69xaRhcyOq87zSuWrruu5hXCES+D
	25IqvlI2X5IHh/vjBMvWLaTil/5DztFDh8qIDpsrkTv5/rmOucjGYYONsg+gnHbMRAWyTXlEnlP
	mcS1J/1b43AKSvdHBTM1X27flRI3LIBhz
X-Google-Smtp-Source: AGHT+IGLLRw/tyaU93DhCgRjSzFqGYIZLbtFyaE5YE3WHDmqj9iGtPkDbgMIoU+49AgISMidBFwUZR9l7xxTshl4nUE=
X-Received: by 2002:a05:6512:3e24:b0:52c:ca8d:d1c with SMTP id
 2adb3069b0e04-52ea0dcdbb8mr1875648e87.2.1720195000597; Fri, 05 Jul 2024
 08:56:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMQRqNLQvfETbB6rpAP+QabsVGdwDmA0_7bxhK2jm0gcFQYm9g@mail.gmail.com>
 <ZogRDinLhQeOhY6O@orbyte.nwl.cc>
In-Reply-To: <ZogRDinLhQeOhY6O@orbyte.nwl.cc>
From: josh lant <joshualant@googlemail.com>
Date: Fri, 5 Jul 2024 16:56:28 +0100
Message-ID: <CAMQRqN+S6487boLi98hGSe-X9-8aM1XkNS+BRb+dMS+4hGiBhA@mail.gmail.com>
Subject: Re: iptables- accessing unallocated memory
To: Phil Sutter <phil@nwl.cc>, josh lant <joshualant@googlemail.com>, 
	netfilter-devel@vger.kernel.org, josh lant <joshualant@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Phil,

>
> Could you please try with current HEAD of iptables? I think the bug you
> see was fixed by commit 2026b08bce7fe ("nft: ruleparse: Add missing
> braces around ternary"). At least I don't see a problem in
> testcases/iptables/0002-verbose-output_0 when testing with either
> valgrind or ASAN.
>

I was unable to build from master due to some other issue, but I
applied this patch to 1.8.10 and now all the tests that were failing
with segfaults are working...

Many thanks for your quick response. Have a nice weekend!

Cheers,

Josh
