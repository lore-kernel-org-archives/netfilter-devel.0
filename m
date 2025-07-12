Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79AD1E231F
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Jul 2025 02:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752288226; cv=none; b=BBYNhFmJ+Q+TEMFAmXrt8LWCvhvXrXsh3DhZ52VSFB1cZWlz2pJMM2DXvd1wqaVyVnUShXkM2OUJeWxzyxiX9p91z/GR61NBxnU/AcsCS9wn+yisbV4ehG8RGfoGRdo4plnZ9MrOommPoJclSEZBWbs+bxO0Du+SZOUhCyOMt2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752288226; c=relaxed/simple;
	bh=oP4tRB1jYDbNoYgtFXAx0ycDlGjJZlKovYqVWSsnAqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tl+B7YVaZg/tXBbN2WKoc43i7drtBs0aR3cxi++RQKtioEyWnndOT07g4s1a+w2Xxr8nllNqWb1SURElk4UrW3HkfqESZEwF5gVM9OLmqAw0ko8lA/Kkpr1rsNck9aZU3+Oo7/3A58ewatXYHpjtDJ1ajyWS8IOwut6GXVcFaME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H7FQdbLb; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H7FQdbLb"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6fadb9a0325so23827986d6.2
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2025 19:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752288224; x=1752893024; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5E+NhQ02ihJ44y+QxitNhkNbAC8svUB/aItl0OmOtdE=;
        b=H7FQdbLbo3vtY84EMnqgIF6UPYMZ3XpM8iSgOtLQHAOTi33v0LqCjFgKPInOt3cv2S
         uvHfm0CiU4Ey31gyCldhF3ClYgOwR9F8EXlJUqCMzIqwn7DTUl66FYqA8BDfravgLuIu
         oEqRuvtjL78LPtUKbME1cGFGmxwMf0ewHiWQyLhKKxXI6+c+0FCQOuIudh+punwAL0KE
         UirdEdTQopfXc/IzERlev1JxMThKDy3hpVQc7FvMPJibUBhfy87BdaNfNLCEMwnTZrWT
         fqSlKYTy7GfHo64By78YS8BgDypKUai6ediKM9HZH+EurV2nISDbFiOqZ9fmuz/e2uu7
         j9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752288224; x=1752893024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5E+NhQ02ihJ44y+QxitNhkNbAC8svUB/aItl0OmOtdE=;
        b=sOR8w/0e2xMr5TUlrHkFROVSLEoTlHVfTea8/Ov0eP5kaE8WIy37zS7Hf8agnRiabY
         zitAThBDqDzHmjqk6cePXTLCTZleim86xrRYr2sJaZY/HZT6Lt/IdD4YLAIcyvh3R1io
         JYOigNMGaSQkzT25mekMxiJdIeMyNPdmmogF2cYVhLfEZzKTozw3joAyijd8OcEWhsNH
         9HB8cIhuyyQMSZfR48SCCTWfqasGnjYqfXTCLi4zMb9VlawigzjXy0Xm/OY9paTDYX/X
         D1K0Bxwo2WbcvnVg7Lwu27z4iXFMkA3q0NsAkShtOBGFVW1kY6d/Aa9WojHMEJi37O6d
         rhBg==
X-Gm-Message-State: AOJu0YyTnxq7rGcMX1bOgou7NdM7F+TT36Bd7OPwpm+vUoOKAV8K3mnW
	M3HveLw5kdGbp1es8BiEnwuiT/4yWQ333JoESVkXj9Y6+JZHZ95JJv46QRM2qw==
X-Gm-Gg: ASbGncujZ9tvFd0YYPzkC4L6RTeytUZIcJD2gSK+skDlbBJZRL/33dSruwX02RBN8xe
	Z7ptsHo9T3scvjewVoehVP3cz9TbBGso+iSH9pgJKb+n9j9niBr3nWs/hmEsHvtL9LKxWS3GTH3
	n3k4HY6z9jNY7MKNih//4V4H44QA6hieYgeebPJMKSE+J6YuyxQpjL8yZcYs4xR/wxd8fA/HeMM
	tSbrN7aiXbwdFo8QfWmPDC1r+QlBFSMKQWQ5q4M9BVHqebuhP/nEyYC87G4wlDAH8XcNcl3AWag
	uxhiYq4lT0FT18OcdeMSRY4VKvLxX9/5cMGXjIFTgvyI2L9ucDirrwKl/WxXGUuzU3v/FBN1iHl
	vFvfUiOcCnee8zE7rF07oiRqolkv+MdmJmjFS/ETGzb2JQh3AsmAMYm1keG7trXD7EQ==
X-Google-Smtp-Source: AGHT+IFVmQK9E5+2DCBUjn97btnpbgRud95y17Dv2v3+pk/RuabffKqIdqg+upJb8o4UHEkuewdS8Q==
X-Received: by 2002:a05:6214:cc2:b0:704:7dfc:f56e with SMTP id 6a1803df08f44-704a3613b4dmr98592106d6.18.1752288223540;
        Fri, 11 Jul 2025 19:43:43 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70498090248sm25323896d6.90.2025.07.11.19.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 19:43:43 -0700 (PDT)
Date: Fri, 11 Jul 2025 22:43:41 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Feedback on variable sized set elements
Message-ID: <aHHL3ZYi65GHx0CI@fedora>
References: <aHCFaArfREnXjy5Y@fedora>
 <aHDnIS1iaBKtxove@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHDnIS1iaBKtxove@strlen.de>

On Fri, Jul 11, 2025 at 12:27:45PM +0200, Florian Westphal wrote:
> 
> Why?  This is hard, the kernel has no notion of data types.
> 

I speculated I could contain things up in userland, but as you
stated, the kernel got involved (would need to be aware of the change).

If the ask is more philosophical, it would have been for educational
purposes.

> 
> The kernel doesn't know what an ipv4 or ipv6 address is.
> It only knows the total key size.

This became clear, and clear that I wasn't missing anything. Further,
it indicated my thinking was swimming upstream from a design goal of
netfilter, so to hear you conclude with ...
> 
> ...I don't think its worth the pain.  Also because then ipv4 becomes
> indistinguishable from on-wire mapped addresses.
> 

... is mostly what I needed.


Thank you for taking the time to answer my open ended inquiries,
especially when no real code was presented.

I'll find something new to chew on shortly!


Thanks!


SB
