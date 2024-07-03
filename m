Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4669013213B
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2024 07:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719992284; cv=none; b=ukOHCAcfRTxFBjXA/gDC43R2fRpKrXY3j1xc7IIns/FbPBoGyiwDKKQz3OQtb0QLwWjAEcoPp6faHs/0pbKFCcqzKW3uaxtGGYC602Kwk+MHG3nx8Q10AGZtC7pv61TwaE1bEAimADChYyWY7MOuRrQ/fXZOfXqT9QgaBVVj52w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719992284; c=relaxed/simple;
	bh=SN2H0eVxmGUskfUPP91KGquZ/os5N7S7nxhhJz7Dk9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cU3Jby2GcbLY4j57yaXRVVC2BO4zd1Svo9DV+jFBSdrQayztiJkG4+IfYB1I1+0y1IK5W22BhI2V1SgpaQAlAL2SZQ8c/cwR3HbHxdLOl+90azdDg5T6SKxt/y5v2Tdz4aF06U4vbIImO+tys72v9jI8rU+o0932QfJN0Oub2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=L77M/vTy; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="L77M/vTy"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42565697036so1739745e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2024 00:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1719992281; x=1720597081; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kpPkynNEPK32eGb/3KE75kqw00RC2GhFiyIcGFteRwQ=;
        b=L77M/vTyPTNcveDoPL8lRRWp6nr8nuxmTQAFG7ErIGpb/aVTC5DVHt53tUAUmdE+Uz
         I8OH7t4qOR0H3hvi2B5jIcCjoDQ7oXM80gEVF2J2fKXyvco2cGn+EWQ9MHrYgHQAnCBn
         RsXnw6WlM6TVnbxBub7t1+JAawyV3FxRE/5sL8IX9QXLsyBE2CrGQ/NJ003/G35OTpIA
         CVdlumUW+W0GoY5l1XQqd+mxZmTtK8XOMLy7/jUyexGGQtJoblV7N6g4SmpWY2hgGL+l
         LdnU1AwdQYEBP4YkaYtuRfezRDnaNUSUCFftESnhkLZ0q1WAepuNHiiyosASlpjBgWfO
         IJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719992282; x=1720597082;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kpPkynNEPK32eGb/3KE75kqw00RC2GhFiyIcGFteRwQ=;
        b=WYDpiXGqDyVSJMp0iFiXSb/L8e1v2gbvWYl85eUbZo+RO+fgg85a35ljI4Cu+Ko6pC
         atsuIgmULavlQXsrmadj7Sy0WsYpEQX+GL76YWc/k/OBOmcCE9WrodXmUUS2fAHg9stG
         d+o+Om+6JrkHmb0FK4Nn8MikASzxL7HXCMSsXDNV53sVeM1jNiRhENOcxiZEV5z9y4BB
         Oim51yzRCn4KCZTOSW3ZtBG+jBJ6vW/y4w+T6T7pMbJDtaXOzpaYPCpJHLaSMC/ZXpWu
         n0BvlzDtmckYkObz6/ZuoDAY8spDOVJkpnTHlrObg32OGVOs1MDMI2zF0zX9++K/kjFD
         We9A==
X-Forwarded-Encrypted: i=1; AJvYcCUKkpIfcNL2hFNagqWISi6II55TnqtTj9f7LmdMScSQfLt6jq2V+HlJmunVUDFrxBipETHbeowkVG6gn1j0N/+P+RrsdeHs72G3bFbcUjXh
X-Gm-Message-State: AOJu0YxKR8Se8zeNjXXBMEXnajEpHBYSyrw4gp6bYgefNQ1DVbYB9QWA
	9P9ne6m53gwYWfM2MDokRGbAVvvXFS0kTC333tmgddRHdN6lsZIvHbUqn2XSsLA=
X-Google-Smtp-Source: AGHT+IFm+uLczIK7uTGSixBRwN9eFjnrXnD6l8y2sFNL4vfKSryOAsrbhNRjCAVnSaPevO4tHRYpkQ==
X-Received: by 2002:a05:600c:2312:b0:424:ab8c:a24e with SMTP id 5b1f17b1804b1-42640915d0emr7039365e9.11.1719992281596;
        Wed, 03 Jul 2024 00:38:01 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:b374:7b80:e6a1:9818? ([2a01:e0a:b41:c160:b374:7b80:e6a1:9818])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4256af552bbsm228397795e9.13.2024.07.03.00.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 00:38:00 -0700 (PDT)
Message-ID: <523daa3d-83b0-495a-bf6e-3b8fd661cffd@6wind.com>
Date: Wed, 3 Jul 2024 09:37:59 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH nf] netfilter: restore default behavior for
 nf_conntrack_events
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, stable@vger.kernel.org
References: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>
 <Znv-YuDbgwk_1gOX@calendula>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Language: en-US
Organization: 6WIND
In-Reply-To: <Znv-YuDbgwk_1gOX@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Pablo,

Le 26/06/2024 à 13:41, Pablo Neira Ayuso a écrit :
> Hi Nicolas,
> 
> On Tue, Jun 04, 2024 at 03:54:38PM +0200, Nicolas Dichtel wrote:
>> Since the below commit, there are regressions for legacy setups:
>> 1/ conntracks are created while there are no listener
>> 2/ a listener starts and dumps all conntracks to get the current state
>> 3/ conntracks deleted before the listener has started are not advertised
>>
>> This is problematic in containers, where conntracks could be created early.
>> This sysctl is part of unsafe sysctl and could not be changed easily in
>> some environments.
>>
>> Let's switch back to the legacy behavior.
> 
> Maybe it is possible to annotate destroy events in a percpu area if
> the conntrack extension is not available. This code used to follow
> such approach time ago.
Thanks for the feedback. I was wondering if just sending the destroy event would
be possible. TBH, I'm not very familiar with this part of the code, I need to
dig a bit. I won't have time for this right now, any help would be appreciated.
