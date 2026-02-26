Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B880A374752
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 11:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772106495; cv=pass; b=J4UimvHaHqxNDJsCFfCVWBncTu1r0QdZ1uO0XFOWt8W3WA0dwoyEZxUZxrMNFz+V24gOhSvwhtK1VicsLnAinX9bmbJmT7/qVVrC1t/yvEVQZtwiJ8sKl/vGMayIbPX3O2LPaSONAtBYRg5eyshSYlmOsBTapd3Z6UDwFU7GAy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772106495; c=relaxed/simple;
	bh=iG4+aWiP+q77ZjskdMgfoWMi21xv7Mz5hH8zT8534uA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cwjf5U77kS9t8PBMOYv4fNYi7rIIXwIW4lgB2BmgfKjA5B2lIdPy5/JRrP+YBjJBxetNkq7TgTUmBu03g/QryITrj4yqJSoOASqWKdYARRGjKmpqby5pMO7JQDr53WOvDbe37DuX3WapHXucT3NiC6peH6MqMbrHEcizRQHzhJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CuFG2oxC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MO6BTwyl; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CuFG2oxC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MO6BTwyl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772106493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iG4+aWiP+q77ZjskdMgfoWMi21xv7Mz5hH8zT8534uA=;
	b=CuFG2oxC5n+uzd/zqjDHlCx6h6nSoIGZlPOEEymyQ+HBbqLGZBFw3V9L7v3Hb1k82AhMn0
	zN8OWIgWcbrGDLWjnbj1/htrOfCYeI2vS9WunBRnwINrsWscb8MjzbBx7jY8RenKRzOQot
	hNyVkuabFgbExThrK26ndNbbTY4mh2U=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-8WZVpR8RMv-uIlv0dhlbtA-1; Thu, 26 Feb 2026 06:48:12 -0500
X-MC-Unique: 8WZVpR8RMv-uIlv0dhlbtA-1
X-Mimecast-MFC-AGG-ID: 8WZVpR8RMv-uIlv0dhlbtA_1772106492
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7985951fa83so12470057b3.3
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 03:48:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772106492; cv=none;
        d=google.com; s=arc-20240605;
        b=KGQccMB3putbSaMGzW/Vtpdsu17BvUPedpzPKmKDlbti9QVj/FsTrvDMrLC9vIbx65
         CdZenYlwwz/9CSUQTqHfHgzbcrf/pepzPlN2EcDLtT12qOzTBP7Nmc96pYW59J/VF+AR
         BMmTWF62S8zQFHczw7cfUcOE67m7UShhVQt//KiCUTGs7lZIIP4MTee4x3hSemLl3XSN
         lZPdJY+nNxq2No61/+aKLtqQ6azk152t7kh6z9ciLiL5+BHz9QGPgmzlglUGW3R95Gz+
         UYfsJqbNSj48YRmkGoSg6WPStNSXdP3Eovn6ao2WYddR64GTAZMxzcgK5xlHt9oAOqLb
         kV7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iG4+aWiP+q77ZjskdMgfoWMi21xv7Mz5hH8zT8534uA=;
        fh=lQWejN5QyUYMwFd2zPmL2/5Fp6K6gjO5A0CAnW05n1E=;
        b=lzD/cATdBlWXPFtUBOpl3Tw9CgmIe4QgUzGfKYulcjeEc7wx/ayY3lnanT7KRTGBPK
         v9PYz5V73tcTOaM4+QywERHNSSBJsSigSmb9vWy8NfRfSEcZcPpWU0qTE0bowrW4oUtN
         hwKhNQoQNBmHWWoTt7PrHS+eTT6qn+LNPulK68R087y5EO2QjXO7sLZMTkNi5iS1Ye8I
         TwdddGAqyXJPXbkfYHAPZJSIJ/EZSAME3R9qpz5nhxDRiU/o1ZKT8zA0HKsCXcyQW6dS
         +IZukRT2Jo1FSD//5e0PEyawdiHmM9VLAMXQZmr5jh1xrhub75mQlcuWSsBIy+d6UmRP
         bVRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772106492; x=1772711292; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iG4+aWiP+q77ZjskdMgfoWMi21xv7Mz5hH8zT8534uA=;
        b=MO6BTwylq1Qo/BGkecGUY+Ulmnr7fz5VL6ayU2Oj63XMyLXWtgmwCymdicSMvEM3xp
         r8dbOVy3jWQAYD8w1DlbF+nYE5OoT4Bd/G+c6PJNnj7Zq6jfQF4v6DUHrs9FNnNi9JH/
         xGMCSJuGZcA8s4pqMbqZKHL+THoCeoNHVAWbp50HvJywiJ3q3/DuzdyYUQvozxB72xlF
         duvprtQlh0D7D3/P/M9TiupQOSpnJQmoZzJpCDdiPcKXxFQoDWCz4Yl8uj+r79D7SnUA
         m9DXZ29NdnGO+ImXqmISuuNEIaOIdTLXzEL8UYifgUuoB4fYmFJTQQmIO1JqRKoGJRft
         DqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772106492; x=1772711292;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iG4+aWiP+q77ZjskdMgfoWMi21xv7Mz5hH8zT8534uA=;
        b=AjA44TpJ2uIv4Wsd90elnznkw7lfPoAyKp8OwS/7u0602bnXYzcdSKcFCCNdJyPjTT
         sMxBPUE8kwBBH9dY9eilneYtMhnj4lj+SKeLH93Te3AT2v1lBPyGIkx0ZuH+hbWnF8N4
         UKMXKQL4T8772fWzyLrTvfQgVdTN7FPJK5HOeyoYUVmLLHowZCnYxfw0GpI1KrKWvCmX
         7P33RS1/mqLxr1Y2ZVJbikxG06KS+gW1v7uMHNs1FRA0SMHuia5H3uRHKDs4xBL2jyHl
         bwTAUdvR80Au3Y0SqVCoFabbQDMjPuxdGb7Zz3sS8GeacyX0n4SEhsST3C8+gdw+6sV0
         bIcA==
X-Forwarded-Encrypted: i=1; AJvYcCUyUggLWKGZIFYYb9cGsNIGnkOPglvatyTJwweAq1sHvD2tr5I+S/O1Y4l6CnfJqzzRFrDMsaQikfnkQW6Wnlc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtaneDlk8frSL4XxVwIn1puwMJIc1KDdQ7roUDN2QZWgL3Dbdk
	Ms6/NfKwTpLOvHZY4+79WSmRIFLg+7ULLRxWisrR4zWfxW49DCTBmHPX5HeCCVJOv6nXtxH+WTa
	RWAlWYdIUZWDLFq8sKn+a9zNti+fWkW07vlKDJQRq1wrj6NlKKRRjyx6PdfC6wFXCZWZ7zP6zj7
	3XfFkBLMtorsBgwPi/XWodL36m6y1b1W1I+Fpfh98+APCA
X-Gm-Gg: ATEYQzzAPDoUUtSEOm9yS1HCwsUKtYm2TcrpbI4/R6FIwH9i4RtMUST+NGwFMZNJMYR
	gvl/GMKzY3PdN14HZry+ZuECGI1TOIh96AUh0qjfhN4hcN3RfzrvOmf+1o4C/Rpp1dyFHLl7ujd
	oDRtvuFJoX9l3ws3MGj8hNqiQ8Hco9dWVjwUTL2k0pNshVxwP8y0uHvf+YhULNHqAsYlwPeI8BE
	MGgMIZf
X-Received: by 2002:a05:690c:34c9:b0:798:6c25:f453 with SMTP id 00721157ae682-79876e4900fmr16440497b3.63.1772106492050;
        Thu, 26 Feb 2026 03:48:12 -0800 (PST)
X-Received: by 2002:a05:690c:34c9:b0:798:6c25:f453 with SMTP id
 00721157ae682-79876e4900fmr16440327b3.63.1772106491695; Thu, 26 Feb 2026
 03:48:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260225130619.1248-1-fw@strlen.de> <20260225130619.1248-2-fw@strlen.de>
 <aaAOFygrzyyp2a_z@strlen.de>
In-Reply-To: <aaAOFygrzyyp2a_z@strlen.de>
From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 26 Feb 2026 12:48:00 +0100
X-Gm-Features: AaiRm50ZL9RNmmzdTiw_9-16C73z21lzCUwUswljThG-Njp7LyCU7CVfR2pJpnw
Message-ID: <CAF6piCJis=8hp4o8puLH+N6jDiraPvMyBzk_NW1TsndekmRHPw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] netfilter: nf_conntrack_h323: fix OOB read in decode_choice()
To: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On 2/26/26 10:10 AM, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> From: Vahagn Vardanian <vahagn@redrays.io>
>>
>> In decode_choice(), the boundary check before get_len() uses the
>> variable `len`, which is still 0 from its initialization at the top of
>> the function:
>>
>
> @net maintainers: would you mind applying this patch directly?
>
> I don't know when Pablo can re-spin his fix, and I don't want
> to hold up the H323 patch.

Makes sense. Note that I'll apply the patch (as opposed to pull it),
meaning it will get a new hash.

Please scream very loudly, very soon if you prefer otherwise!


/P

