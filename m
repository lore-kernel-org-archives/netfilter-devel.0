Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF09B139578
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2024 19:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724873790; cv=none; b=DNYvibbpzj4rXrOXFmESuylbBUiXdBG7WtHSloaTsDWur1AKqN6bZRkLq8opU2g7zFYClWEWXmdlL0swsA3mW1+/+4YexQjfoHjUlsv6cvH50UU31jKFTD7BD5076CoOL5bLzdFvA3fDIFZb4L80WYZOdlnSv6XpAqG8KN78vSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724873790; c=relaxed/simple;
	bh=bXt4rOpVlF0iyTlsskpgNlah8EsHeUzEN1QkBrEYNCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DBgss3eYU+QAtUSx76vjsQn2AlctuH45as/H6W0iWOJSc8IkS3sSJVyO2mjOYKIhgtSR8zZ7o3ikLfFzhEfFsIEbdB6vsjTp8YZTfqJ158v11oXMnC6jvjhr/wNclP0qSIVjJAevIA7cWpVxRBXo0q5GVsXEOOsm94B8dbEBdxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lethedata.com; spf=pass smtp.mailfrom=lethedata.com; dkim=pass (2048-bit key) header.d=lethedata-com.20230601.gappssmtp.com header.i=@lethedata-com.20230601.gappssmtp.com header.b=vJYooYux; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lethedata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lethedata.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lethedata-com.20230601.gappssmtp.com header.i=@lethedata-com.20230601.gappssmtp.com header.b="vJYooYux"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-498c8a6220fso2320708137.0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2024 12:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lethedata-com.20230601.gappssmtp.com; s=20230601; t=1724873788; x=1725478588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bXt4rOpVlF0iyTlsskpgNlah8EsHeUzEN1QkBrEYNCg=;
        b=vJYooYuxtZU9w5sMhWXMhsuUaqwqUw/IO8gRs0qPTYge4KZ6VJ0OBTKVro8WoA4FT4
         kSneePLcLcELn4BHnrVM3C85XvLZFKn/+rvNSIJoB62wECADv4/nil//tAOXGAtWLoXp
         HTGNngQXbYNoisvpHpoKvYTEk/YtoXTw/2JssQLG7nUZbXg1uDpr4dSKwUONQi7K64ET
         1P558dLsMl6o1o3vJFrGrU8lJpxk6AfAODj0nb9IgibCCOijMMQTfFzqepeWm+/6ebwp
         S/V1q3vOb4TvQ88J4pgyE/JZsFmitB3hwToVY9g6jwh+S3j8sqy2Lbq4tmBGP5uDfi/M
         nDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724873788; x=1725478588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bXt4rOpVlF0iyTlsskpgNlah8EsHeUzEN1QkBrEYNCg=;
        b=gG7hUJg0pE1mryKV7zT0Cpi4X11cqO2/IlGkz7wnZe0kdTN0gAisFKxdbKiC0KApOJ
         2AhGEBBsmxdn9LZ9Gk3RvSt8TwEfxqn2uq6ozjr1fRTzA3YOKuzWoxM8zJLBgNDEX6Z/
         p8Y1cEdgAzAkcyBPAElX8VpWsZL+J63uWJXijlh0pNp4/4/Ik0YdublF+meCv2ElW81I
         sFp4RStEJN1q/s2bC2jkew/YhdIyg/AlXfExSqjXTSlRvK24mnVH7PAudVDH6mqicf5o
         8FxfP2UXPxR0kbzR8mNv+SWgjppw0P41goU0UrSRQlU/p0NgigOhOCUX70mZlMDqACQV
         tHgA==
X-Forwarded-Encrypted: i=1; AJvYcCX6X0anYzBmG5djereQ+xB8UfOExmPfxOP/QReSOVHwy+SAh1SVKLxP1oLdubrWx65QXh3hcvWx1jfxRo+ZzBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNXyzjySMuslxJ67azAadiG7o5VKK6DGnG5p5iAZkoGbfAciwd
	gKGx3tqH0qg5JrfOxPUTke2Rae2H/+mu3AyhKy3CBS5vPTi4X/XxC3a6P8/Nz/KFOsFVR/uhKtq
	zVp3UKZjCMZ4wlvLF7YlD/38MyUXtNqURryODeg==
X-Google-Smtp-Source: AGHT+IFokLkFIoKOAP2kzlDsbbIUCc1X2k8T9Ug7aiL/mJnpuVtE5wEh0fqNh+9mDIkRH3A4IJPPxLbBYjHYjJRYNJA=
X-Received: by 2002:a05:6102:a4e:b0:498:ef8c:cb56 with SMTP id
 ada2fe7eead31-49a5b24f48cmr998521137.24.1724873787687; Wed, 28 Aug 2024
 12:36:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANsOo6on+x7OrWQN5w6Ls5RwcLHKx4Kmrp80-fPxte2LQfcuOQ@mail.gmail.com>
 <Zs8vSUOWgM5MpLxu@calendula>
In-Reply-To: <Zs8vSUOWgM5MpLxu@calendula>
From: Echo Nar <echo@lethedata.com>
Date: Wed, 28 Aug 2024 14:35:49 -0500
Message-ID: <CANsOo6ox5gwM1qXErBe9f4v=re77BorWjm6FoCqx19WaigmwQA@mail.gmail.com>
Subject: Re: Stateless NAT ICMP Payload Mismatch
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 9:08=E2=80=AFAM Pablo Neira Ayuso wrote:
>
> Would you file a bugzilla ticket to request this to make sure this
> does not get lost?

Sure. nftables nft bug 1771 created.
