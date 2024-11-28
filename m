Received: from esgaroth.petrovitsch.at (esgaroth.petrovitsch.at [78.47.184.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B0114D6ED;
	Thu, 28 Nov 2024 23:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.47.184.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732835146; cv=none; b=R0DPSAjQbn+FY0Wj75Xqy+Dm9ioRYBxHYoJIj+N4zCAVuETOSxmNUgkpiBHh4jjpqOQS6SGxCx6oqTiGkE7pNTBju1cLrzCf80WGrmrmfEzclwkzy4gf14aXHPO182dubjov5FOYDsuEQ8DplKs+IsMXD1JtC6vEsxlVwy9ri40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732835146; c=relaxed/simple;
	bh=KV1kTdPXXjLjR3CJMO+XBokWZbSlYJ+qrQpoPDLuBDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kmj54WwAZ3NiA1Lw84mD2FqKXjcJxZC+xzZ/yrZJt0goGQ8G4EZ3/bpCl21NAGLrISk2IfdD21JJThwPaTs10/ZK+isBA3JivupcJqud0kPxPjnNqisJAorrxXzUp2t2hFJ17CCiEW2Dk/J2Yi4b84n5yLROesAMSHlceKRyAwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=petrovitsch.priv.at; spf=pass smtp.mailfrom=petrovitsch.priv.at; dkim=pass (1024-bit key) header.d=petrovitsch.priv.at header.i=@petrovitsch.priv.at header.b=wTBYtbxu; arc=none smtp.client-ip=78.47.184.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=petrovitsch.priv.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=petrovitsch.priv.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=petrovitsch.priv.at header.i=@petrovitsch.priv.at header.b="wTBYtbxu"
Received: from [172.16.0.14] (84-115-223-47.cable.dynamic.surfer.at [84.115.223.47])
	(authenticated bits=0)
	by esgaroth.petrovitsch.at (8.18.1/8.18.1) with ESMTPSA id 4ASMFXwZ2125882
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT);
	Thu, 28 Nov 2024 23:15:34 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 esgaroth.petrovitsch.at 4ASMFXwZ2125882
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=petrovitsch.priv.at;
	s=default; t=1732832135;
	bh=h2MqZpEynosisovvFZzTqVcgF9aHF8+XJH8KFujSEFo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=wTBYtbxugHUHw8M9oUBxafHEcRrVl6DmC+bwh5NDRQXDAxZ99fGbIneDl8eRkAw5/
	 MYnc0IS1lUBQuUlLN7Q5RxoeFQOrqNDmHllVgLT/+/ObTZTYz+bAg4GySsR+zCIKPj
	 s1+ARFaVrouPt1VfQ40OmBIW0d+cbsIIk/r1FGjc=
Message-ID: <4db72181-00f4-467e-9b18-f7b98bc103a3@petrovitsch.priv.at>
Date: Thu, 28 Nov 2024 23:15:17 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH] netfilter: uapi: Fix file names for case-insensitive
 filesystem.
To: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
Cc: Florian Westphal <fw@strlen.de>, kadlec@netfilter.org, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
References: <20241111163634.1022-1-egyszeregy@freemail.hu>
 <20241111165606.GA21253@breakpoint.cc> <ZzJORY4eWl4xEiMG@calendula>
 <5f28d3d4-fa55-425c-9dd2-5616f5d4c0ac@freemail.hu>
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Content-Language: en-US
BIMI-Selector: v=BIMI1; s=default
In-Reply-To: <5f28d3d4-fa55-425c-9dd2-5616f5d4c0ac@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DCC--Metrics: esgaroth.petrovitsch.priv.at 1102; Body=14 Fuz1=14 Fuz2=14
X-Virus-Scanned: clamav-milter 1.0.7 at smtp.tuxoid.at
X-Virus-Status: Clean
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
	*      envelope-from domain
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]

Hi all!

On 11.11.24 21:28, Szőke Benjamin wrote:
[...]
> What is your detailed plans to solve it? 

Use a sane filesystem which is thus case-sensitive - case-insensitive
filesystems are broken by design (e.g. think of upper case/lower case
situation for non-ASCII-7bit clean languages like German which has
lower case ä,ö,ü and the upper case equivalents Ä,Ö,Ü including different
encodings - no you don't want more than 1 encoding on a computer but then
reality kicks in - and that in a filesystem driver in a kernel ....).

Kind regards,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
      There is NO CLOUD, just other people's computers. - FSFE
                      LUGA : http://www.luga.at
