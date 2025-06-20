Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C5A2BD5AD
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2025 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750431423; cv=none; b=KbYQ277hTjZXhPuL2DOFob0ZMevhTivq2fmSmc9T6y6hNOp6dD/k2fFumzgNHAQTPJDRyIaJpMZ2rUUXYYHCGhuSN0lG9q7ywW6tVgcNk5X0MwEbVYM20ubwxwwtZA5ZpoFIxNa+m4sVuj2CkVZxQTL73gwBxv7RKlmZGx4EEGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750431423; c=relaxed/simple;
	bh=UseziiCFNy+6P/49OnpQlZKqenk+TswbIb3kp9EixEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dEqg7qXOycd/INM7cymHepjxe9AyyHoniRXmGDkbFV7nJ1n7Goad4iVTpSYS1OwOiO2t3NGcYC2V4neeCkgD7zvtcJcph52EDYyUSl7vwd4ICePqbmCYU0wAV6OkKFBD2YvJoKabUTbDDIYxwNbWqux1zs8kzLatZTDE6vvt/Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=O8IT+yNh; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="O8IT+yNh"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-453486940fdso692145e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2025 07:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1750431418; x=1751036218; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hfXj34P2pf/AINloebXhcz0Fw0+WqnZX50sWt1njJSc=;
        b=O8IT+yNh3SOE6XWHhSK7wBx3TYzVa4tQcCf9r5wINQjow85c1VnvUkIwIltjSifFMW
         4D31n2DQZrSQ5xCgioiPro2IsQK5K+uYSukoaFj8bo5R+dSOdLJSSaaiUMVcXjz/enjP
         KbGX6G0+zKti3jkPH1EJk2EZpxS0NQecw69VWK0ery8WjkzWHESzSseeiX0jakerytwn
         OofJ/sPy0cp4EhWsTRiCW0YlMKoSKnc0TqlG4fwVQevjBxKnVEUVvtABq0tdeTU2qKU/
         vNyxj1TZX1y3o9fRAJVx5s2yeXywj0+/JPQqnnsJX1q7gCVtG1mPLDMw1q+Lj6/EmZzC
         rL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750431418; x=1751036218;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hfXj34P2pf/AINloebXhcz0Fw0+WqnZX50sWt1njJSc=;
        b=kXG/fT72NUUCmpbWEF6I1yg7cpgHh8IvNdQmQJ06oYPiVh87nS9jnQ5s9Nxy45XlX1
         1+8gTM16M5ch+1MkE1VJgnUwliwuR40POLia2TyHYzLsv0TZn3rntsSChwXo7U7YarWw
         z/L0B92KdUj8zQoRuOfE7wF6gHN74lCEbOU46UAVcDinEiUGhLVtpjnLsT34MY0HzKT/
         JSHLMHan2SBPlFhBnzFxodWcyCMzgILt5reAVOBMxkZeNT+tkJHtMzZLL/IGw/2Qqdrl
         fIwEiVwN1hHCGDWIO+aIL/AAZGZE+x5u67rXHlWVb6Jg6ioepYOyz+r3Q6wtfyVsl8Xh
         Z9VA==
X-Gm-Message-State: AOJu0YypVc0GOygkGxO3QeAoZS3ng8FJ8mDeK2AsZAdPs419eJGDBIpc
	BjsVtBbZN1kpk5sUywAMluyg8RXU9nQljEjWlxpBRvRn7xs8O4ILsb0V7uWG1ROWzB4=
X-Gm-Gg: ASbGncvzLgsO+12JWNlhxc19gqXqt/ojXASurMrqEmpKCSxr06j5KhH8GP0seEx9jwO
	tVEk9V/dc2T7yClvX7X1TNl4fuLdPjZpzMGKZasH+XujbGuhxhjeR4kCBLv/BGFwCkRUAEih+Mp
	65xe+mMi8ag2tbJWJJInAujzXcUoOY5fGl3k35mr9BzSW8IEYFhh+cT4jEb2MFvYQwVnx1lhheC
	ATP49sBwwVPebmb+2KbqtEnpfEouQShblkbHsmP+WSXGUm4W6IIQjdBmfvT3S9QgSfcfWdRNWhS
	HzleGfWOcCObFuKbFyyjRh9a/uQJI1UOkK5rHERnxYw1xvIo1LRJQxnP0rCy2tqzXWQGbWv7Mhk
	LV3Nlo6/sGk+0lvXfE7zgq7NZLMMICrVTCNPT
X-Google-Smtp-Source: AGHT+IGRhTkUi7vAG1Nq5lQnyde1wdkbLDOGPyXB6FB4LNEfzmGXi2FxRcSC8seRuwQdvmccY9uIBQ==
X-Received: by 2002:a05:600c:c093:b0:43b:c825:6cde with SMTP id 5b1f17b1804b1-453654cdbe0mr8598985e9.3.1750431418440;
        Fri, 20 Jun 2025 07:56:58 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:607e:36cd:ae85:b10? ([2a01:e0a:b41:c160:607e:36cd:ae85:b10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4536470371csm27694975e9.30.2025.06.20.07.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jun 2025 07:56:57 -0700 (PDT)
Message-ID: <2211ec87-b794-4d74-9d3d-0c54f166efde@6wind.com>
Date: Fri, 20 Jun 2025 16:56:56 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: When routed to VRF, NF _output_ hook is run unexpectedly
To: Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 David Ahern <dsahern@kernel.org>, Florian Westphal <fw@strlen.de>,
 Pablo Neira Ayuso <pablo@netfilter.org>
References: <f55f7161-7ddc-46d1-844e-0f6e92b06dda@average.org>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Language: en-US
Organization: 6WIND
In-Reply-To: <f55f7161-7ddc-46d1-844e-0f6e92b06dda@average.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 20/06/2025 à 15:38, Eugene Crosser a écrit :
> Hello!
Hello,

> 
> It is possible, and very useful, to implement "two-stage routing" by
> installing a route that points to a VRF device:
> 
>     ip link add vrfNNN type vrf table NNN
>     ...
>     ip route add xxxxx/yy dev vrfNNN
> 
> however this causes surprising behaviour with relation to netfilter
> hooks. Namely, packets taking such path traverse _output_ nftables
> chain, with conntracking information reset. So, for example, even
> when "notrack" has been set in the prerouting chain, conntrack entries
> will still be created. Script attached below demonstrates this behaviour.
You can have a look to this commit to better understand this:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8c9c296adfae9

Regards,
Nicolas
