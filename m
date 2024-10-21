Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119C4282FE;
	Mon, 21 Oct 2024 13:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729518454; cv=none; b=Xu9x5sCvK6olabs3LS81LiC+Rab7q69aZF5GDTD+8yr2oWGa4vhQGoBW7qSNlhvV8aJty79J8sM2ZzMkny/vo2dSbf3B0dud3hiz+EHcZbWVdSsimkQh+PYAUqjSPAV8yeinQSbjhOM1Cvj9abvXYBn9xuyNO5HN9t0NqS2Ar3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729518454; c=relaxed/simple;
	bh=pZC3YbqyBViAPdxBqxiw35UgPV0nDZR5cXq4uA20i5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bB4c6OykYfcOBEf47DuZAduFs+qMdHQnABNFdDwA+po7ufjCw5bYwW0bwkTVrLrEVVvbnBQMPOu++xKr+g2RQLCS0tg0i5noroTczhq++lt9MEJOwyMFJ4HM52CrDX+AysjSs2wRtc/MxNAE6AEymsYsKkvHMnS/9eIpoFfpeJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M0PWyLVo; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M0PWyLVo"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a99f9fa66fdso50435866b.0;
        Mon, 21 Oct 2024 06:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729518450; x=1730123250; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L0PguM/y3AdR81087UZxaCc/iTHakbzKnJWRYI0kM+s=;
        b=M0PWyLVoIDwyPdP0bxZgNWzrX42vE0+QYoj2stRvDspSjsVcTVzisFZdRw5nsgrs80
         dHgRzZX0xGkqtLfwWyektp0iZ8A9Fr93xlhuwH562DrUQLZpTk/5RtxPUcjn1wIr0YKP
         1BaS4txAvRi4m0c9LItavDmpZmRpXLlRY7kUCGWFOVMqRLIvyZKs0PVKCwev46NTzRFM
         YuW9MVfdZCpto9OTMjsrGrVEgc/1wyQBgBB83mQ+0HnCJe9A2/kMWZIe+lgZR3TxrtMk
         vRX3P4w0Es7OGSWv1hDWTyomT/lm99q4CncaGdUJsjLi6LcTs/XQcf6mRFcd4YS71ZJz
         8gyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729518450; x=1730123250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0PguM/y3AdR81087UZxaCc/iTHakbzKnJWRYI0kM+s=;
        b=uD7ashQ6pc3PrXpBv0MbGB7Gul7rjzmABOKZUg/zbxhLN2e+Tv/r87Sgnq4enqxr18
         CQrugf7XaLMdvle2qOB8gOmWNcS1VWAC8dcGaENJ7YtxgHmhnGwazgfMI5hCUlPUKIfS
         bAk71bZiBdrweZDMf//x1EaTCUjU3Y/HgJvU6WE1TEOVgmtkyzUsHZxbC90/KIDBgkDx
         fldcIYuBgZlxHJt2jon9lsC7tGADV3VlMcPbyu2Dg+tnHvUid5XhTYONsmpYcmPTEeyA
         ds3AyQUCkqOIWY6Fcs9jT0n7Kt0Q8HKnREdoU8tRSgel6iSxx9XU57VBKbrjq02nrTc+
         S1cQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSe1Z/a+e480ozo1W96qip1L5VXo0xt9hb3JqCe0VlL+pqkMgQJ8QYc+ye2EvmhCl6pMPOTPkwU0saof1O8l/L@vger.kernel.org, AJvYcCWV2jbg3AkCcIZB32mAXq+hnHePOgW4ywgRgKBneH+cSdu8hgUbHnHhQ2v8/6hdCZI4e1yAOA24@vger.kernel.org, AJvYcCX2jVA7xlWW3g7p9x+CF4HKEYXtfIEMlip9g8GrAK2rTVdH9cHTa1vawJepGSRk5BQcP+GP9twF1jfs24g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx811PpiVlWgGjY1cvAHXnKz5CZ/y3gQbYxrpdgwX0ZJK4QPzSr
	5taiGfllE4wk0Cst8Xz5jCVcSW0sFhgfi5Q9dDzjnXiYRE8FEqLX
X-Google-Smtp-Source: AGHT+IHllwIsaig8SX4FhN+AvinTZ5nJRChFYQ0yBVkHaCSnwF1lUgDNNoWUZkrrdij66hbn5eP8Xg==
X-Received: by 2002:a17:906:6a26:b0:a9a:5b78:cee5 with SMTP id a640c23a62f3a-a9a69c685d4mr437986966b.9.1729518449909;
        Mon, 21 Oct 2024 06:47:29 -0700 (PDT)
Received: from skbuf ([188.25.134.29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91370e54sm204503966b.102.2024.10.21.06.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 06:47:29 -0700 (PDT)
Date: Mon, 21 Oct 2024 16:47:26 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH RFC v1 net-next 11/12] bridge:
 br_vlan_fill_forward_path_mode no _UNTAG_HW for dsa
Message-ID: <20241021134726.dzfz5uu2peyin3kk@skbuf>
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <20241013185509.4430-12-ericwouds@gmail.com>
 <281cce27-c832-41c8-87d0-fbac05b8e802@blackwall.org>
 <6209405e-7100-43f9-b415-3be8fbcc6352@blackwall.org>
 <20241014144613.mkc62dvfzp3vr7rj@skbuf>
 <b919a6b1-1c07-4fc9-b3dc-a7ac2f3645bf@gmail.com>
 <785f6b7a-1de1-46fe-aa6f-9b20feee5973@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <785f6b7a-1de1-46fe-aa6f-9b20feee5973@gmail.com>

On Sun, Oct 20, 2024 at 11:23:18AM +0200, Eric Woudstra wrote:
> So after doing some more reading, at creation of the code using
> BR_VLFLAG_ADDED_BY_SWITCHDEV would have been without problems.
> 
> After the switchdev was altered so that objects from foreign devices can
> be added, it is problematic in br_vlan_fill_forward_path_mode(). I have
> tested and indeed any foreign device does have this problem.
> 
> So we need a way to distinguish in br_vlan_fill_forward_path_mode()
> whether or not we are dealing with a (dsa) foreign device on the switchdev.
> 
> I have come up with something, but this is most likely to crude to be
> accepted, but for the sake of 'rfc' discussing it may lead to a proper
> solution. So what does work is the following patch, so that
> netif_has_dsa_foreign_vlan() can be used inside
> br_vlan_fill_forward_path_mode().
> 
> Any suggestions on how this could be implemented properly would be
> greatly appreciated.

I don't know nearly enough about the netfilter flowtable to even
understand exactly the problem you're describing and are trying to solve.
I've started to read up on things, but plenty of concepts are new and
I'm mixing this with plenty of other activities. If you could share some
commands to build a test setup so I could form my own independent
opinion of what is going on, it would be great as it would speed up that
process.

With respect to the patch you've posted, it doesn't look exactly great.
One would need to make a thorough analysis of the bridge's use of
BR_VLFLAG_ADDED_BY_SWITCHDEV, of whether it still makes sense in today's
world where br_switchdev_vlan_replay() is a thing (a VLAN that used to
not be "added by switchdev" can become "added by switchdev" after a
replay, but this flag will remain incorrectly unset), of whether VLANs on
foreign DSA interfaces should even have this flag set, and on whether
your flowtable forwarding path patches are conceptually using it correctly.
There's a lot to think about, and if somebody doesn't have the big picture,
I'm worried that a wrong decision will be taken.
