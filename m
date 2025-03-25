Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BAB13AA3C
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 01:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742866478; cv=none; b=HIF0ovS2UgO8w3fuWnjW8WaSDgrsAEIW2ISHlZG+kDgvkMLI6k6mgLxReboWtZEpO2YLKIWDq6mj585j2oMkk99Ydf0udBDe7eBm4G+eFeDekVDgL6TP+QXjBCMNQ/r0LkTCq44J2rRWUqv+Ba7XZd9q7bGPiP/kyPQKIdxsoR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742866478; c=relaxed/simple;
	bh=NreEj4mK07lNk+9b+rVXS1uVhxRL7N1wNbZgubmIthw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UjWjsfcXz7rezqzikgt5KF1uGKeUUpJ4+NJfIeU9vE7D4LQtZx22OHGyOPdqHqQsrTg5BZnjy1Js6UZVdDjIljxlQhQhJcNAPinec2VWF4/D/mwbTf/UZYhkdyY6ec3EqY6hFCDlTkcSfoRvODcce7Byqi8RReVxD7jMXfEnXDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fbgb1DOt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fbgb1DOt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742866474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NreEj4mK07lNk+9b+rVXS1uVhxRL7N1wNbZgubmIthw=;
	b=Fbgb1DOtaxMtD1ijO0a9IIwUSFGvND9FeAdXySdLSwTBI6ZLhuZKIJEBRyRjIBljqY+XMm
	iVzdVZZczZ7x0fHtYeeXdJy1FZrAVps8YktIU0+Wyy1aLD04wQlMbarsI5TQ5W1ch5JqcS
	vttbn4D75WTfCYi5VsY9Ke0v2EEuoiE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-S3gdVA6XNKGSk3hZynYGsQ-1; Mon, 24 Mar 2025 21:34:28 -0400
X-MC-Unique: S3gdVA6XNKGSk3hZynYGsQ-1
X-Mimecast-MFC-AGG-ID: S3gdVA6XNKGSk3hZynYGsQ_1742866468
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c544d2c34fso793229885a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Mar 2025 18:34:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742866468; x=1743471268;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NreEj4mK07lNk+9b+rVXS1uVhxRL7N1wNbZgubmIthw=;
        b=fhfJRhLUALlRumWsxFBuhFa7AlTfpm45Vdy2ev+r9ofAA0KP7io3H3B7NPtLdsLkf4
         1Xvi7rzzvd7+RO7EKFLV7Ji+afpGz66+YtQpq7EDZdaWTcbYt13U6pnUHSrw18kkswiH
         p5pw25TVbVM1AoKmDIZlbMZnsJ6yNs7Ufa7QOVqZ6Nhd1nxrOfWDAnDBQcYzewsTW+fG
         X0Gf87NC56RjNnPFM9vrR9ddyMwg9CvInSj9GQiN2TTAmt9Hzkw5ojhCpvFNwzw9nD2s
         OMsJmwUd36+Mda32DBAqu+CphyRD9G/xfC1dWpSamPmAE3hLfg5E91OVxstXTh9p4gmF
         O4JQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4Ez2elz684EBGFPDXZRfYQLZVp3wwvi8ApuMuCS9cX0/tZ3Tebl9n1D1LIu6XCJZmRMuB4cX5rbGLQcoiTTg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmvG/uJa/eutGP+DuPU7hIf5tvQCewQcdAJ2RniaWUS6IKTR85
	RGfy1c5ElUXG1oIz85bt1S0RMkVhZWde0DgzQcRAixH9JWz3r+4YbqX1eSReEeMT1RfyiH8uJx2
	ZpoY3IcUNIiLPAah2UxDwr3lOHrdGxwMKh2AyK2UiowFPfp3F8G80J4BEe2CtlOv9IA==
X-Gm-Gg: ASbGnctlNsxWZNUb7F+PwEenJo4kvOxbHHET8FHE9E95vMN6Z4IqebotCfPekhsFu1t
	bddIqfMRzWpjV63cNB6PhhfWTfAkkjW7UXMGrwWtdmTo22NIbSud1gD5ST0S47HhYFpMP2Rx1qN
	atjMsTgcqfA1HtMRMZZWyDH2jt9/UFclp+tBVG/vDV3KP9I+EF545cmqwrGwt+v6SOspTo9dU7e
	JRuQ+aFdFEq9+Oq/XnnXHY5YSZTVhD5ji3ro62mc+XM6VTJ9yS2N6alSI1g4gS1j5cZZ0QMLqSi
	FjWucd35n1cAiB2UbZ9jo8ufqnxiyvmSJoh2/qmvXqJIKF4/9wVre7dtMZdvsjs2U3qZpg==
X-Received: by 2002:a05:622a:5c16:b0:476:b73c:4ad2 with SMTP id d75a77b69052e-4771dd60880mr197468371cf.9.1742866467661;
        Mon, 24 Mar 2025 18:34:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVT9n+uIWV+yTFZAGqzDBazB0D9hfzKlbOZdcQi/9fZb1MrVfPKFgr1nSBlOwvbQAlZ1sDFA==
X-Received: by 2002:a05:622a:5c16:b0:476:b73c:4ad2 with SMTP id d75a77b69052e-4771dd60880mr197468201cf.9.1742866467171;
        Mon, 24 Mar 2025 18:34:27 -0700 (PDT)
Received: from [192.168.0.233] (pool-108-18-47-179.washdc.fios.verizon.net. [108.18.47.179])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4771d6344ffsm54068171cf.66.2025.03.24.18.34.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 18:34:26 -0700 (PDT)
Message-ID: <831bd90a-4305-489c-9163-827ad0b04e98@redhat.com>
Date: Mon, 24 Mar 2025 21:34:26 -0400
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
 Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
 fw@strlen.de, pablo@netfilter.org, Kevin Fenzi <kevin@scrye.com>,
 Matthias Gerstner <matthias.gerstner@suse.com>, arturo@debian.org
References: <20250228205935.59659-1-jengelh@inai.de>
 <Z8muJWOYP3y-giAP@egarver-mac> <Z9wgoHjQhARxPtqm@orbyte.nwl.cc>
From: Dan Winship <danwinship@redhat.com>
Content-Language: en-US
In-Reply-To: <Z9wgoHjQhARxPtqm@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/20/25 10:05, Phil Sutter wrote:
> IMO we should at least include the builtin 'flush ruleset'

Boooo!

In kubernetes, kube-proxy's iptables mode polls the iptables rules once
every 30 seconds to make sure that the admin didn't do "systemctl
restart iptables" or "firewall-cmd --restart" and COMPLETELY BREAK
KUBERNETES[1]. The kube-proxy nftables mode *doesn't* currently do this,
because it assumes nobody would be so rude as to flush the entire nft
ruleset rather than only deleting and recreating their own table...[2]

(If the nftables "owner" flag thwarts "flush ruleset", then that's
definitely *better*, though that flag is still too new to help very much.)

Once upon a time, it was reasonable for the system firewall scripts to
assume that they were the only users of netfilter on the system, but
that is not the world we live in any more. Sure, *most* Linux users
aren't running Kubernetes, but many people run hypervisors, or
docker/podman, or other things that create a handful of dynamic
iptables/nftables rules, and then expect those rules to not suddenly
disappear for no apparent reason later.

If you're going to have a static nftables ruleset thing, please restrict
it to a single table, and never ever ever do "flush ruleset".

-- Dan

[1]
https://github.com/kubernetes/kubernetes/blob/v1.31.7/pkg/util/iptables/iptables.go#L80-L90
[2]
https://github.com/kubernetes/enhancements/blob/master/keps/sig-network/3866-nftables-proxy/README.md?plain=1#L1274-L1296

