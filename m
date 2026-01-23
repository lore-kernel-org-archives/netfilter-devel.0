Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CE9286A7
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769176961; cv=pass; b=udHCBRPx1cEvbWUTOF/ICFdJbduwEcVOS1a2nw2cFN6WyRsoJ6/6j7pwtl4nPJch1x0M7nhSNfJy25Mq741QWZnu3Xecjtv3rSOersm0oyLVMXTYIIEuN3v3eV9cGGUCmcA5bsoQvhCKzr6s7TFAdK3Dn96bP3uxRKG5HnhDDvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769176961; c=relaxed/simple;
	bh=GblzGEJlXneZnUSk7lU3G2l8vMGivOnBXXpjz/aTnqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EE6rDQjeq7kEakiHpBLDujPBNVWfer6dqrZU9mcqQp+hAwDs0lIeFcxUNASx9KgJLixE/W/sTLfkeZIi8b/T+ZV9E9bu8P+gHerHopd3DAYNSg90WYvhtorI8p0zhnJqFqOkiET0CSBsnneEufFz6rme6pMLglwAqlNxEiycsAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nz4usDzl; arc=pass smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nz4usDzl"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-5f539e05d63so678697137.0
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 06:02:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769176959; cv=none;
        d=google.com; s=arc-20240605;
        b=Ruc1OMGG4U5Vindp8FRG9yPbvTP33mAYDnUu6I9vD9ubdBsxRqKulX0Hk3SV5euPsF
         B1w0ilibH15+At6NigGcPC+ImBHTkMng0uWkc+QyJkQ8UISnzT4LrZCH7/M3/N++3Qg/
         6CrHruVQUB1m3WcVWd2O1NvnP33dG7tDtKZ0oFhBOute8lRDxBJ6TItncAj2hb0CgizF
         rlLmlfU1IQTyWBt9eiT5OWlIP51hfc2HplVvZLd4zE7QAOcRep1y2YYXjDChqgUrqcte
         lqEWM8r2TIIHGhkDhfOmMCTagoFBK6wE4TPqiPTGxtDkgn4fS1AqHvCwxP7UVrcovEaD
         cwmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GblzGEJlXneZnUSk7lU3G2l8vMGivOnBXXpjz/aTnqM=;
        fh=6o508ip0gR7vYwWwuRhyOT4DWPIt45TeavJkzNdl6Hk=;
        b=kITDhlikVDj/QATKc1kBAZ7xLQ83Za2eZ21wiaRnbZWv8Gul/LdbCLLKdx8O/5lxfY
         M/m1dtioTH7TIPXY1Ui/66uzHSvS9f83lPoTa6T2OvMdw+H8WtWLcO6YYlSmvQx9voXc
         QERnJdMlTfJ0gnnFfn53R5+yRWODvLzPb19DdlSOlg3+vAKCCvmWz8peOzw6s+/TUFXf
         0qGsItnKbxpsXXHYcB4RrlSWdz2fCsqbAnt5nXlbz5vKpelfx8ck9upAp4HmLgjk7Zcq
         pRAF09ZO9S7MB3PaSPegwDIE/coYxNi3rgFBV0jabEzODIRHFVjgKxB8+3OQUgVJCkfl
         TE3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769176959; x=1769781759; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GblzGEJlXneZnUSk7lU3G2l8vMGivOnBXXpjz/aTnqM=;
        b=Nz4usDzlAMqQwwnexevGnBQysWvw/aXDRieFmB92iKay8GjHTNLFQ+pxBw8PSbUNg2
         j88viS4A8D+9RmPRXZwKT/PDbHDQOfk4yTbIkvJSmWkHC+Z0HJSaWzpR4MxN3IYAtZLm
         cWoKl6RJepV9PoqMHpUMqQYo86PIVll6DE/74EJawvLn5hwN5nGvsPNXQYACs8DTxIKU
         DirrNYVQy+BFBtPXV3YyM3iQeSTLZ30TR9653CY+Tsx+8THvpEwDzlcK3mO8s+43Musq
         wJMJODgDkz/MUevkdzKfIo7KIyb2QatB9kXLwiHVG1DGEfjyfNngvMum+Fi7kwLXk/Wq
         JF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769176959; x=1769781759;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GblzGEJlXneZnUSk7lU3G2l8vMGivOnBXXpjz/aTnqM=;
        b=sfVQUWRjp2znWV1xauxAgw4Eq74YXUdjpAMYA6ecpqTbM3dupACm2PZOAtguntUPD4
         d62EUXhrBAsgE0o6Rm9iHRrzw8ELb2OO6JGZcJeJLNa4gDWjcyKsUEnyq88pdcIfYn82
         uvAo8cz3Hqzs9WAkcEXdBB0l8ZIQVjt6ruUxFOcPD4jZZnh10TMh1DLZcSd0UBQAMB8Z
         5qyaDeRvFlGJjL+F2UHOtq8QIF4r0nRQZn3bP5s42jNmyo7qARCs6ryPtq8Vth2Ly+LK
         7qY+5QTHCGg9c6GG+zdT9FmQsZcbZlcJQeQowx8vWjrFD/W41yBsLcinVtL8vr+9DAsw
         e8Wg==
X-Gm-Message-State: AOJu0YwFnHlpBDQFDtbhWRi/zFUT5b73q2t2c9PYJIBMyTxVFf0LTtvT
	hB/mLaDNmIXqXwJf6H/74SFyKTO4tF0Sj3+ebDxeSRKZQkuZoRHu0gN/p8mXIy/1R27V5OvvnKx
	NvGp52XDfieZ0YF0xazmnCZG+FCdyRIk=
X-Gm-Gg: AZuq6aLuVfaQ/rnnjtnRl/cnubzKcTS/UHHjrYYcINYB5adWrg7o0K9T/9tgRqcfdrF
	foF1CXNoI5er81ey+7wwI0BAztPTbqxNR1rHvvJT3wP7/6pop6+vwSj3ldygqjMbWzPBLRJku7s
	P5XRGLqClxg1OEsF6aoxgEDHSc+zdCw2zs6Xs9Eou4rhGopreM90lmIea2ywDGy7OJ36PQas9Ea
	/SYY4ZBh9aH8muDjhqQ51vZvtVwt1zHBVrJ1ZjS7/oc11Z5PJGPoaVY4P85uZJPQirACeA=
X-Received: by 2002:a05:6102:3f11:b0:5df:b3ed:2c8b with SMTP id
 ada2fe7eead31-5f54bd0272cmr860052137.38.1769176958686; Fri, 23 Jan 2026
 06:02:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
 <20260117173231.88610-2-scott.k.mitch1@gmail.com> <aWwRCM4YZZ3gUP85@strlen.de>
 <CAFn2buCeCb1ZiS0fK9=1RZS3WOSLcdwV1c06JEFbgXTQCTVW1A@mail.gmail.com> <aW19UIm96f43DyB-@strlen.de>
In-Reply-To: <aW19UIm96f43DyB-@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Fri, 23 Jan 2026 06:02:27 -0800
X-Gm-Features: AZwV_Qh5xVkLG_U7jJHdWSOPWDp7u69HzVgdoRqJBBmfletfB29HE9PdlPuzMjQ
Message-ID: <CAFn2buBGw7DTRbQe=XaGZkpjzrC7bXjXH3akgbCcBTWoEC-jRg@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] netfilter: nfnetlink_queue: nfqnl_instance
 GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

> I don't see any problem with this patch. nfqnl_rcv_nl_event()
> cannot run at same time for this socket; it would already be a
> problem for the existing code, parallel event+queue unbind
> would result in double-free.
>
> So the comment makes sense to me.

With v7 global rhashtable this commit is no longer necessary in the
series. I was going to break it out into an independent patch but I
see it's already merged, yay thx!
