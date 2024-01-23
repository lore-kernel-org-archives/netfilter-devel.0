Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8742550A69
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706026504; cv=none; b=eoaolOXAm05se9wo4CmJh25wGOUfl9+g6ZiiSXTH/zjMtRdaAeu3SaTMbOKlp3k5h+AIt1WSjEezhv/PiUd0JAW+ZINBsuWiBnZ9vfE0YPqc+tnuPsjDSTOqVJFxuG6J+05lUPM+EXh46jGx/jwZfTUnvByNet+drgoxb9np6z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706026504; c=relaxed/simple;
	bh=MePAUhQemx9jnGFNpqzT4wg+Dr8s0RR8D6sWCDL9R5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=K/8os/OKL/R79brp6TveWDk52flwrBZGVR6sOFs3kL2NEmm8tGP6wwxjlupUvbYRK27rJ4P6imTS4wj36w33RY7aJc6IFRXaNcaWJ4NjvYje0/XG1umtOy/fHjCFnegQ8J5d9wbveKi+I+eBID0BTy3Zx/Y7u5kZaq/7LnToO9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ck5aF1CQ; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ck5aF1CQ"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5cdbc4334edso2132082a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 08:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706026502; x=1706631302; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gQb0kZtUtIqoIrb0wOSav28HxinErwSwhgUXI1lcc68=;
        b=Ck5aF1CQvohE8xi3eGGilAiv0aAKjdbvg1tqxKbGGOlPi6+be0QHusNIu6UF4PqZ76
         VVMBa5H4wCezAoyGWQxI3L2ic1ppFUNLZVXgdy37vtP68PWu1FZh9tAJrYITQ9/3r7/z
         tOHLjRG3CTd8RXNf5BZ+j5oh5ezBKlJqkFEHr/LKT2VJnr+FilgU1SHtvYPHexrYQF4S
         GaEXpQHzDCYuteD55jCff5rQXZZoKDerq5z/ZHbzxD6HBb1zrCg0j49ARGm+fNIs5q2L
         qN62D9zcCG4CLIk6bDeLlGh0/q5o+uoy4+63x3Wnvqoduie3EX4PYOyI+MJ6O/o+gvi8
         T7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706026502; x=1706631302;
        h=to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gQb0kZtUtIqoIrb0wOSav28HxinErwSwhgUXI1lcc68=;
        b=YTtF9ZZlvd57icOAvzAQK0Wa85iXWy0H5NHY5kolKHNZDE+jDOtaaTr3LC+3iuw/rn
         Fe3/8HgpHXdspp+zTeS5t78W3c06/RWPwR3hAXp7XCMG46y0BKsP2G+qAIVA/SNGdeyH
         aOA0Nu3egdXRA5txHl54lQ6uOx2t+rtZLZoghxg6gV7oFPa7NnIsaXoqKziBQVIdWUiv
         EwL7r8c9qjkDSr8vp58ikh+VK0tylnmH5BrS7FJm2s57j/u14ocwM3ma2W859mZ56SrX
         8R/l4NiUMBPKmsw4dhlfWbPZsNaCYEJfPiPyLldErP0OL0j8jouoWO8HOOHSOhTTa+Zf
         ze6w==
X-Gm-Message-State: AOJu0YyqHV3v7eYg0FlbIaed5HkAFoVwiBxSjvrN6pmQ3V2KQvslhhp2
	JYMsw70F8tbFSIYFDK72lYjuoJ5AqAdOLZ824o8qiQaYJ4aWgmMaaIoPgawwmf3LCM9zzPz3Tfg
	7bXB+IcvaUNbg8Xd1QSeMiPBhfFs=
X-Google-Smtp-Source: AGHT+IG5uHC4mr3YenCUFdO4G0uenF2i1JrLJhs3mGb/pEoh/oymFIcjda48h48BDVIhBThf35KEYMbkevzEvB8LNeY=
X-Received: by 2002:a17:90a:5107:b0:290:61:b83f with SMTP id
 t7-20020a17090a510700b002900061b83fmr2529836pjh.12.1706026501859; Tue, 23 Jan
 2024 08:15:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240123101428.19535-1-jacek.tomasiak@gmail.com> <Za-yLDmJofXFCuPu@orbyte.nwl.cc>
In-Reply-To: <Za-yLDmJofXFCuPu@orbyte.nwl.cc>
Reply-To: Jacek Tomasiak <jacek.tomasiak@gmail.com>
From: Jacek Tomasiak <jacek.tomasiak@gmail.com>
Date: Tue, 23 Jan 2024 17:14:50 +0100
Message-ID: <CADd2idYTR0bhpm2rPc_BYoXyO2fxyxKa=pzSVf_vN1eSe1GsPQ@mail.gmail.com>
Subject: Re: [iptables PATCH] iptables: Add missing error codes
To: Phil Sutter <phil@nwl.cc>, Jacek Tomasiak <jacek.tomasiak@gmail.com>, 
	netfilter-devel@vger.kernel.org, Jacek Tomasiak <jtomasiak@arista.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

> (...) I failed to find a working reproducer. Do you
> have one at hand? Would be good to add a test and maybe add a Fixes: tag
> unless this is a day-1 bug.

Unfortunately I see this behavior only inside our products. I couldn't reproduce
it in any other environment. I suspect that this is related to some
kernel configuration
or modules which are present there but I didn't investigate it further.

Regards,
Jacek

-- 
| PZDR Jacek aka SkaZi                                       \\
| mail: jacek.tomasiak@gmail.com "Oset nie ma zadnego       /O `----.
| XMPP/Jabber: skazi@tomasiak.pl  pozytku z tego, ze     * (_.-.     )\
|                                 sie na nim siedzi..." *|* rs //--// X
