Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EABF210F65
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 11:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743073956; cv=none; b=aWf1Zi/D95YGjDjINpaFD8I/l/3ztEMAxQJlv4OlEzB417dA6Liv1w/CO3Y6NlYpMMTU5t0G+FBhiJZpvPL5jZMwkdUIe84stb39p+xLxiQfEhAzRll+NjXQD65WpRWUCWrvKYmjDuVpvD2wFKSrMC+mpJcUYk1Cuv4HXMTOkUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743073956; c=relaxed/simple;
	bh=1dUflcNRHPiXzimNjgYlDeVxMjeLaPocQBr0I8yZUMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ANmiKcu/6c4rcJMbRi46zSVaovHJwxw6n+aW5XUZCa7H5MTFmaspwF8/ZWWKAm3p/0bnqnmkO2PySAP+WqO9wAyZyavixhCK14R6TSe7GgJsAP047f89w3LOtd6mPwOUayh6QA3+SJsasBYyVbw2Mx0+Hupdgp9G68WLZeCmbOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LIBC18a0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LIBC18a0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743073952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=whBbk3VLGCJNoBaoCRuCK56hVodmlQcnpQ3814VaJxk=;
	b=LIBC18a0Qa3WAiwoXT72PRp3jfrMUpGxgQls69jlFWb+mfei2Q0QzaDyo4esmTwaQx0hV6
	fau8JnpUupF+p8AtBpPLByQS0m4RTIYqe3egVh+5xqlGxaNDIJ40E0rB1h7QpHA3lO8LdH
	aoG9LOygbYA+SECeqImaX0mzkNI62ag=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-5aYyyfHDMRmak5gjbkebDw-1; Thu, 27 Mar 2025 07:12:31 -0400
X-MC-Unique: 5aYyyfHDMRmak5gjbkebDw-1
X-Mimecast-MFC-AGG-ID: 5aYyyfHDMRmak5gjbkebDw_1743073951
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c54e9f6e00so337243485a.0
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 04:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743073951; x=1743678751;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=whBbk3VLGCJNoBaoCRuCK56hVodmlQcnpQ3814VaJxk=;
        b=dAo7xsMK+glRWUcdf0K+kkn7upQuqwH43ij5lDbFnssJEm0NgQVWDiKYky29C/X/Cf
         NeqQ1Gq7Or17nXR3a1zSAuHz5nVIbL/Hn2DgRLS5oiO58x1UZTuwiYF7qQqVoW9emjfi
         CZC+2ef+HuPfCvtj4o3MTYzk+Cyd/gJ49rvlsvj2aNN0EdfTt6560KXQiCugEtiwqJaO
         rGU2Er2s+r6FhtHM5wC9yhWPegGqBLBWxTdIrTQHKlzZSeTDKMU+IyEsn+LFhB9PomqJ
         akPjkcHMIK0GbeE2JFyKRmmqa3uF/jxMRdPaZ/oIouaHaY8+NonG70lf/6T8zGZCLp+G
         OgWw==
X-Forwarded-Encrypted: i=1; AJvYcCWzMRkozB4tLorAG2O26zURbrmzyyVffEEOUqlleoDB2vXZzXlrfkWj1PxJ43C5LbBZik4j9fEkmJjbql1haC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvPXXlJaAcy1t4Z0qjvvgt7VHCQkOvv+6xyBGEUJFVdouUo9Gl
	nGHtErCvGqWPOYzT8VZ6OH2ZAZVuFCKOF1nz2ZGhUpJFRRzWPkX2HzGWy0DpKEVdU6FuY60qJmV
	tFa0vlJhhMxuy6Oy18T7akyyswxEMOIeynSkw+ujy3S8FY7sJCm2rmkuZjYzqVePU1BLPLC59Ky
	6i+kk=
X-Gm-Gg: ASbGncvxJXiP2yfgMk/u1ZliANVkNcq+cVQkJPQ+SApDbNbM6GIx0NxfcwGLDyTcukm
	DWJCcho54jvpOqgeF+9um9HN1zyyL+stMYMLKZT1POvXHXRHYn8iWPzU/FZkzmeZWOdC6XZZrKH
	EpPT6g4KG9ZRvKLhWDIvJnwG1u5T4GeHvzcq0rkkCqW8FiyfbseV5jkgNphZlgYD2uFj8bnfqNk
	BeUoTpIGx7OBC5DudmeZRK+r87rDdPuDUeSMT0Pv57o6JxmkDcGN452gaZcKkYB3tCdJlX7K0a1
	5bceQr40S8SugmbsdSGtwjvsRIgVEbubm02nGewtTzgGA5kH4TvaHu2tfi07jxniQf6xPw==
X-Received: by 2002:a05:620a:3706:b0:7c0:b490:2c26 with SMTP id af79cd13be357-7c5ed8c665amr551619385a.12.1743073950943;
        Thu, 27 Mar 2025 04:12:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECIu4B9ulsv8eQzIDcqNtJJf8gzKQY+i4sEz6JcLYT9Slg+wwEPNnKpuPglPQ/B61/F4uKtA==
X-Received: by 2002:a05:620a:3706:b0:7c0:b490:2c26 with SMTP id af79cd13be357-7c5ed8c665amr551613785a.12.1743073950425;
        Thu, 27 Mar 2025 04:12:30 -0700 (PDT)
Received: from [192.168.0.146] (pool-108-18-47-179.washdc.fios.verizon.net. [108.18.47.179])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5b93482cesm886110885a.75.2025.03.27.04.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Mar 2025 04:12:30 -0700 (PDT)
Message-ID: <4cf4948f-e330-45e9-98b9-bbef7e2007be@redhat.com>
Date: Thu, 27 Mar 2025 07:12:29 -0400
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
 <831bd90a-4305-489c-9163-827ad0b04e98@redhat.com>
 <Z-QjsRMmEq90F6Qg@orbyte.nwl.cc>
From: Dan Winship <danwinship@redhat.com>
Content-Language: en-US
In-Reply-To: <Z-QjsRMmEq90F6Qg@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/25 11:56, Phil Sutter wrote:
> The suggested 'flush ruleset' stems from Fedora's nftables.service and
> is also present in CentOS Stream and RHEL. So anyone running k8s there
> either doesn't use nftables.service (likely, firewalld is default) or
> doesn't restart the service. Maybe k8s should "officially" conflict with
> nftables and iptables services?

(It's weird that nftables.service is part of the nftables package, when
with iptables it was in a separate package, iptables-services? But
that's not a discussion for this mailing list...)

>> (If the nftables "owner" flag thwarts "flush ruleset", then that's
>> definitely *better*, though that flag is still too new to help very much.)
> 
> Yes, "owned" tables may only be manipulated by their owner. Firewalld
> will use it as well, for the same reason as k8s.

So in the long run, this solves my problem, even if static firewalls are
using "flush ruleset".

>> Once upon a time, it was reasonable for the system firewall scripts to
>> assume that they were the only users of netfilter on the system, but
>> that is not the world we live in any more. Sure, *most* Linux users
>> aren't running Kubernetes, but many people run hypervisors, or
>> docker/podman, or other things that create a handful of dynamic
>> iptables/nftables rules, and then expect those rules to not suddenly
>> disappear for no apparent reason later.
> 
> The question is whether the nftables and iptables services are meant for
> the world we live in now.

If they're not, then distros shouldn't install them by default. Having
them installed on the system (or provided as an example in the nftables
sources) suggests to admins that it's reasonable to use them. (And
having nftables.service use "flush ruleset" suggests to admins that
that's a reasonable command for them to run when they are building their
own things based on our examples.)

> At least with iptables, it is very hard not to
> stomp on others' feet when restarting.

Sure, there's nothing that can be done to improve the situation with
iptables. It just doesn't have the features needed to support multiple
users well. But nftables does. That's the whole point of multiple tables
isn't it?

> With nftables, we could cache the
> 'add table' commands for use later when stopping the service. There is
> margin for error though since the added table may well exist already.

I was thinking more like, the service documents that all of your rules
have to be in the table 'firewall', and while it may not actually
*prevent* you from setting up rules in other tables, it doesn't make any
effort to make that work either:

ExecStart=/sbin/nft 'destroy table firewall; add table firewall; include
"/etc/sysconfig/nftables.conf";'
ExecReload=/sbin/nft 'destroy table firewall; add table firewall;
include "/etc/sysconfig/nftables.conf";'
ExecStop=/sbin/nft destroy table firewall

-- Dan

