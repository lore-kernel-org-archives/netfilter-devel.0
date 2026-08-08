Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EF02EC08C
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Aug 2026 01:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786152483; cv=none; b=CiyuxdM+QoEF/38tWOk6XR4ZlIB3DI4EK9b7HzQj9BEaij4Chfl9yuN7SNvtG2hr3OtQSm7DrENMNMVlXu5E9DgbzqWfDADZ61qPj6nbbLEA5typsKvrA3T44xl11+xZgTMTEuWszcfAXIeIv88wxG7Vj8UEJirD+Mb9MyiRhPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786152483; c=relaxed/simple;
	bh=k8NwaErlgyL51VIgD/ZRix5w5koqB6rmXYLekoNkka4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUEKfTCthD8xk8XYV56JnD1cCbm05NuyvNDmA6IVXkgKNwJOYAn9mY/1NxRTzlcnEpE9OS3xj11d1+V6MJ9d8N+aB5Vt3EuFlhp6YFR0Ehz5BXlDAVUiiL2/vbQJmO2eCduJ7S3cxz5XBfFgF2esL/GkMty0OEJMRqfNgOId4LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KiUPhg6r; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KiUPhg6r"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2caea3f742bso3065045ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Aug 2026 18:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786152481; x=1786757281; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OluoS02aPHbfmE2V+QcNRc4NZfWou3oHP4B6+FynkLE=;
        b=KiUPhg6rdsRyK34v0+gyS93Gr4Xxl5NMf+s5WJ9ySPzTftG7A3P5NO+zOcb9zF/xFk
         5jgh+IBsJQYpCLXhY/Me3tBUPw1bvaGpDR9JVHIGTd54X88Grmlpr4SlmWRH0X5LgCVe
         sSFXiPedgdSr1jSJi/JCRIP5Pisvp/op+o8E0I00DZkZNrxlDVPZA0RykbBjl5ZQjEsp
         rRUxB1CZNS8rflTlGCBRdg4KgZkXtdO+/En20bA1ap1S6ls0CZ5n1oDCBBYTDDIbOQMb
         7a7ow0WAut36XsLxLBB51eNM1CtPLG1x0bn50i/MamufceV6syu+G0Sn3JU74wcNksQp
         ofdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786152481; x=1786757281;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OluoS02aPHbfmE2V+QcNRc4NZfWou3oHP4B6+FynkLE=;
        b=dV9bcU3jtYM++nbQd0IimAfNkQ9Z/zjVxgW86EIw4st2M+zPTndbBUGQKolQGUcA+h
         iqBV8l+69FCdNrvTQUQ4HsuT7KK+8pca6ZWNf94pB9vvpEs9/qyvjEbM3abw+dAvW2+c
         WMGZBEC/4ZHBlA/5t8tgJLJa0jS43RCM+BEottW1q/Rp9qQLnRk1tlBwkjXFH2EilVMq
         6fKeFxXL3y2m03YgsMCgkUlMG7EVLGWe4IN8RgZWjZ6MIy/EoKaETf8rzNDm99TLQ1Ma
         C5D+SZb5xuo6AWvITLujnnVbHkqoHcarYqWPw7uB7UGXS0SPLq92UZrdkoZTcaEyUV1z
         pG5A==
X-Gm-Message-State: AOJu0Yziwjl5DSbhzTzQkXtMPsVZx0ck4KZ+TCWaPyI0Vq7+UAzkyf+t
	cWgi36QHRFJ0PYMVPscJPH5h0pscn9KUa5c5X2thSFCfPbHqV11THCf7T8H6g6MT
X-Gm-Gg: AR+sD11v0C+dbyjIhZ8xN38LGbhW5AuP9jIaP/l3617/tUWthEPGfZuJxIM0kXKj6Uv
	CcIXZLry+EHmVD8ASksZeCl2Ww16fqksaYIX8A2lo0fkAPnQ83WKVMUncd2w4baJdQ4sqlLu17Z
	C4ki3uhP1Of8CbD0kEXx+nuUcoFuGQZjBJvp88jrPr2d1bzLdyBhVw8e3JDKt72+rCWDGAvWOCj
	OnIXmn0Urw0fKXfQs6sDqpMiE0AATeO9sJV4CJiGP23164jyB6leHD27XqPf8qCGERG3HFhAw8r
	5sFvlWVYaDj5OW1dMdl2Nt0dUyGtUQ6J/sGF694Fv9aF/LEsA3SH5IwXTFPCiig0HVDEXyPV8sj
	ZIqE5vbVmiXcoHpIZps8Rf+mhMJpqi2JMgQUTjxbNZrHyJhDrfvXUV15YIlsC6CgZWIT9O+A9uR
	0JAJzxDwBQ8zJat56qQsH6mf9YUifeSu6msaFcfZTX9KwvkEWXsHhKUkxnuW+Q8cbVxJMsDu8TR
	rJzSuSZdkuiP1xUgSumQeWb0HQtqVzME/E=
X-Received: by 2002:a05:6a20:cc0e:b0:3bf:ba48:ca88 with SMTP id adf61e73a8af0-3cb85e6b038mr34613488637.15.1786152481371;
        Fri, 07 Aug 2026 18:28:01 -0700 (PDT)
Received: from r912.tailbb6e1e.ts.net ([160.30.85.32])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14101b7ad29sm11096107c88.13.2026.08.07.18.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 18:28:00 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] datatype: accept a numeric cgroupsv2 id on input
Date: Sat,  8 Aug 2026 06:57:56 +0530
Message-ID: <20260808012756.2757796-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <amnGEhXHD5175bxC@orbyte.nwl.cc>
References: <20260727082427.740789-1-avinash.duduskar@gmail.com> <amjWjTkt1Dsh66Xv@orbyte.nwl.cc> <amkAJuVZmpGy7pvY@chamomile> <20260728201909.1773000-1-avinash.duduskar@gmail.com> <amnGEhXHD5175bxC@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 11:21:22AM +0200, Phil Sutter wrote:
> So maybe only do it if you don't break a leg over it: Use jq or awk to
> eliminate the metainfo object and write a simple test which asserts its
> presence in output.

Two shapes work and the second is much smaller, so I'd rather you pick
before I post.

1. Filter in json-pretty.sh and regenerate the dumps. 433 files, 260K.

2. Same filter, plus run the stored dump through json_pretty in
   test-wrapper.sh before the diff. 2 files, 8 lines, no regeneration.
   The 430 dumps keep a metainfo object nothing reads until they are next
   regenerated.

Both survive a json_schema_version bump. I checked by setting a stored
dump to schema 2: passes either way, fails without the change. Suite is
green as root on both, and either way there is a new
tests/shell/testcases/json/metainfo asserting nft still emits it.

Which do you prefer?

Thanks,
Avinash
