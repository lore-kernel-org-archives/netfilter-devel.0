Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDEC3B2FDF
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 08:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780909018; cv=pass; b=qmFSwVd9CKYh0YDWnr3x0VMoMXqBSavKyrxQnnsA9b14LWV4MtVljYj+qvrDrhLHfNXoD02orW8X4G4o3JJQPbHV0KCvHSIpgq69zS0IiIkORnF3kF9pN6of9V88Kgg2IfcUbfL25Ko5fwUAX4bmuA6R/Q1icL33D8MbzDOCiqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780909018; c=relaxed/simple;
	bh=LwxIwW/8sD+a8dH7BmKDVm760AW1Qz08Sjhbp52fqyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BEQF6dDA5DEBTS8JXddP0/eQgean0Ar7Jlf14h/co9fxewYIF2AEaEb0LOP2ETpoUJTHqBk4maVflkDwzz6h3chYFkrOCv8s0k+h6+RRZ167AZn9bdZ71ew9zSxzorx3xuKFz3wfFSvarXJN3rlb2X/RQ+W33HxtxF8YrXJGeNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pc1lVOFh; arc=pass smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pc1lVOFh"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-48611862583so1861289b6e.0
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jun 2026 01:56:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780909016; cv=none;
        d=google.com; s=arc-20240605;
        b=is5jvDLICXjctEXyccyZy7pe2Sh071SC9gqYuzWT/pYBmOGOE/xsmd/dZcYBh+wujj
         ILe/da9eUWyFBWCq4d3QhaGKLQJOH6KEjTaCTUqNDCM6dh7T2n/1S4GpEYEL1TxkKkA3
         6I3Z5gGLJ3vxrWABcILXew1mdGSiqYURi8lsb19FM39aAFNDppxMvk3fXOhay/sVHkVy
         ljlfTySGNhPsvwbBYkB/AAKZ6F05Ja5CHluoIpG/veKVrSG45zZSRPkYQCLg+YPzerUT
         0QLVf0ss26g0mh7ExQ21rROM9s6tW7S0oix52M9Jj6XdeM+F0OSEcxV6D9kYHeJt4LCk
         0poA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LwxIwW/8sD+a8dH7BmKDVm760AW1Qz08Sjhbp52fqyU=;
        fh=6udy3HooIcGx1luKc3AiNxlIaK8rXVSMl/Dtrqckgjg=;
        b=NR6KPbYEKk+0CDz+m9T3I2InlB507WbZCm1CCftSBphHBjojsXn6i2oe/+AOE2Ex8B
         E9PlzUVJoG1VWd2VSgtB2lJldeGFUMMuoKZzBxcBdAw+P6ErAJW+/pQAdPOSsuw09edI
         mnDa4C4ZvBLXclftpfpeRs/PkOcW/Dxu9lEeD8jQWouVD9uJOLnL1UNs0Xuu5BgKGMko
         G/34NONNakVXKfEVRkQ9E7Q1m6Ct141YiSij0PRRzuU/sm8mYcseOe5q+V88iF5SnAuW
         wNlZebvRD1rAhj6m9MXzGk+sIxa6FhA3fYXEba0Y3rxl4Pb4nLsZdipvpU0lDphWqxyD
         l+3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780909016; x=1781513816; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LwxIwW/8sD+a8dH7BmKDVm760AW1Qz08Sjhbp52fqyU=;
        b=pc1lVOFhIA2nPuoSZWIczW+AJ5h4gwx6pvVWOjpY9jTYJ2x0YEOtTLe8FPKLkw7hW3
         B396OyIr3pS+LLP6t0aFtZtr6OuOgGyLeYoFVkoIU86ZmO7y8+qq3UKRydtyUqCP5Zur
         386tGBCVlMtLIFCtxZmV2N76+eQzB6bxvszzQEg7TOR3CD+nlOcW6pKKZ+IU7j2qRJpf
         WeRpbuLngiHA2Uq+bBODc/QHJCOielz/MmaIjrLKHlGFwB/OWy4Gnl0iojwPsm7r96BP
         iJsHnfvYZdaVbzeCH86qhhyTiCKjzN8fUySsLx9c2L7MlkqmRvJfKm4bvff9B1qxEXV3
         nayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780909016; x=1781513816;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwxIwW/8sD+a8dH7BmKDVm760AW1Qz08Sjhbp52fqyU=;
        b=Qda1V4Usj5wYnE0YgqtM2Z+e+9O0+JcUPkh/iXAMPM3YRos8DYMT9QXl1j98kB3ggS
         6IMb1jJqXFr/JrXSGvHqXxOP0UWG4QZorm0y/w/LN6xlyEKtsHiy+6QvAtECQENIU+Nx
         26hmqEpu9Qg+ziXTnpSAPoRby7nP1KAqoiElJm7IuQ7qqHE3/ZK2twvlQIxvXo2KOsB9
         a2MyD7AM+VJKklh2tldeVQT4CST0zgFPnUwH/lBmVQDAehkKRcPxTXVVax3S5tc8VzPD
         RncI/0znNDqX+iyNskA0S4PKm3UMMujr+4dEqbSxeL+3Cy+zTC4lNPl1928DnkRqJcMO
         3Sbw==
X-Gm-Message-State: AOJu0Yyvqmy6Y2wXvdlrcaSLNgvXoNqWqliqs3xlqWfzqVJXD9uZo13p
	s8QZ7fT5MH3cQrq2gIeuubRwuBMJE0Vnq2PrUFV108sYL6L8q5Y6/uKNCXmz7OtrJQxzfp++uC2
	egMS1xVOmx6XNTF3Yw/0SptipyelRT8M=
X-Gm-Gg: Acq92OFgxvASErT5mQ2p2llxW/BCg6h+Ig0VKKVWaJRu0jAXWj9xXbJ+MWg0yoW5Drv
	M/h1yyE0UMc6DpCKG6M7bV02vvN/1GizP/R+kAL/KI1txUsvSnVuv7Dk5YLkXWOLoTYx9w5+qjt
	bo4egzN4XoSK616gFcNffqmjHmU43tnB/j8Dolfyw9RelBYL9F//ON7oq5nurzSGKdWLYolQjEm
	SM5dlfUTrK35YDWU0gGJjkwOeZwhzzvEzF28W2/2pKY/eSF/JNT22ZhnfAjRb42M5RAUZtV1gjk
	TQ0o8Uk78aZpvymsOw==
X-Received: by 2002:a05:6808:c227:b0:479:d25e:9065 with SMTP id
 5614622812f47-4868dbf286dmr8670340b6e.2.1780909016021; Mon, 08 Jun 2026
 01:56:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260528204020.7ae744ab@pumpkin> <20260528223412.27311-1-kacper.kokot.44@gmail.com>
 <381e22d3-fa30-4dde-bd53-705b4a868a90@suse.de>
In-Reply-To: <381e22d3-fa30-4dde-bd53-705b4a868a90@suse.de>
From: Kacper Kokot <kacper.kokot.44@gmail.com>
Date: Mon, 8 Jun 2026 09:56:45 +0100
X-Gm-Features: AVVi8Ce6zhPUP8TY7cm-36Laz2FamQqIli7a22X0jjY8iIAtnrJlrSLepV15u-o
Message-ID: <CAG-Fur7jEQQByhZQsEBVGi+TUdoh-Lrx_LZaSvaTs_Y7VGRBsw@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: TCPMSS: fix dropped packets when MSS option
 is unaligned
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org, 
	fw@strlen.de, david.laight.linux@gmail.com, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Will target nf-next and switch the variable declaration order in v3.

Thanks for the review.
