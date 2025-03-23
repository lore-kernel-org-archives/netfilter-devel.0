Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0631175A5
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Mar 2025 10:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742724045; cv=none; b=TbjOK9FA2RUtosoWPbMzGCIkua3Qsd6/+BUNIcVQ+E5sAS8/oltKSPNixEsYfR6S1FKlq+9J6o3+foF/tA1Un//ACQXNqUjXJRJbPdoZ2G4RjzA9iAXo8FNpH3Esd5o3USPk7OpVfoMzn8Ta/f86Aw7kZz8BrF3g2QUJXy2Bpdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742724045; c=relaxed/simple;
	bh=eAYFSeOpLydJe3EQHFzHEzNzyE6MeqCvHMhYya4Uy0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H9U1aSP5D+QrtR55n4MYGIHUyqZPMulEx2oTd3DsMck7JeV8vNGcA2aBLjOEtn23Rrc8xt+HmLZ89ZW+LMXsKDFxlMV51cyBnfwaq/zHz/wGH2I1pNNowuVeWWMMGQ6Lj3YAlhLofSe2qVxyrDuYTUnMzyj0q548hSghfnjO86A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so36816305e9.3
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Mar 2025 03:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742724042; x=1743328842;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsWmNKPT/dkZMXD/6d+l+1SKQEMtaoGGsDedmAc6qGg=;
        b=VhfjJJYB7DKF6nC7iJ1BO+OWGDjzZtNVgANKbRQJb98Dhe7NIuu+IKgzC8iyT3ATLn
         P/FMrwZMfOJVCgZbwbCn+LJB5LI7xogZTjG/mh2JSMJ6xqYLJNIEaqg4Cvuj0t3Dj4wc
         HO1sbQG22ert1Iyfg6USTemAi9jUHkb4mZgJ5FhZ5l7bgZJEkgsSreGL5NpG7NqU61p5
         NPsFRzQcFX6lI5LuChHun7qyYwXEqApSTJM1J4yJmWD/En8mn0wbH9FiCNSMmPqfWIo/
         cQiW11ZiMSxCIESK3dzY1ZGQQvfpu+Myk2BgYbRjrEJGAInsiCi+D/ekYE8lX8YF6LyN
         9PsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZz1I/oWYb/fVNr+MhwA38WjPtgy8WeKF8BSByFoMjmeSrHtWEhFE6mddl0N9dkxUkAb9ji9LJEMju7Mf2cjM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZjfiCGSUpEw9SYqXaqAcXJdCGgD/5gn3kuCdb1yJnBaczpost
	o4US//OwxTkCGVMrIcTxOjrXhkhBAJjP9RbDj3IEH17l/DbdNiL0
X-Gm-Gg: ASbGncsMLEH+K3cTEcaniLXxyLfK3fLcYLQsXUSs6MwtumGn9CuJfCwS8scU52EI21g
	7Tm+blEvnY5us/wEHbfXhUc+olBnby6vZt8dhs7W8a8vyKqCM7Cm25EVCcP7JVZR5cWN0gXwG5r
	C+Za3LJwkhNptXtdbXd0BhAqUCFRfyWlE6xRFlVCIAlbhFCxpY4BrqGqx6ry7HSbHX0GqFWKH/M
	TYaqNWB7fz5mPdnGy3BNyLFU2uAlW9MU4n42byzTUCXqXLHxGqWoT+FzBKdRh812wEAauhxrJau
	nZuTXe23tOarfPflW2F1VSRDSj+OL63o8WP0+f624wTRsbhaw4ZMAohywDZhHEKs+5zEPNe3YHZ
	4l0GBoGA705lPO59i
X-Google-Smtp-Source: AGHT+IFzKFRKPbXekcUiG9S4bviYpdHdtEaHM3b/kN2KJE4sfQPaRPwi8yCBoIsZuOE2KurThVnF/g==
X-Received: by 2002:a5d:6d88:0:b0:391:29f:4f70 with SMTP id ffacd0b85a97d-3997f8f9259mr7637901f8f.3.1742724041931;
        Sun, 23 Mar 2025 03:00:41 -0700 (PDT)
Received: from ?IPV6:2a0c:5a81:d217:7f00:ae15:b8fb:ae35:6497? ([2a0c:5a81:d217:7f00:ae15:b8fb:ae35:6497])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9e65casm7444733f8f.69.2025.03.23.03.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 03:00:41 -0700 (PDT)
Message-ID: <5bf4cd03-ddb3-4cc4-b07e-e25e475395f8@debian.org>
Date: Sun, 23 Mar 2025 11:00:40 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
To: Jan Engelhardt <ej@inai.de>, Duncan Roe <duncan_roe@optusnet.com.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jan Engelhardt
 <jengelh@inai.de>, netfilter-devel@vger.kernel.org, fw@strlen.de,
 matthias.gerstner@suse.com, phil@nwl.cc, eric@garver.life
References: <20250228205935.59659-1-jengelh@inai.de>
 <Z8jDjlJcehMB_Z9F@calendula>
 <dfaada92-44ca-44c1-83e4-5844191ff57b@debian.org>
 <Z94XLnSQRfMh9THs@slk15.local.net>
 <22n4s4s4-8155-708o-4091-q6o3nq313641@vanv.qr>
Content-Language: en-US
From: Arturo Borrero Gonzalez <arturo@debian.org>
Autocrypt: addr=arturo@debian.org; keydata=
 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
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
In-Reply-To: <22n4s4s4-8155-708o-4091-q6o3nq313641@vanv.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/22/25 10:24, Jan Engelhardt wrote:
> 
> On Saturday 2025-03-22 02:49, Duncan Roe wrote:
>>>
>>> I have mixed feelings about having this systemd service file in this repository.
>>> Will this file be maintained wrt. systemd ecosystem updates? Or will it be
>>> outdated and neglected after a few years?
> 
> There are no changes expected to be necessary.
> 

How so?

Is the systemd ecosystem not evolving? Won't systemd see any updates? Will it 
not deprecate options, or introduce new ones, thus making the systemd service 
file outdated?

I don't think 'no changes expected to be necessary' is a statement that can be 
applied to any software system.
