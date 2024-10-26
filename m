Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0CA1D1F76
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2024 11:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729941621; cv=none; b=oRD/NaGwuEY2hbeVgsvFGP8djtfWdGgPd1/qX4puljSwtIIpuVYynO92+L3zUIV42qEKSBboClylcP0iHTD/Sezs7tfDvLMMMcnLVgUeACC6tCJTyR5k6QTGe9BUBF/gMce1MB1MCRwQFnvu8h55I6p+9qMN3C2JloxWJkK2goI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729941621; c=relaxed/simple;
	bh=0eQcU2Fj8C4xm5beX3Ahgfqc7gdcUiyyYHlUECCiZbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UBi8WDca9YA6OLlzYU+vjnaR7uWSPgLwFPGQ/ysihAXvIcDfSoRy1NIZy3UoQCUP9AL5A7+nwiLQnY3YjeQTUaoOnXAR922s1xdi41BzKe6wSDFbVrBlQ4LzOYAfAxbNve8xLjBvHQ6jlTiTnBXsp6bFEd1PtZtRrzIGgMd9U3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CRS9F7Ar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CRS9F7Ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51BFC4CEC6;
	Sat, 26 Oct 2024 11:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729941620;
	bh=0eQcU2Fj8C4xm5beX3Ahgfqc7gdcUiyyYHlUECCiZbE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CRS9F7ArwRy6rbCRZAD/L71ZHlVBjOYvrZ6VNoC2DSHKtu0JbxD/nP6bU2VVXIdPo
	 gdd5Zod6F6oaezyCUIxLVrdKhGjW6C+yWhhcru0m7GdcrMSxG17Kn2qNJ/zqL8kryV
	 VtcsH9z15/QKOv1Mhb9ZxKbCQBZfEcqqWe9/LvEotCxkbtI3cEkCTeyTgm9b7TN980
	 qBA1p1gefdp89NzZoGTYry8RFpZFdrL/CKTXX5q3FO/91Sl9dZVKpc8hdG0eggXrlM
	 PnfKC5CdxvToGtr9m9PKErECY045MFSe7X2Ix9m9cWxAfO9heRlRl4/v0yQ+z0AuKw
	 bGlNt347L2/CQ==
Message-ID: <e0cfc559-c9e3-46c6-9fa4-881f7ea1d022@kernel.org>
Date: Sat, 26 Oct 2024 13:20:17 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH nf-next 1/7] netfilter: nf_tables: avoid false-positive
 lockdep splat on rule deletion
Content-Language: en-GB
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <20241025133230.22491-1-fw@strlen.de>
 <20241025133230.22491-2-fw@strlen.de>
 <3f40f462-2b54-4eeb-9fbb-1f76ab43f440@kernel.org>
 <20241026093548.GA28662@breakpoint.cc>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20241026093548.GA28662@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Florian,

On 26/10/2024 11:35, Florian Westphal wrote:
> Matthieu Baerts <matttbe@kernel.org> wrote:
>>> This is enough to resolve rule delete, but there are several other
>>> missing annotations, added in followup-patches.
>>
>> Thank you for the patch! (and sorry for having somehow pushed you to
>> open the pandora box for the other cases :) )
> 
> Right, I still saw more splats when running nftables tests, but those
> were in other places of network stack (outside netfilter land).
> 
> I will have a look next week.

Just in case, I had one splat when stopping my VM:

https://lore.kernel.org/f856d105-5463-4b8b-8715-0e6871165616@kernel.org

There is a fix for it that is coming:

https://lore.kernel.org/20240913162340.2142976-1-kan.liang@linux.intel.com


Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

