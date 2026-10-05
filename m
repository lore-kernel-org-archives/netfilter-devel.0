Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AAF240611
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2026 21:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791235224; cv=none; b=mPpfM5a76HXijwA0GYO8btB87xAr06ArrEnfjPwR0BMB20alq6lIT+toi1Iw91xZCi/V39ak4QwRDlpmSdl02eoCjA8vOBv6HktLlxMwQQSig/JxrgwdhuyYnttemkVgKFiZPuakNU84Vj+4Ra8EutjslWPKpSO/YKcY1CggnOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791235224; c=relaxed/simple;
	bh=7XvMoZmtsZIWL3FDKVW6ia1/PqdjN347tZrevHVbUYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fw4mBw3oA1D1VN1ql3lfFP6JGFY6UkUD5zrbRRQZcw++OT/7VFFdeI2xF/763g0E96uLYd5wVwY33C1jYkGukmYUhTgnxCe/IH7gTuOXW6tMBM/Djr2pUcslb2dusV+UmYitzCXjC0N3MeK0v6DcJCGfQGWg886w7k8/12DOfSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=V93cToq2; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="V93cToq2"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d8239so18811035e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2026 14:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791235219; x=1791840019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6rc7IAhff66GVhjOkCyBspogq0Dd5n6sEZ9HS+Dhw3U=;
        b=V93cToq20mpxIog4BVKjoJS2p5s329lxDjxRyC8+DAtuQnVOz7X+7u4l/zKT5G57ud
         PUJsLBjS5AFVFSo2M0TllH/P30GvWdbGfbCQ/M/Po5Q2+N6pl+qCVIfZdVsfrAQeFP8y
         JnWR7aunbp1aiLdjRV9UpcOyOUfFCn12R0b7H9Q8epNzKgef61jULnLAz4xll6p2ZRd2
         t7W12kRrlXkMtsz1r0PeVmNx7DIR8U1TDdV6SDqgfhPA959cS2rut2U51trZwerOY4e0
         vuROsy55JTMfifcSXpQBoywetNOR9FVCR3yy6poO2/2ULxvZqUSp6yIysPg4t2Pk0vxN
         rNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791235219; x=1791840019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6rc7IAhff66GVhjOkCyBspogq0Dd5n6sEZ9HS+Dhw3U=;
        b=KW/9pIkBij65eJAkD2hMC8nmJGaMvpc7jzujQ63cqrvvheBcI9BUChZhzTSXpPMM2/
         21PdSfm89UCCoUed6g26dlQSPuyVP9UbGptvXngpnfxDzKW+MqCNu2zIJCYPFBFEeI9K
         B+0K7hFtJgljYeIb3frPe+0JQo5BymVheFckVqjINsazHnN5V2U99Y2qFFVLKWH8jMaM
         dMb877pozlDovRSVFSVkZ9w7+atKkCzdjgf0UIUJH0AQnzeoLVgb4O1aOqc9Agp0SVYx
         gFVAjzF97sUY2CZrmEqQmXYx0BrHTrpSd6dGjAg9aC9h9mKPzSwK7WrMMQOAu77sEK53
         zwpA==
X-Gm-Message-State: AFuF++kGsLQ3Nr9xHPU+CASVmgz2M3+PHS/fx6NiVU/HPbv0jrsnVCtj
	S7t8iHjtPhFtHlq2Fj/qIhPUyg44ShD6fSbSrjn/Kf3FQPtt+Nf9I3RSadlP3KOUaw==
X-Gm-Gg: AYBFou0vh4SE9tGmhOqtWdggvH967EZ8+1s7n2MkRtZrCFYx6vo7wa0W6h69/NsCeuW
	a/Z0VVU+5q9LPA6TBt2FfDH5j+lMlQBKJpLi4adRuKRnl6RUDXh8BlVLnmtF5hZKVqYGKZqUPjq
	YCX+3+jdvY77V7cMJdf4Nn/yDix5XYrTjXHfXHc7uMKZuEyeSF8/9y6dtA0yzy2/49LditbTJ2k
	GhzWivLH7VzW8AZh6Rzj70b2TTa6d3k8nEtQuaV1m7PFRaEDiU7qAZ2R3a09gb5d7THpdROGQrI
	MG7VS39Gi0C+10IN/5NK3PP7FS9UEm1cnH1K8ir0SOWyH3vhAXB/NuRw2EVz9nZESnkq1sjT7R2
	pX3S2uqaRRS5K8I6z7JJ3/A/DFbOcp4QyultoVclLAwww4F5yHBehDwTXSwRqb7Tl3GoQff0HQ4
	MnnZ1QlLiF8jHKYiYpzozR3Z2r82SdHbY7E45L+NIuszWi8n6csZtHAOZBlptZHObpERbznVBiV
	Kpaycucmg5qKsd3rOojIo3GITWzvj0zJ3XrQWOsDzO499m8XIxtnOu/yLZy5Z7ptQzU5nxEw0tZ
	6BUrRpEFrhRGDcHStXoTwgR7uHhNedUdYFLoizxkJJ89r839g6i13TW/aHoAOKHRYKbqrROph9Y
	7TrPiGjIy08eCyOmEFZBbcWvLMiD1mR0dJY/3su1vMgkrKY2VNfSLUTV+0VZWAQHfBjo=
X-Received: by 2002:a05:600c:3510:b0:4a0:c4:a1e0 with SMTP id 5b1f17b1804b1-4a02756729dmr208314965e9.9.1791235219172;
        Mon, 05 Oct 2026 14:20:19 -0700 (PDT)
Received: from Desktop ([187.40.54.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a178cafaa5sm21526585e9.5.2026.10.05.14.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 14:20:18 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: sashiko-reviews@lists.linux.dev
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	lorenzo@kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH nf-next v3 2/3] netfilter: flowtable: carry a priority into the offload
Date: Mon,  5 Oct 2026 23:19:54 +0200
Message-ID: <20261005211955.2971-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005171647.CCCB51F0089B@smtp.kernel.org>
References: <20261005171647.CCCB51F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Does this silently ignore explicit QoS queuing requests from TC flower?

Yes, and the commit message says so. mtk gets tc flower rules and
flowtable flows through the same block callback, so
mtk_flow_offload_replace() cannot reject one and accept the other.

Rejecting the action would stop offload for every IPv4 flow with a
non-zero TOS, because ip_forward() sets the priority from the TOS by
default:

    net/ipv4/ip_forward.c, ip_forward():
        if (READ_ONCE(net->ipv4.sysctl_ip_fwd_update_priority))
                skb->priority = rt_tos2priority(iph->tos);

A flow forwarded by the mtk PPE does not go through the egress qdisc, so
the priority has nothing to select there. mtk already accepts and
ignores FLOW_ACTION_CSUM in the same way.

No change planned for this one.
