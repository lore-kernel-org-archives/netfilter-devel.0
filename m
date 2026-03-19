Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FF61E1DF0
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 06:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773900930; cv=none; b=Ft1+2brcaUMjlYN8gVhX1mlmLXA7OKPw26tvfXfkS4pbMA/eLNRNeE0Nz25lwhiqJKYQMDa1NgqRvpsa4bJ4LyF9ay7dqZTzzowOWjmru32iD/j3mCI5Oik/rGu6UFRCz/p4uXxzyqBxydXbtxVeaMNp979N00ScTyxhmo0icZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773900930; c=relaxed/simple;
	bh=lQMAQUEaNFaF/8TrEH2EKeVMcgsU/69cqw9jbCo9AaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCFVzzRv54L02wtb4/bD0BQgNEvmT5df/i4UO+0BzAOuQj2MsRe4Hl+9Ei2OSdSl3xT62IYHT2fWz3sQZ9qQmQrEuHs+q0s58UOgIbnLCV7tGyKAG1gHHnHjmSmaoeJrRvxnMGsr0nUx48FiIRL7t6S0td2XGbxviw59SpNVzks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bH6By27m; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bH6By27m"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66847de014aso564994a12.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 23:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773900928; x=1774505728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txy2LHsWryztaiodXgYqNx6B8tU+mwJK+bZ3myIk59g=;
        b=bH6By27mivImb7iNZAyOVIE/8jWagdgyojtRbaPr0MfvF6ZtNcveRMppY4sTHLcRPj
         rfyam4uwrhkqeRqo3Vwvc/dlRfufnebOyc0VeF5CFoNp9NiNSauuZujd/CPzt3RJeDCn
         7Perfi8vKfrobKWJByqKvyyK9tT7nfuSakWyckHKB3hcIOvTRbrsjyd0BkM6/t57jUS6
         uL1uxB7GoY/93bV6ZQ3EY17PC9/VSgCcYh7X6WMWIYNIXgr0nWDS1g+mY4GfjqQcVyEr
         d7J5YsNajg+eZyDX5wbh6BTrJwh8oDEf0AtHv7s7EAumVW660ldEaHm3IPB/0qLDwSvZ
         1q+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773900928; x=1774505728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=txy2LHsWryztaiodXgYqNx6B8tU+mwJK+bZ3myIk59g=;
        b=N1Lmaaz+VtcP3qOGruGzVlGUSOnOJeMSgZaU6gC/5KMsUHkRmGSZsnWf/+2UfEkW16
         OCGCfL3AOeoqeTSfBJ0p+D/ZD2SZOcWYtOCGfMOCnIj1rh7lHObo8R/oc6bm/Kn9tVMO
         SjUEF/mUI8DLY353hQq5RDOiBxha3jrpldApsNFzq6M/JBYNiquNWyhAKkClF/P5utrQ
         ayNBsaj+B1IoMKRvWDnzW7x6mNmUE07VTXUJ602niaHkLrND4RdxIBc3Gm975a0LzJIQ
         V3MM/LBZssjHlaKO9B6sX1ESwia7QhWDVrcd1bmrab9VRjayhMiz2eWKqxXYdzDxNCDw
         TDCQ==
X-Gm-Message-State: AOJu0Yw0Y49lif9O9MqRm5+GrWEi4VyJDbX0GWQOj5OLxMhhLa8m10PM
	5pO3WrE3wc3Gx27V/O4lNZeI//tsAJmewVgNBsWXFKjc886qf0+dWgYF
X-Gm-Gg: ATEYQzyH0ZoJzaOl1VQBBnFgEc5LOCCWV7WrygKuEN69x1IxXVwAzQ1bkJlYdpxZm4D
	Ejtl/H0kkBAlRDR1tMrFebvtOB5B7OyOS7OonFJFoErO7B+ChgrT7WPTHB7zBemI0VSoJCgTxT9
	347WdLm8ESq+UQ95V6oiYM4DDqYG8ssVEf+8VPu1gVoluZimxrqkBU2bs0C44pf9xEvM0WxJBij
	u5ogI51nKZY8qSU4J4Oi5f3KSbr0zAuZptPZEs3waBrlsXsFJeq2Y8sifFK56GPa901gUTHU/eS
	jdvl0XAaH4l9fDCuVPnybDLItPN+qGJ9y2Xl4J/vQ+bYGm4PpUhzHa29ByUGVPZXZL6v3/xRDTT
	yp0quhnSkhGsLEDYLdvre/Znw7u1BxTHf+VSrhbsk4/VPBth46gw/ibhhtoUhY2NPITt8bfWZFl
	lDT8z+GgY=
X-Received: by 2002:a17:907:7b93:b0:b97:cc05:61b9 with SMTP id a640c23a62f3a-b97f4801ab5mr405707266b.15.1773900927770;
        Wed, 18 Mar 2026 23:15:27 -0700 (PDT)
Received: from gmail.com ([2a09:bac1:5500::49b:47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b97f142cf16sm405096466b.20.2026.03.18.23.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 23:15:27 -0700 (PDT)
From: Qingfang Deng <dqfext@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org,
	steffen.klassert@secunet.com,
	antony.antony@secunet.com,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next,RFC 0/8] netfilter: flowtable bulking 
Date: Thu, 19 Mar 2026 14:15:17 +0800
Message-ID: <20260319061520.356946-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317112917.4170466-1-pablo@netfilter.org>
References: <20260317112917.4170466-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

On Tue, 17 Mar 2026 12:29:09 +0100, Pablo Neira Ayuso wrote:
> Hi,
>  
> Back in 2018 [1], a new fast forwarding combining the flowtable and
> GRO/GSO was proposed, however, "GRO is specialized to optimize the
> non-forwarding case", so it was considered "counter-intuitive to base a
> fast forwarding path on top of it".
>  
> Then, Steffen Klassert proposed the idea of adding a new engine for the
> flowtable that operates on the skb list that is provided after the NAPI
> cycle. The idea is to process this skb list to create bulks grouped by
> the ethertype, output device, next hop and tos/dscp. Then, add a
> specialized xmit path that can deal with these skb bulks. Note that GRO
> needs to be disabled so this new forwarding engine obtains the list of
> skbs that resulted from the NAPI cycle.

+Cc: Felix Fietkau

How does this compare to fraglist GRO with the original flowtable?
