Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590444A1A
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 00:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719449496; cv=none; b=haO3CeL7IfuSdWOzQsNSb1fPYJ6qhuKWQdoMgrbtx2wSklfpbOmW0/ZJoPI50uXKF8khRFrJ5F1Ak3xHUiC8p9D6bRIn5tOmzhe3P3OZBMMgW0HtHSCi6O694AujuNPzdgHQpVWKlsHgt5rE4Frn2o7GxKlLSYD6pHaeXWWl/yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719449496; c=relaxed/simple;
	bh=F8EoZ0KgtTlDrx+RHUhANavpveeXSZDay8RJ9TkoSWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gQYFiXTSxkoAh17apr85UKIIEAdgFX/y5BYJk63ahXibX9SazDbL1geu+g3+xdhesUwer79cr0Fz7ajYnRUb3SL0Bu/58oAcORNoG3m8TzcUeYhllbBRmM1xRx16/HXVFsQa1/8cWlorvNXfUaqS3SwIkljYNj1Y+4xWey7mxRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSa2eXcv; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSa2eXcv"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52ce6c8db7bso5408649e87.1
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2024 17:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1719449492; x=1720054292; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dvw1jFo9mXXB8AmAp5CxanBbcNFEjyqwIr5wHdhTfGg=;
        b=MSa2eXcv1hB5GQA/g64b2im0/6Ej57cv4Ks4cZ95/3T+D562DSj5mLOJeK00E3Hqrp
         cBZ+hBd/nuSiv+t3aL0m0zmKJzH+nZ4nwc/XgZjuC9fPRsgXP9xe7WY6r/U3vyHtt5KU
         fWFjBFqikC95fa8m95R0ElkYSPUGArjyb32hg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719449492; x=1720054292;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dvw1jFo9mXXB8AmAp5CxanBbcNFEjyqwIr5wHdhTfGg=;
        b=TpD3UqsgU1aFDaxdNW8iOVAMDPOSm4RLs4OJO29NWxo4fd0sy2rFJ0BPRQ/T8REaN1
         qF8MeRcrrIbPUgbNKFgzJZ/YvAInND5y5v9OYhIEqg5IqPD+2n8bIZIMmgA9nAE3lmzf
         tn/yz5E2wflq4tLD+C1QfefeAfxa5wOQSJzFy9+emz1OlJi+DrB/ne7cfQKH2JsOJyJc
         0kHD+1NwyXX34DhTXxM1+Vy/cq99Awdpk0JUkoVA7F8j3DicahL2ReDMhEkzhsdgOHRk
         rhD1k3lKR3Z0Y5h4VeCcB1CZ/BnFGeQcv6XtgaUUI18y6Uf//+8Dc53TeR1N25t97hUR
         KXdw==
X-Gm-Message-State: AOJu0YxMW+4xBexC0aRm7wwlgfvZg4TWUZC+7zZI5iplRXpBkBnqPEkG
	ZFuZKoilyDENRqq2ekB+JFOxVzu0Axa50YV9Rg1N1nctZs9lkTLXJQ9YLEYrKj9dh8Wn+vHYpWm
	7nmlhJg==
X-Google-Smtp-Source: AGHT+IE+YuTBVsLKf5ZOrV2CGcOWr5dkLnr9aCNOhsnpn3Ib8pTE0k7O4jZ0ncSE2WPYH9S1uo9NIg==
X-Received: by 2002:a05:6512:3a8b:b0:52c:e1d4:8ecd with SMTP id 2adb3069b0e04-52ce1d49146mr9871746e87.8.1719449492428;
        Wed, 26 Jun 2024 17:51:32 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52e7131a211sm21470e87.222.2024.06.26.17.51.31
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 17:51:31 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52ce6a9fd5cso4072239e87.3
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2024 17:51:31 -0700 (PDT)
X-Received: by 2002:a05:6512:78f:b0:52c:d5c7:d998 with SMTP id
 2adb3069b0e04-52ce183b2a0mr6378530e87.35.1719449490723; Wed, 26 Jun 2024
 17:51:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240626233845.151197-1-pablo@netfilter.org> <20240626233845.151197-3-pablo@netfilter.org>
In-Reply-To: <20240626233845.151197-3-pablo@netfilter.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 26 Jun 2024 17:51:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wibyec=ObQrd3pR+cUUchDGXFk3bTp435jOz+NP0xEzXw@mail.gmail.com>
Message-ID: <CAHk-=wibyec=ObQrd3pR+cUUchDGXFk3bTp435jOz+NP0xEzXw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] netfilter: nf_tables: fully validate
 NFT_DATA_VALUE on store to data registers
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net, 
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com, 
	edumazet@google.com, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"

On Wed, 26 Jun 2024 at 16:38, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Reported-by: Linus Torvalds <torvalds@linuxfoundation.org>

Oh, I was only the messenger boy, not the actual reporter.

I think reporting credit should probably go to HexRabbit Chen
<hexrabbit@devco.re>

           Linus
