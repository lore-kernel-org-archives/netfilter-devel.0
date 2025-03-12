Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32979443
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 00:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741739454; cv=none; b=k7LLtweLEKp1zjC4YoEwbNTvtQgGF5uxoQfMVs481TyQq/rP1hUfj260RroWk9aVZ+I59frQTsXyQebVdPHTF4C2ppSPLrfwppCpk9mSXFCim9Tp0AThKTeKP387oqGJGK9c8sVUMTpk+AgKAYA2kH8UsZYmPQ8czFToJr1mEJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741739454; c=relaxed/simple;
	bh=qIJsjOIvR2iyPSMo59dC6WkSLhJnBHUZQ85H00ABC3k=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l8cb+6An3AxIucypjBRQ/pXW6slRTtDEmAKZ6QwV29l+k345Znm04802y2zYzHqE+7V9VUd1rlDA6iPvc8Iz8BN77If92lGjDFgXQzf08qzfmJawSVEAUKUWvo1uFwQehSXAdXkDWMtnBH43ZEbtt51E4jj+wL5hCnY6JMRBmBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XrPOIChr; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrPOIChr"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c0a159ded2so650199985a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Mar 2025 17:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741739451; x=1742344251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R9dOnvo0Ueij2qvovi54VLR7sj2e+a02+eetIQYtB20=;
        b=XrPOIChrBXHP0CC6oaSchGe+fA0fkageWYGh1uEx9hnmPSw4SW3lVQlOoBrS13KfPz
         yKd6PmFCu3MqP7925OqSwkeWIqOWmhnWMgg2Z3XXkPUiMznWXTwpkwVSqpq+1etdBgPq
         RLRMRE+jQG8MAx6IlMjaaQXq582bQN+a/9bkzXQlbB1TuZ52PIpGkJzKUxt8rQyw0CJG
         ixw/LGvYQvqCRG1eAD4uEskFCLrMM7TUH3uSnBDP0GROoH4qKawyIY7cYUhUotzKJHcG
         hIyjuBEq4raDNzqxd7pmvu110w1UXnQdLlnOJaR3WepT24uuWjIvor+C5WVCF4fi21iY
         0raw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741739451; x=1742344251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9dOnvo0Ueij2qvovi54VLR7sj2e+a02+eetIQYtB20=;
        b=axUPHwlDdRJT2X3nFTBqvcrOMn8vXKMzVx0O1hvOYnq7/q9ijIk8OlEXlCzgGHyoJG
         SDj4g+1ZbCBIIRfjcISRCbhrg9o3kN27U2Dh4obBah3XKZlyRSdTbG3/cAUU5dk+i22p
         1hCgoIZxI6PZ36lHMlHJXTmvIHyaHtRsPrsYvihvaLaR9/QiHXy0zmp6iCiO6zift52b
         G0YIHduvAUzndRegrIxoIZUjT9s4PAs1U4n962wxIJy+RanpX1np35K5JV3jiSx+YGFz
         8P+9z4It1fY8n4Pp+EO8b64ugSwFM2S/xcMxlFpW2WOVDGpSLbVF3B8EzwEJFzwN0b9f
         vyjA==
X-Gm-Message-State: AOJu0YwbvPaOmwxCtYiJu4gHE6qlus20l+/O5M7IVG7bzgFkQM6szrXs
	y82bQoY/awbR0Jzs+j0ZjVpSdl7s+Enpi+ICv6l6UngVKR7TS+xhFy5xYw==
X-Gm-Gg: ASbGncv83nUagb6HmChlcR6Xxn8crD7VaSTTQgnzfEhZINsnlt97KDzlR/RM7X2yGUz
	gKWeqLw4azMuL6rr4DsHbk/GM9C36RelCDUe3QiT8P++lwGvbh66eraYjQm+BDTG1HQmVmMtbZX
	GmhudoyNHdWuiCPtKViKcf4HXAGu10IlAP8NdRoegYwGFFM8AJ+X9zLNjFurVVE6g4cksuawaaZ
	5v9jCpp0eyz+vd/UaT2mb0bLinYg4aeU3Bo83YyqJwzS6mLga79n59bk/aa2noxrOLnyyj87crW
	4OxElV7w+RUeBtpLVYDHn6uA4BgVHkGqVuLRBrM=
X-Google-Smtp-Source: AGHT+IHZRP/vT/4Jg3PsO7Zuav1O9OANzqMFxvEAoK9Zvdw0ltmK3BOg1gSeCZfo4dakpSC/gyVAig==
X-Received: by 2002:a05:620a:2b49:b0:7c5:3ca5:58fe with SMTP id af79cd13be357-7c53ca55a7fmr2057004185a.22.1741739451402;
        Tue, 11 Mar 2025 17:30:51 -0700 (PDT)
Received: from playground ([204.111.226.76])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5573f4b31sm346468885a.65.2025.03.11.17.30.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 17:30:51 -0700 (PDT)
Date: Tue, 11 Mar 2025 20:30:48 -0400
From: <imnozi@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: Re: netfilter expected behavior for established connections
Message-ID: <20250311203048.5c275524@playground>
In-Reply-To: <CABhP=tYOynShd82rwVuDMJDTE8LcM6+FHwx7Tfuk183EW+ipPA@mail.gmail.com>
References: <CABhP=tYOynShd82rwVuDMJDTE8LcM6+FHwx7Tfuk183EW+ipPA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Mar 2025 00:56:48 +0100
Antonio Ojea <antonio.ojea.garcia@gmail.com> wrote:

> Hi,
> 
> I'm puzzled trying to understand the following behavior, appreciate it
> if you can help me to understand better how this works.
> 
> The setup is like this:  Client --- Router --- Server
> 
> - Router DNATs to a Virtual IP and Port of the Server.
> - Client establishes a permanent connection to the Virtual IP.
> - Router adds a REJECT rule in the FORWARD hook for the Server IP
> 
> I expect the REJECT to match the established connection, but the
> client keeps reaching the Server using the existing connection.
> 
> The packets of the established connection do not show up on the traces
> using nftrace.
> 
> Is it possible to "DROP/REJECT" the established connection ?

If I understand correctly, if you want to terminate a TCP conn with iptables, you can:

  iptables -N disconn
  iptables -A disconn -p tcp -m state --state ESTABLISHED \
      -j REJECT --reject-with tcp-reset
  iptables -A disconn -j REJECT --reject-with icmp-admin-prohibited

If your other rules determine that a conn should be shut down, they should jump to chain 'disconn' which will immediately reset the the sender's end if it's a TCP conn and cause all other packets for that conn from that end to be rejected. Each end must send a TCP packet on that conn for it to be fully reset.

I've used this on my F/W for timed access. The 'instant' time moves into a prohibited span, all active connections for affected IPs are immediately shut down and blocked; not one more of their packets crosses the F/W. I also use it for blocklists.

I expect nftables has similar functionality.

Neal
