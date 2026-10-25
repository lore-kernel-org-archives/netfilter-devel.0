Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792971008;
	b=KM/waSqMSu4546rj/yYmsdCADWNAdSMD0tdZhYxP34NjSh/u6vYmyGEzmAbAPQRZ/Fnp
	 hmU+zGcDrIEWQcCT76vX5obWzx2r2OXYhiR0QqzYWPOxKMdDFEId1FBmT6ZN5JNDxb8vl
	 wVfuamDdGiA5f3J0O+l4Qa90xU9WMu2zUJOBuv59Chm+CYS7mKoXk/wBUZvIV0Lcffea+
	 +w0UWJdwsQXChWfPkigglXjZvkXL+HGbsI+cyJWIcsIH2pqizYU3YeFc6KwlPx7YobwqA
	 qRdjrGnB1+rkUptFnER8qnw7+zlq2RdaVw+JFzwh7RX/rrEjhjOIYJ5pv3dqCa01hWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792971008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lmIbAwQN+OB5qxroFzMdroH1voIzeary2NmOelbqvZY=;
	b=iznXxtwQTv2DanvEOzdAvLEva0t1qOpouuko7qv1/XMsMxlQsLShKWFn/EGAhD4LM562
	 +1F+x8I85NkLK1/6etKhcImIqazNi4UrpaniyYEZiJ1njViLyta7i0sKc4e5kmTc2u2MP
	 sjCTTJ+k+PXqGLGKZYt2nJOFoDTnZ9HWwKQUW4mT1ks8Ee8XZcpwvwqYs2cTovcTZ3Ua5
	 yFHiWSN69/yWBHBE3scIe1Sdk4Te+vRkCpL62Sf4FuXcpp+/JzfAXXqx6awmw2KDMJDBV
	 pTDgqbQvaVwKqX8QOHv9TaPjwEeIdlorvEvwt9/of0GLedk1vrVzlFVVV54mS/YhtXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hI4G10Dk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA17F606A31B;
	Sun, 25 Oct 2026 23:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hI4G10Dk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81A61F031E5;
	Sun, 25 Oct 2026 23:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792971007;
	bh=lmIbAwQN+OB5qxroFzMdroH1voIzeary2NmOelbqvZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hI4G10DkvGTSKEk2em3OvRa5OgFFf5kiyl1L/e6xoeuK6dQlpyVeynG1NZwi1n/dJ
	 qGRy2K+hEaC41RjvNorDq4PjmD72EtMrlUBjPDyJS7uTZoDAcj+WfKFZKGq7GiVsrH
	 d9Mtbw0v+SFQhzrFZ4KtlzKslBIqOx59DXX++BGsE9t7sS4c39+HJk7DnpaJZWijuM
	 2C3mwDD3fR4UOTsECa/XHuw0lQWwnAoEMqY1jn6iMI1SEgyQM2DnkxjvsbqOX/17KG
	 KujrpMCdRrlXaDrZQb77CpdfDlyXBKSyUis1xK4ca8VxOdeh9Mnh4n6V2br3Dzn+RU
	 Ran9yKZdWGhcg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Subject: Re: [PATCH v2 5.15.y 0/2] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Sun, 25 Oct 2026 19:29:53 -0400
Message-ID: <2026-10-25-1-daily-reply-0007-nft-set-nelems-5-15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261025071509.47122-1-steffen.pfendtner@kernelscan.io>
References: <20261025071509.47122-1-steffen.pfendtner@kernelscan.io>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This is the 5.15.y backport of def602e498a4 ("netfilter: nf_tables:
> unconditionally bump set->nelems before insertion"), now with its
> prerequisite d4b7f29eb85c ("netfilter: nf_tables: always increment set
> element count") as patch 1, as in 6.1.y.

Queued the series for 5.15, thanks.

-- 
Thanks,
Sasha
