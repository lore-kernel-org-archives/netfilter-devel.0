Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34A94A9D49
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 21:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150190; cv=none; b=E2v3idrqBSW7JsrtAxzrlkiOrcQlUJwksoS/YFXWIrVqhFZmrxNWsHgVie7GJpKJ/KvCgd3zMlp0UIeJHr6haJ0YUsjamu2h7MMi5hjAdkl+5k+Fibr5E64sZ8Dg8NTapSH58+rXK6zUfQoHoFL2JNGZwOe8rlHY/9WZf/T7nwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150190; c=relaxed/simple;
	bh=ONQ3/fm+VvJcbR2hGlWWmoJvTQ4LkcEql3G60OArTd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLQVOVgDTpbKY6Ab4OO3DD5V+CDTIslQXVSODveMOBiYGh1TpIJPpgPV0tUVKcK4D8XsPddQcbDvH/wIhs0QqiyUF783d9AqZcv9AGvJBTCvlJzsO/eo6SLpY9FoAx4cWh+IAeMgjUw7Nnfh+Ezw2oZba6aGZRFKiV3SWty3P7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tw05ZvwO; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tw05ZvwO"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48c5358fc28so429372f8f.0
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 14:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791150185; x=1791754985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=44L+w1lo0aEfL1hM5su/VJjhXTZhdo5HD8XfCtpMzH4=;
        b=Tw05ZvwOODV1gx+0jiHCKped/cJPi82G8/unjkIEmDya/VLQZKaBXscApMH/ZHbGBc
         HrfqA+4hy+nXSBpR/NBvRa71qLYUzVBXZiJOKB9QujsOG13gJo3O0RvPBA7LHLh4UHY8
         59kiD3YQrCjUlAIX+NYoozOqpc9Ll5oLHIzngtxwbhkVaZJtekABeZXchxpJvbvncP+Z
         Tw5sfa4MRj5drP6/+hRFjUHznlyeLzMc+1NAtBDRx+MVDUVmFrJCdn7dtVFj5X1dTvJC
         rwk4/io0813IUk9ESbIa9EL1i/WtkIt99av2M94TNqDoOUhYvVLuTmmiSEROhO9kivzg
         no2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791150185; x=1791754985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=44L+w1lo0aEfL1hM5su/VJjhXTZhdo5HD8XfCtpMzH4=;
        b=cA8/G9j4hfAWgp/l3UwNgTXudwJix8RMhNy8l6S9w8Wyh1RFYtZQFUH1qGkyEDjb3S
         XERprkAkMKEmCIx9WXNcUVGTzrr5iiUtYOnFHQv4jEZJ0vFNLwbS8tEgpswbsj9ZTnpZ
         tYOhOb1fE5079fy6bK+SedPujSIZOTJNy4dbrmhN6WOdB7TQHnL1ZDdhn0OAWXfs5/NI
         ek8jjS+Ha7ERJGC25nRpLZSzGBv+0sh1PrkDENvKKJJf9ObDgqwalQkyPCB7KvgZQArK
         thJQSszkbfBM5w9DhnkWcD0su6mYJrTAJBEZjYJ9IkE5iuLwDGAXWEyU9veQB4WWaHVb
         ybHw==
X-Forwarded-Encrypted: i=1; AKwUvBzIf0qXhTU3LZJ37AGSbV9c3cKEqNSnKPvkK7Lvfkhx9ly5X0Q6rZM07MQ02r8Q5OR5N7kt2A9gh4CNF2Et/t0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJzNSurqLiz6qbD0ZAsEUL6WYLouOTJgxv/jmcfVNqTJqxnHZA6
	Wp+EJ+QGPIAhQ5IDpNmnMfhvaqXuX/NmgV+mR/i6yqYPf/Wi+H5hvpij
X-Gm-Gg: AYBFou2QAB5EWRs1iN8914j4JW2jggd07i6oYHjX9KOu/ywdMrqiGUut6Jwc6JPsdd2
	LvSjYxaNEpUoX90zSGyMHGchqtN9B53cvihm5rx5MBD9Q/1HGkNVVB2vSpmzwtecHwd8pyYCUF1
	qL++5kQNV0baNQ1a4V3AJguiLmNmYmltQb02g1Iu389vesuJ2SgrZMRBNFdPSojgFJlTlF0fYqE
	IkkCvbWtDjHbWzZrj7NvtgkfxJSbgQHovrcSIWeaJQ7GNIkGllvCY0lAOeWtIT0Cis/ItTP7Vkm
	RpUa7UWbv/SElQ7k9VNwgh1GSDdrHwaPvtVhM+ZYJjxcXaXXIWoda/8hDwg/NGl7Gf8tpOCc/rf
	A5Y46MWmPcs6HfAe3KX0/5hWIEEBHHIbuYWVaD5yOC2JZsFiSQw+ywd8hWnOzvgNe+LIym3PNAa
	R/F6AoaYZxagTY/cTstJiZkEJ4ERAhkj4MpxmGx19IRn/zdrXCWlnJRLzA0SCut4HRGdlOy5oAZ
	oh9+OErw7zELgyllmMyeMkzHNEu1m7l67Tt+eGpb8A2t4jNYCVRZCNKP4Cr
X-Received: by 2002:a05:6000:491b:b0:487:834:9307 with SMTP id ffacd0b85a97d-48c48023772mr8504789f8f.50.1791150185325;
        Sun, 04 Oct 2026 14:43:05 -0700 (PDT)
Received: from andreayoga.localdomain ([195.122.200.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b38104e07sm19331801f8f.31.2026.10.04.14.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 14:43:04 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: netdev-bot+sinfo@kernel.org
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Bernhard Thaler <bernhard.thaler@wvnet.at>,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf v2 0/2] netfilter: preserve bridge egress VLAN tags
Date: Sun,  4 Oct 2026 23:42:51 +0200
Message-ID: <20261004214253.5432-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <179114935323.1402591.1020652042294576959@kernel.org>
References: <20261004212429.3648-1-parri.andrea@gmail.com> <179114935323.1402591.1020652042294576959@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Oct 04, 2026 at 09:29:13PM +0000, netdev-bot+sinfo@kernel.org wrote:
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.

The issue fixed by the first patch was found by an LLM-assisted scan of
br_netfilter. The issue fixed by the second patch was reported by the
Sashiko AI review of v1 [1]. I then confirmed both with a reproducer
under virtme-ng; the reproduced symptoms are described in each commit
message.

[1] https://lore.kernel.org/all/179084999520.434549.4764913674478855382@kernel.org/

Thanks,
  Andrea
