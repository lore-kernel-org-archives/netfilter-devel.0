Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F259334B682
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 11:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763725021; cv=none; b=dikvPKmw12LP3GExtUZfiAJIILI0RB/p3y+AU3JDBRPyN4gr4OkInj4VCW1b9hcpe4yV8aRejmeRbt8MSEXdurqTaYSGpwgpTB3Nb5Gb3+iOgwjyMh11TYeOtsr1TYGjjIPfmv27RltPgmFTEM5Q6mgzoGJ0nMY5DWnLr87JlpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763725021; c=relaxed/simple;
	bh=LOYpujHQoJKoShOTqgQ9QJ9SHzwlbcEAO9ZGw/MItV8=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=oc4dRIyIkLELezBR21ifvV8bM9X1wlmwWXiBIknQl0S9UFBFKXtqyS0jFRlra+HVjsvRHLwoSQRSxCCRoihQPRx0MlvjEUVcX1b6DCtoBhAaxIuG6Iwjrg9NZrxYstQGYozcEGaU7di39zaF9WsP3x6WB0P8ITrlZEh1T+0Ib1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WOKE6M3W; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WOKE6M3W"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-429c48e05aeso1291902f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 03:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763725013; x=1764329813; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CS8gyqFzkQ6r/Z2UVvHxbPt1ypXcs3FwemCtMOsmk8s=;
        b=WOKE6M3WUK5qGH1nUZNItVGAOnBqI48n/Zlz95GC7nUDWdm0gjVuAVt0Ef/mSk6AGS
         Ql+DZLVaN97BolVfxXna9T0lWeGeCpC5iDxEkufsI6hz7r2RzoqvzT1E0F4XNAbIzy0b
         9L6jG/Oarxp6KUQ75V2TUgOU7KegL4jfR6rcNhtn0owvMbyjSx35oU7MV9CefL4aZeNT
         5sH5MUSb3vGvGhmu6CZaBj3NfwqnasOFRKRPv1ebaVKJwEIQJF8EWDVFj0ihLCLnDhfg
         rJk9mAMJMPXlTIM8PeOJVGk31LnCSr60KCKuxGtKHpMyEJM6IJy07Z7P5yBsQN15gpWP
         0xcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763725013; x=1764329813;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CS8gyqFzkQ6r/Z2UVvHxbPt1ypXcs3FwemCtMOsmk8s=;
        b=glBr+b3g08V+6YCiLVn4aGsa1prm98zp+ZhNU1Ez7Lx75v9hBsLx6TpYjBiVK+/uiH
         3kpVQPI6+jXIYWyd4mt3UbPXjGh52R4FQlTWvkQAdjlju17tMHkyZIiP/F1VTkXmOfzH
         zjG9a6OWZolLKj+kc/XjzZtumGwQzT7cT5mIIhU8K00xW8fQhf+uhPdWN7w7/kmFp3CW
         aNCfFMPnORp/5VskcZHhpeUKtXS7MvR7oixg+w7Rw5y6qdbYVGf5gAJ14IttsPGGS/kv
         ouqbjz7xcfUIkY1bxxYcvbXmxaQ3hukqTnlrSO5R2bOaVa/af7qkf5qEwdi7rzMOetAu
         4kdg==
X-Forwarded-Encrypted: i=1; AJvYcCX/qu8KdfHQVvO/OgCI43KFVZjBhnsm8IOgSwhLaKBcZXGLmB0LXPSqZ4hVvGKTwVb35mew8PPMoqWsDEcUSqM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8+wGqW1DJncXEEIRQFzmhET6opDbEa59N10Qib40ez395zTJs
	dzwZbI1qv/aOcO3DwbSsKPmvVzat7v4IKClHC/l13EaXQl3Rw2pk2KoZ
X-Gm-Gg: ASbGncvfq8iB1D+l/26/TP6vEuUIPtET3ozFleWAv42DQ5yhRqvzgu9SK3P/NADVTsy
	FG61zsX94OXCYx9rg2gHF9uFSODFcEUyL8AE8sczRVLqsqb5M+vN+GgyqWU0bUhuAyV5ouUFzrY
	ORMaBb2wVfL5OhMqWq8aRa37OvhCQrBhc4uiGL7mX1l5WnJz+ztCRkEMDwLt1EpJlXceZbMEaDV
	oC9de6NUgRAY38Png5q5yAm31SkErZkzuZ8kvb+37nAjqSl9ykNIKX6NGj4Uq05I2ahgWybmnPj
	163RmAWGNSmF3iPGP5AEllfebsgqhmcKXLEPrWBebatx7yuuGvAsJELikUagGi79C8qjbkKDw74
	fXqxXFd6CWJemxta56Cgw1hM0H1Lc9JTgmbJLtizfOthQkRy0cGGHQx6J2B57S4fa3oRdKAAe+F
	x+2iXUy0cirK14/3t6qQAw0mk=
X-Google-Smtp-Source: AGHT+IEOAgZmPr6L2R2ZTzAQtOA1RU1DqXWvah0GGKJQuxKtItTZR/EwGeyivvDwMsUN+Ewo3KC8EQ==
X-Received: by 2002:a05:6000:4026:b0:425:7e33:b4a9 with SMTP id ffacd0b85a97d-42cc125247bmr2705819f8f.0.1763725012584;
        Fri, 21 Nov 2025 03:36:52 -0800 (PST)
Received: from imac ([2a02:8010:60a0:0:f819:b939:9ed6:5114])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fd9061sm10506268f8f.41.2025.11.21.03.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 03:36:52 -0800 (PST)
From: Donald Hunter <donald.hunter@gmail.com>
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>,  netdev@vger.kernel.org,  Pablo Neira
 Ayuso <pablo@netfilter.org>,  Jozsef Kadlecsik <kadlec@netfilter.org>,
  Florian Westphal <fw@strlen.de>,  Phil Sutter <phil@nwl.cc>,
  netfilter-devel@vger.kernel.org,  coreteam@netfilter.org
Subject: Re: [PATCH v5 2/6] doc/netlink: nftables: Add definitions
In-Reply-To: <20251120151754.1111675-3-one-d-wide@protonmail.com>
Date: Fri, 21 Nov 2025 11:33:06 +0000
Message-ID: <m2qztr4o3x.fsf@gmail.com>
References: <20251120151754.1111675-1-one-d-wide@protonmail.com>
	<20251120151754.1111675-3-one-d-wide@protonmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Remy D. Farley" <one-d-wide@protonmail.com> writes:

> New enums/flags:
> - payload-base
> - range-ops
> - registers
> - numgen-types
> - log-level
> - log-flags
>
> Added missing enumerations:
> - bitwise-ops
>
> Annotated with a doc comment:
> - bitwise-ops
>
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
> ---
>  Documentation/netlink/specs/nftables.yaml | 147 +++++++++++++++++++++-
>  1 file changed, 144 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netlink/specs/nftables.yaml
> index cce88819b..e0c25af1d 100644
> --- a/Documentation/netlink/specs/nftables.yaml
> +++ b/Documentation/netlink/specs/nftables.yaml
> @@ -66,9 +66,23 @@ definitions:
>      name: bitwise-ops
>      type: enum
>      entries:
> -      - bool
> -      - lshift
> -      - rshift
> +      -
> +        name: mask-xor  # aka bool (old name)
> +        doc: |
> +          mask-and-xor operation used to implement NOT, AND, OR and XOR
> +            dreg = (sreg & mask) ^ xor
> +          with these mask and xor values:
> +                    mask    xor
> +            NOT:    1       1
> +            OR:     ~x      x
> +            XOR:    1       x
> +            AND:    x       0

This does not render acceptably in the HTML docs and it deviates from
the way the text is presented in nf_tables.h - the description makes
sense in the context of the expression defined by expr-bitwise-attrs
which bitwise-ops is part of.

I suggest moving the doc to expr-bitwise-attrs, which has the advantage
that the ynl doc generator already handles preformatted text for attr
sets.

This diff should be sufficient; note the :: and block indentation:

diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netlink/specs/nftables.yaml
index 136b2502a811..23106a68512f 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -68,15 +68,9 @@ definitions:
     entries:
       -
         name: mask-xor  # aka bool (old name)
-        doc: |
-          mask-and-xor operation used to implement NOT, AND, OR and XOR
-            dreg = (sreg & mask) ^ xor
-          with these mask and xor values:
-                    mask    xor
-            NOT:    1       1
-            OR:     ~x      x
-            XOR:    1       x
-            AND:    x       0
+        doc: >-
+          mask-and-xor operation used to implement NOT, AND, OR and XOR boolean
+          operations
       # Spinx docutils display warning when interleaving attrsets with strings
       - name: lshift
       - name: rshift
@@ -1014,6 +1008,22 @@ attribute-sets:
         nested-attributes: hook-dev-attrs
   -
     name: expr-bitwise-attrs
+    doc: |
+      The bitwise expression supports boolean and shift operations. It
+      implements the boolean operations by performing the following
+      operation::
+
+          dreg = (sreg & mask) ^ xor
+
+          with these mask and xor values:
+
+          op      mask    xor
+          ----    ----    ---
+          NOT:     1       1
+          OR:     ~x       x
+          XOR:     1       x
+          AND:     x       0
+
     attributes:
       -
         name: sreg
