Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACDE33A6F2
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 04:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790569753; cv=pass; b=ky2SvjxR+B5ow2OECwNejCx19iU9ha4okyx9n3lgVYYus121fmZhiJYVloxfqhxqecBhDWxP2j837JeOAF8Ot7fwqsurOszu+gosDt4JZVZqdB+lYDN35V/5b00w7PvDps+1lJsqwTZLF4tZMCPql52sWEo/B4mS21xagZxMx84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790569753; c=relaxed/simple;
	bh=Cc3Rs/HFoYxnQJtyAWsDpps4zoIxWHTErRApJAjwabU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kzf3NG9Llq0UDSCtCHzBhvQs9ou0dJbrH+l67mmsuLd6DwdM2g6Zz+e9dguFjB1OsZwFOHxMoaVTt3Bh6Uiy5odhG261eFokTeypFBF9sPzE6Ot6PU/kjWk34n1nHthxGPXmEdOhKpsIvq1ic2eRmW3YQj9FrTarVc8BYmDTJFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pXeAuRn+; arc=pass smtp.client-ip=74.125.228.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pXeAuRn+"
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aae6345fc0so357263a12.0
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 21:29:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790569750; cv=none;
        d=google.com; s=arc-20260327;
        b=MNfBpAh7x/c8KMZ1fRBEm7/qMLpUDq4lAgMpYZ9A6FWBnESb2uINNEm8QQsViMcyDm
         ZAIYtldGD+9PMy9xM63fZFdDFXzKHAVpKZButA7UA4/zzsG6BjRd2osoqFAvoiuoz31A
         ZSn04+loVM/Vq3P4FWEAEH66hbAjq0XYvatiwMHTvyCasZH+ZQnWbJNyo3oTRQP0W3vh
         fVVY1IwTLCXY7dxp7qbzjjWatILKBobn2VyMsT/QGbJBiivpqUp8kHjd6Ze1BF99ofV2
         BXOAX6eBvkybwZ9oX0ZlLpSBNJuZbqIecCiZ6SQyPDIypz9TcRKFjkbqw4tf1CpGFYoi
         H8yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Cc3Rs/HFoYxnQJtyAWsDpps4zoIxWHTErRApJAjwabU=;
        fh=zq4lizH5PIFGGnNORTwuf4twn535r85BGynmuxClb0c=;
        b=T5Rcj7tbjXSw2KW90QzHUGmPqvteYs0dcel6hNM1mloB5Bqd5ZfloWT69wTTHcynnX
         kgknCpKDwAHViVkGq4pJ/dNL3mQpTYCZG732bpbLgmqLAymZHDiBcou03zQNDm8OoK1E
         sJv/2vNrLrELWUuUYjgZFnOutFIKUxFdpH53GKbI5X7MGH8Q6QU+6/4b7dhT22O0iWDu
         Hua8yRrNP4tozfj48UuWbZtaonGsUK5iG6mV/xhJvLVIIBTtMevCIO/Zl/bHTG0lPXYq
         kqjU6waxOkXkA2zOVt0SY445dUwuHJ7duHCAQuz5dRc8L1NgDa2y1RNdcyCIiRt7BQ7/
         9EzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790569750; x=1791174550; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Cc3Rs/HFoYxnQJtyAWsDpps4zoIxWHTErRApJAjwabU=;
        b=pXeAuRn+ddF0PVsymMqgNegnGtg1b4NAlpiPCuZWb0JVmQveDaksMta1+Q44/vX4z4
         NS6HMRtM9oO6PxIr8aU9hrqqfEjpWfV7r7A/mhhvnVHkCS8JUDnz0f1SeHubW+k25th9
         AEQ3+TRnwDhEyqsP85VLQ4MBCQjhGEQ1yvJHBrW02p0Du9YvKmZ3E/r35tAt7PLs1WVB
         oUh5C+nDcI9y3PJiAZ5w0nOZBskz+4ncjzLN9h0VgKCsc32OHgy2mVK5++GsjJME4WRa
         HbdStvGQvFu617YocpzNNzgoiqiBHOWWwYX2sxaiyY1Hn0plWJPNamCVavi4dhMMmU0r
         Efig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790569750; x=1791174550;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cc3Rs/HFoYxnQJtyAWsDpps4zoIxWHTErRApJAjwabU=;
        b=M4HSgwD5dfLV67j9X56lVrCwddqXRRH24Qyu68LK35nF+v2adLLppCZrINF8pg2A1n
         hIIiEaTrbjEh6awxzCCddju9fLsJh1BUBKr5w6py5fcm0d70fcWJSOevBOCT9RD41ITZ
         jWUEWEUxYfngQU4w8wHEXQeJ9x8jfHS6ffkEk9vl3CEBTOQscL3KQobI4aT+7xqz4xwz
         oSBik8QLwMlZmhdZzEGkYbhJnBznAmfad0aXe9CODe6K96Sblr0MOCRNFljYlJhpKz6N
         GafyCPPrpUsomhDb++UxENaPXih+y9fmZHJU5v8EjY9uMC1hN+NIn/KJvc6sBgrziYZW
         oPhw==
X-Forwarded-Encrypted: i=1; AKwUvBwgZLM2QlYDxxRijwX8pXEu3e3D9c4OW7hEJ948XCe9wFiGkgjKypnklZikc2PvhTU0EzoJhVUdl1t3ykCyVpU=@vger.kernel.org
X-Gm-Message-State: AFq9FYKYpV/9+l23Z4A9RCuj2yCA8iCAXycG//nlW1UqDjJKQTN2LdsC
	hV0x0FbWn93UZ7HtDDkzHoRBv34GABYBBKx350MFbZitSZj4DK4MmUb/DZzLPbymdxgiycR9Q7O
	R7lr7WuMS9jDBV/kQd29uG1XcREIapg8=
X-Gm-Gg: AYBFou2kYwzw486V2s3T9aNSekMriD+Pk8oSVqRXoFnptHExwmOlv1PaNfwopTRrtV1
	27g9OhR7GLDR/3bl2cMW26lR3CFSV1idaR3biPNJHDHcUa0Q7bI9S7qruuj8S2Jlp6/hEkUsgNb
	EbFmNIeRRX5sMJCgkJ4lo/hei7NWybv4OtyYnJ1a6AfxnwFp4Jqaj1w6MtdR/0z1AxktvX2SJSc
	JcYZqRVPj1fHBS2aXhe/y1xA1/RDZkvrsBAuolTwCku56WKSz4G1ahWYfwrG5/wsv+H8woweFLy
	DTTHSQanJipM//NNR16xheD1BV3xvyW09y4HYeToii433xs/g428U4FdrtQxJ+19IVTH1uZgEOw
	2BhBtU1u1fvg=
X-Received: by 2002:a05:6402:400b:b0:6aa:91c2:63b0 with SMTP id
 4fb4d7f45d1cf-6aae1fb697dmr8030974a12.2.1790569750079; Sun, 27 Sep 2026
 21:29:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260927071520.3693598-1-nicoyip.dev@gmail.com> <20260927150704.62c8c919@kernel.org>
In-Reply-To: <20260927150704.62c8c919@kernel.org>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Mon, 28 Sep 2026 12:28:57 +0800
X-Gm-Features: AclHuK-9Q4O620Fsh2sXCA3XvsN6P-GhXbVBeaaDb7-HyX3to4btQrRt88NoqIw
Message-ID: <CAAo+4rV+99b1ZaiA6EnNBAivfbpOtq21wSMJNC9OeQ2wLbHqXA@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: nf_tables: serialize offload stats with
 callback unbind
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 6:07=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Sun, 27 Sep 2026 15:15:20 +0800 Chengfeng Ye wrote:
> > Rule GET and dump requests collect hardware statistics under RCU withou=
t
> > holding commit_mutex. Callback unbind removes entries from the base
> > chain's flow_block.cb_list and frees them immediately while holding
> > commit_mutex, so RCU does not protect the statistics iterator.
>
> Slow down. Please do not submit more than 8 patches for networking
> at a time. You can revise the already submitted patches but since you
> violated community guidelines we ask you not to submit any new fixes
> for a month.
> --
> pv-ban: 1mo

Hi Jakub,

Understood, and I apologize for overwhelming the review queue. I had
accumulated these fixes over time and submitted too many of them at
once. Sorry for not carefully reading the submission guideline.

I will not send new patches to the net or net-next and wait for these
already sent patches to be consumed.

Best regards,
Chengfeng
