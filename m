Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978AF2773E4
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Dec 2025 15:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765207108; cv=none; b=uT8C6AAob9n/Q1UaIoUR2xy/tc1y8u/kejUOoi2f43ya6slm+ekahhWZxCSwCTLhMgfGy30XUoBRJRuDlJHcZokig+lvWvUe8vMqYerSsnHMMPvtru9KFYgg/gxr0Hor1+B4C9814AI80sVOEvyv4D4HjQqVSsOlTfxynIc+9sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765207108; c=relaxed/simple;
	bh=oKAfzbDpF5HxMruBvGmNP/TyJQbPITsy31Os9j1AF/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Po4QNNoS6qoDMLkk7lbP3RLMFRX93Jbqs3L9QcooNKYsvGrxc+TETUihJSzgOGtPNQDlwGCV5rEnVHf4cG63pB2eXwC371URLpo9spOae0COhLpl6eVttbCUtE18PRGLhAzrfMX2Qjwl2gI3iaLTl4rRsAqlQkbEDHwqg1LtCVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WBrBTJa1; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WBrBTJa1"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee1fca7a16so38446741cf.3
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Dec 2025 07:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765207105; x=1765811905; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oKAfzbDpF5HxMruBvGmNP/TyJQbPITsy31Os9j1AF/E=;
        b=WBrBTJa1xCNKnrVksu5YNuV85ybgutM91c7JA8rm22/A8Jqf8vAj0yrupIYswSvKLT
         LwN0pgP5wLZt4vcazJ7gvLHSgYml6PvyPKAL8cPtlHHnPvprnPOltfhx/dHLJknk+Jwn
         kZ8Y22+X7BaRSMIDNwDMgHYTtGENsgkPqlFF/4n9L8RUWJR10ez4Y6sMomeMpbLjXkkn
         5UbWk0sH2rkB/9dO5rDLiN0aDHooUFlGNYBflrkDc6btD4Mnx60H2asSv/01O8LuaV3h
         7A4TicAb4dlzB78o55bbpNfjp2fYv5uDwEsnFu2d/O7w3FLM4VyOgNDmI/8cJqPuG/KE
         Buig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765207105; x=1765811905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oKAfzbDpF5HxMruBvGmNP/TyJQbPITsy31Os9j1AF/E=;
        b=LWtIaMeS1KfZ8q6FATWjEn1pEYTeYCTKtnBk8o0SHC7ArK3bRC+2QP8otrWaDozJz2
         VvVHSGmiXcVv0pzlutlB9VO1lVY1E1NFEuQj+jttbi19jDpQ7L7eNclbMY5vP2ubL5J4
         SLgRIuVD9Xyt/IGZOuSW3klfQdCAxcgazK9YdZwsmbPYv6kNqYbpJC5EO4IhI7cZnZtH
         MMuFKnI5HA0BbCwXGBy6ZRg3Qn/j+TKixce0b9ZtrpYRNadwb1c4Bl5xdzECU8OIkppI
         Eo2Ll6VWtr8sUzQv6lUTy7DfSZFcam26Hsg+VAfcYZFqTuLLvnpRlZ+Iqyr8wC1E77xG
         WXug==
X-Forwarded-Encrypted: i=1; AJvYcCVrrBx+7t6JAZbXmsi2gPfRRr9q7ih5AVsH7YxK1CKuhWaPho+gm6qKw7oKH8/6QWUNq6k8zqpsy5D62fSOdoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLI71zAJDREKqG0vHIA2zb9oBUKtrgcFde3szmTTdpXhZjS3CX
	E01sXHAXKUHuKCLYdxfldG0r/aSGDQ2DZMzc7uSj75o6MqO5dnsFGFajEP9Pm6xLIHX/JjlTpsR
	WBpbzQwXDqN6SVpmh6yXbEBX0LXOPupKr71JgwNLj
X-Gm-Gg: ASbGnct+BaWxhepoRcav7vz5xPH7zYDG1OqxqAcoJ4LSqkaWnL/XJgzAnKI0/71xfm3
	0MDPz9SXzP1MqqMU5hfK6SV2gbpMgoUbV2mQLXL/hcqNG47Be4yWXF5ZZhl65Ic/0m/8UdREqbv
	BB8wZjPWDR6XGyf4D4OEe4iBw/VH36CvHFJky28m/RJn9igRWSssJaIYAU82SuxhcbwLhtcv6Uv
	eDaDneaFJoa0khWG9o+z+nIiIBi9Tu1a8BSQlvSSMfAJQ+imB1XUvi7jaejiZhnJ5H3Us4=
X-Google-Smtp-Source: AGHT+IG3QbYCkW0+w14+GxOn8zrOdultaiRW9GGC+8/GajzreNpWlXbmMSYEZgIhqNUBOeXUPiC/zyq2CdgSlnaQgIg=
X-Received: by 2002:ac8:5896:0:b0:4ed:1bba:f935 with SMTP id
 d75a77b69052e-4f03fedb2a3mr123684371cf.57.1765207104627; Mon, 08 Dec 2025
 07:18:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251207010942.1672972-1-kuba@kernel.org> <20251207010942.1672972-2-kuba@kernel.org>
In-Reply-To: <20251207010942.1672972-2-kuba@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 8 Dec 2025 07:18:13 -0800
X-Gm-Features: AQt7F2oYapRJno2e3aRfjRsCvAw13aWyh8c4DdAqOiUWSZvDdIDiVYfXnMpLG_I
Message-ID: <CANn89iKJXNksYB1nOnsQAXgsrYYaVa78JLeSuG_y3b9QaXnoMg@mail.gmail.com>
Subject: Re: [PATCH net 1/4] inet: frags: avoid theoretical race in ip_frag_reinit()
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com, 
	andrew+netdev@lunn.ch, horms@kernel.org, pablo@netfilter.org, fw@strlen.de, 
	netfilter-devel@vger.kernel.org, willemdebruijn.kernel@gmail.com, 
	kuniyu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 6, 2025 at 5:10=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> In ip_frag_reinit() we want to move the frag timeout timer into
> the future. If the timer fires in the meantime we inadvertently
> scheduled it again, and since the timer assumes a ref on frag_queue
> we need to acquire one to balance things out.
>
> This is technically racy, we should have acquired the reference
> _before_ we touch the timer, it may fire again before we take the ref.
> Avoid this entire dance by using mod_timer_pending() which only modifies
> the timer if its pending (and which exists since Linux v2.6.30)
>
> Note that this was the only place we ever took a ref on frag_queue
> since Eric's conversion to RCU. So we could potentially replace
> the whole refcnt field with an atomic flag and a bit more RCU.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
