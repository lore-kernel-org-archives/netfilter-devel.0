Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A871E5B78;
	Tue,  1 Apr 2025 08:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743496120; cv=none; b=c2TJ5JP7FRxKnhVMoBEvYbKf6ijsULfc6OHgzQSR8mrXCEHKTEMXE12wUy7FnUOA5EdqswpLlhwNheCJh48WwalDyHzurBNMBgv62HnQh+Q9K11fhRzYXZsHaj6G51f/+7Caddr9Hqu6WDC9rL7LPIz4vKwvs04xzZmvxZT4yPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743496120; c=relaxed/simple;
	bh=FIQRNqALScV1BSz3+stZ9gXajjKm+lKccjTA9d7LlrU=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=KJj6jAqYnczkKQTO635wnUgTGUKxzqcMUOqetQBSyOgICJKbqL3brd3mgavwPMOacH7ZbPACrIAMQjRxH/I7DwyCY6a+ySEK0bO1KDInYQKSy69hZTg9EzZhIcoI7UIDnXnJx1QFkoNlMGgK0sxyWhor9SPQdCvlWIQyxg06XXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V3y6K5FF; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V3y6K5FF"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39bf44be22fso2664068f8f.0;
        Tue, 01 Apr 2025 01:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743496116; x=1744100916; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ooc6+DVp9r7uPavCnUFRGj00nf3JAwQAzWilPBr2i+o=;
        b=V3y6K5FFyg5ldAyBMFfmvMWsTHrrbX2j0rRmhKHqTEKzzsJPxeUv/uQFx12e/A3Ty/
         8zdKoAVHDFva4b4GDx2qmkLQuRiQUBJmymt3lsolb3Sny8yViAjcHwRncsYaOaQnUkXc
         ouKQv+DF/Q1GFFzMQClisJEvuUh23xl2Gr9z6BogsM82Rt/n0hGG4F39lmdh+2xbZ6NT
         nso9BrSTUHO1MEBL4AoCGPgfZD6uhsqbie4gnQuDPhXlpZJq9onPHS6u6+ql7vcVq1Xp
         V+gQRaEgaGAKCO74v5pKBNKFAE+Zidx2JoWWPAxy3+v6WNoWm6J3eKGcbRblsMi6jrNP
         3KOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743496116; x=1744100916;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ooc6+DVp9r7uPavCnUFRGj00nf3JAwQAzWilPBr2i+o=;
        b=eYwSu3f469Nw2mghTRJV1wAw7I7plBfVi88im34le9GEs15ppqCt4ezNN351vMqpZg
         Jy8QfvNgcfUDYVTcOk9cEMzF5sfAxLxJTtVczqjEaMDRORosLPblUkP93WKRwnkNemsb
         KC9melXOrRmPqcqSmKnn7oiP8XGLdfVnGOmSjiIkWOMXnINQdu+4oY/uoTsqhY7wlCAh
         NKKcEBeFIpKXXiNShwxvC1nqVyVTDhID9dWuZPo/zbjdgypXnpBwzKUPur5u6YhK8Kj/
         juE3xYvWVQ2BI1vqLeIntl9Rcnyla/HzyREMKD1nRgF1sh0ZOdtRq+WR7fOJMzK0lwj9
         VuTQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6b1LIoeCwjG3adFeUQroTtE2K9ZvZgbqmwH3nGATH2B2P4ehPuDPBy4C3WvYpV6N4rCOmoQdDOSA3SffQGI0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzX2arWEaRru5eYu3yUDspAW3HNE5HmAunpAwNbai+tmIeSzN7w
	gRO7x2Jjh/tfM6xqMPBCxwpjwi4PJORbTpggfRbxdkmESnSp6peLtBdEdg==
X-Gm-Gg: ASbGncuj0CqQ+1P1V4JeN8aL5JR8Jn67xqFQYwShJhINVwmq4lzRZbyFVLMsQmn1NcF
	HHDvK8stscIca9rnFLtmvuDTbXLVOK7D9VezHzpwuF0ACw47mRzm1Qkf0L2uV0CIPU2nmFIK2pR
	H1bv+2vvJUdwAQA3vRtTo2x0/UJL3eWvTMULJXL3JUFEpOlcr9rWR0SX37DcrVkoDreDP1m8aWg
	EkZIXw8ihL+LbMBXHtNedhEsoa3PSAk7scj6flL/lqGokoDYsgVl1JcGDd6Cz3r3NN/J7pjVAAj
	BNxLl00N0qSKIHz94JsgEQ8d0otSW7XlDJ5gunHrGPwrt9wwfRJKS8fBWQ==
X-Google-Smtp-Source: AGHT+IFlADYGu9ICOy4oPXjYef5zwTnWdLYJSejuZX6zIuMPuQyc+Ja2ETKwKDkCwW23gvk1OmNaRg==
X-Received: by 2002:a5d:47c7:0:b0:39a:ca0c:fc90 with SMTP id ffacd0b85a97d-39c120de403mr8997314f8f.14.1743496116177;
        Tue, 01 Apr 2025 01:28:36 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:d018:a09f:82bc:eb27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b6656afsm13320225f8f.40.2025.04.01.01.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 01:28:35 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>,  <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] netlink: specs: add conntrack dump and
 stats dump support
In-Reply-To: <20250210152159.41077-1-fw@strlen.de> (Florian Westphal's message
	of "Mon, 10 Feb 2025 16:21:52 +0100")
Date: Tue, 11 Feb 2025 11:11:13 +0000
Message-ID: <m2cyfoohwu.fsf@gmail.com>
References: <20250210152159.41077-1-fw@strlen.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Florian Westphal <fw@strlen.de> writes:

> This adds support to dump the connection tracking table
> ("conntrack -L") and the conntrack statistics, ("conntrack -S").
>
> Example conntrack dump:
> tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/conntrack.yaml --dump get

Hi Florian,

Updates all look good, with one minor new point below.

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>

> +operations:
> +  enum-model: directional
> +  list:
> +    -
> +      name: get
> +      doc: get / dump entries
> +      attribute-set: conntrack-attrs
> +      fixed-header: nfgenmsg
> +      do:
> +        request:
> +          value: 0x101
> +          attributes:
> +            - tuple-orig
> +            - tuple-reply
> +            - zone
> +        reply:
> +          value: 0x100
> +          attributes:

To avoid duplicating the attribute list in the dump reply, you can
reference this definition:

@@ -565,7 +565,7 @@ operations:
             - zone
         reply:
           value: 0x100
-          attributes:
+          attributes: &entries-attrs
             - tuple-orig
             - tuple-reply
             - status
@@ -598,28 +598,7 @@ operations:
             - zone
         reply:
           value: 0x100
-          attributes:
-            - tuple-orig
-            - tuple-reply
-            - status
-            - protoinfo
-            - help
-            - nat-src
-            - nat-dst
-            - timeout
-            - mark
-            - counter-orig
-            - counter-reply
-            - use
-            - id
-            - nat-dst
-            - tuple-master
-            - seq-adj-orig
-            - seq-adj-reply
-            - zone
-            - secctx
-            - labels
-            - synproxy
+          attributes: *entries-attrs
     -
       name: get-stats
       doc: dump pcpu conntrack stats
