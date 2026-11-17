Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794877387;
	b=U/m+xLdzlHeF3jhs76NgwO5kQ3XahsabIFreBCO6KpYRbatUjfgxxmiYxHgolwDIe5fV
	 mhp607KawyRARcDqTVxTIjwaDU7yumrGQTWOc8nTFBDGdqLd6dn4+xfQD2RG6MnKpBtvZ
	 iylfJW5/PewRmUC2i+5s4gMCgzlYY3IeKcDbNT31JRT4u7pbSEKrtnczDIyKWjPbaPWVt
	 S58eLSW+S84T4PTO0dHbTW8snzohIplyFxS2yn4zhr8hnCsmrJ5t78CSDwr+vmUe5GR1K
	 zn87wjXSdzqxpk+5QyhPuV9FDxVj4XximFl+GMckQo5MPwXKJkJMKwCy9tEXtU0+d6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794877387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kraifekpVnUDknKdjLmFble0e6BJGUiT7RNErtzZSBo=;
	b=TvMcWFpJ9BDQVRyMo/4o9dJflZ/bnT29IVdpGHZG8+n1RQgodNHG34UeLHHtckvpb00J
	 gmv6kpyEshjhJ5O5yjDxMg8Q6YwfCSQtVpyAH9ME44n2Gsr8ZWYCw3/9bQhnT/0VKsjHH
	 PvTD/n8RzTPUaCecgdYnj6EM2/WG+ASJQ0e6QE1E54j7pr1O/h+QhrnUBEc3zk4L1QOgS
	 pxcMpYKXErvWYPjkVbK4+uo+TixAA8BRMuU0hBaudnVNfDrgJwlK/CUgYr1PVes0plmHI
	 7jVBhoRTWbjzoYGYPrzgYUOxpGdAp0XAZGPiPOaUDinqi0BdkIfHxhyV4yMiuIPwpPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JVJsNhSS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9756606A323;
	Tue, 17 Nov 2026 01:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JVJsNhSS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5071F000C4;
	Tue, 17 Nov 2026 01:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794877387;
	bh=kraifekpVnUDknKdjLmFble0e6BJGUiT7RNErtzZSBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVJsNhSSnj+EISEqUNbzgaL7l8OkEkaeCyMqf/Bgzrrl69pEBYNfiabQLO8plYEnN
	 +4Xgu0/Bl+pzCs0l2DOsNtcF3nEnK0iblRe2zJZkIfsW16HqvlcMovU65IZUMiPzOt
	 WBXF2JTIF5k2wdYm3muwO1bPaN+UiOM0+qp15qVTlvcpHZI/RP8P8M5ez998KD8Xix
	 uTF92MXnlZqhPFbRPTaJDVCYOOsHa/EAyNk2URB8lERs3VFZzHYDzm0OJgpUbnRQyw
	 3jH9R/6Ii4s9aVTomkSN3HaSJDoeWX60r+QSmLbCbuXX7NtPyG6xRxUqPMrqyE1kLe
	 boRVFH8CWuX7Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 6.12.y] netfilter: flowtable: ensure sufficient headroom in xmit path
Date: Mon, 16 Nov 2026 20:02:57 -0500
Message-ID: <2026-11-16-2-daily-reply-0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116152844.2998474-1-antonio@mandelbit.com>
References: <20261116152844.2998474-1-antonio@mandelbit.com>
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

> Check for headroom and call skb_expand_head() like in the IP output
> path to ensure there is sufficient headroom for the mac header when
> forwarding this packet as suggested by sashiko.

Queued for 6.12 and 6.6, thanks.

-- 
Thanks,
Sasha
