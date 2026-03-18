Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824A33876BF;
	Wed, 18 Mar 2026 12:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773838162; cv=none; b=N1MkYBOU1/otEQOn6CjirnnAZVsB4wRvcBm64HAUwzM6A1oM+zxpUnECgbuvg2ZHh2zgGZN/gAoqYTAX0QTIa3XgHZiLkfvGfp4F9Wi0EVGtQO+UDQLNvDIvRsUq0bCyj41ajygmrVVdmp669XSPvghW6BiSB8E7nkzUr7I3GPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773838162; c=relaxed/simple;
	bh=oT5Bg5wm2M5gH8WW0b3j4/g7X/PV1Dtw1kQhET+zdlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZAGuOr0yjP4RvWZ7OSqesx1LlnOD5G6foy4HIBsRev5F5sm9bMFqbCxMR3dYodwmkkeuEgYkJxh2xtuKFp9F7BBzpwfJ7lGhA4K6Emj2ghjBXNR2af+hxHqMPOL5Gwh3HUnzUKqZ9r2EELh/UWD2iuyx5GpZ2OmDWwnKBCjaT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=pGkIFAwC; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="pGkIFAwC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=t6ztXRiuTH/ghBe6+H1/ISwluyE+GSDSXbsO1ukkq0U=; b=pGkIFAwCnHC80vtzD1NKsVLnYv
	+4LJvOGaYvWKtfZhf0i7LElV+hRdXxUvpnj8ZByRSaNeSCtxUvOU4YR2Z2Xfke1pUYGl9vDuHecUP
	1QQq8op7PYYMeKH6IZs2u9Gyj7s8JtYObDcJMVpexh5epuPxghl8sMnQ8/psSplujGcnUEkQJbcmE
	0XorQDEa1qXuF2oiZ0B2pvHSjoD937H0xkBMYmsZe5lM/Ghk2gvmsuJauMkDtDTTt0iBfkx8CEhYw
	Tm2vgMM3GE51yxAWd5LIdj2OEm/uawrRuw/lBcEZNmEXpyyA7W1T5NvId5XL1gqdtnVrn+M0PnXJJ
	SaZOJP7A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <carnil@debian.org>)
	id 1w2qKp-003fUl-5H; Wed, 18 Mar 2026 12:49:14 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id E23BABE2EE7; Wed, 18 Mar 2026 13:49:12 +0100 (CET)
Date: Wed, 18 Mar 2026 13:49:12 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>, 1130336@bugs.debian.org,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: Bug#1130336: [regression] Network failure beyond first
 connection after 69894e5b4c5e ("netfilter: nft_connlimit: update the count
 if add was skipped")
Message-ID: <abqfSB0TUik1kRU4@eldamar.lan>
References: <177349610461.3071718.4083978280323144323@eldamar.lan>
 <c72a56ab-a16c-4866-9a44-a03393f074db@suse.de>
 <b3cbfd15-acd1-4500-ba30-eac6f48523fb@suse.de>
 <abW2MAAqLnKZm3KF@strlen.de>
 <177322336258.4376.10097494324750307114.reportbug@Desk1.simalex.iccbroadcast.com>
 <4da571ab-fa1d-4ee6-b71c-24f4a28243ed@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4da571ab-fa1d-4ee6-b71c-24f4a28243ed@suse.de>
X-Debian-User: carnil

Hi Alejandro,

On Sun, Mar 15, 2026 at 02:09:33AM +0100, Fernando Fernandez Mancera wrote:
> On 3/14/26 8:25 PM, Florian Westphal wrote:
> > Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > > On 3/14/26 5:13 PM, Fernando Fernandez Mancera wrote:
> > > > Hi,
> > > > 
> > > > On 3/14/26 3:03 PM, Salvatore Bonaccorso wrote:
> > > > > Control: forwarded -1
> > > > > https://lore.kernel.org/ regressions/177349610461.3071718.4083978280323144323@eldamar.lan
> > > > > Control: tags -1 + upstream
> > > > > 
> > > > > Hi
> > > > > 
> > > > > In Debian, in https://bugs.debian.org/1130336, Alejandro reported that
> > > > > after updates including 69894e5b4c5e ("netfilter: nft_connlimit:
> > > > > update the count if add was skipped"), when the following rule is set
> > > > > 
> > > > >      iptables -A INPUT -p tcp -m
> > > > > connlimit --connlimit-above 111 -j
> > > > > REJECT --reject-with tcp-reset
> > > > > 
> > > > > connections get stuck accordingly, it can be easily reproduced by:
> > > > > 
> > > > > # iptables -A INPUT -p tcp -m connlimit
> > > > > --connlimit-above 111 -j REJECT
> > > > > --reject-with tcp-reset
> > > > > # nft list ruleset
> > > > > # Warning: table ip filter is managed by iptables-nft, do not touch!
> > > > > table ip filter {
> > > > >           chain INPUT {
> > > > >                   type filter hook input priority filter; policy accept;
> > > > >                   ip protocol tcp xt
> > > > > match "connlimit" counter packets 0
> > > > > bytes 0 reject with tcp reset
> > > > >           }
> > > > > }
> > > > > # wget -O /dev/null
> > > > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > > > rc3.tar.gz
> > > > > --2026-03-14 14:53:51--
> > > > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > > > rc3.tar.gz
> > > > > Resolving git.kernel.org
> > > > > (git.kernel.org)... 172.105.64.184,
> > > > > 2a01:7e01:e001:937:0:1991:8:25
> > > > > Connecting to git.kernel.org
> > > > > (git.kernel.org)|172.105.64.184|:443...
> > > > > connected.
> > > > > HTTP request sent, awaiting response... 301 Moved Permanently
> > > > > Location: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/
> > > > > linux.git/snapshot/linux-7.0-rc3.tar.gz
> > > > > [following]
> > > > > --2026-03-14 14:53:51--
> > > > > https://git.kernel.org/pub/scm/linux/kernel/ git/torvalds/linux.git/snapshot/linux-7.0-rc3.tar.gz
> > > > > Reusing existing connection to git.kernel.org:443.
> > > > > HTTP request sent, awaiting response... 200 OK
> > > > > Length: unspecified [application/x-gzip]
> > > > > Saving to: ‘/dev/null’
> > > > > 
> > > > > /dev/null                         [
> > > > > <=>                    ] 248.03M
> > > > > 51.9MB/s    in 5.0s
> > > > > 
> > > > > 2026-03-14 14:53:56 (49.3 MB/s) - ‘/dev/null’ saved [260080129]
> > > > > 
> > > > > # wget -O /dev/null
> > > > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > > > rc3.tar.gz
> > > > > --2026-03-14 14:53:58--
> > > > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > > > rc3.tar.gz
> > > > > Resolving git.kernel.org
> > > > > (git.kernel.org)... 172.105.64.184,
> > > > > 2a01:7e01:e001:937:0:1991:8:25
> > > > > Connecting to git.kernel.org
> > > > > (git.kernel.org)|172.105.64.184|:443...
> > > > > failed: Connection timed out.
> > > > > Connecting to git.kernel.org
> > > > > (git.kernel.org)|
> > > > > 2a01:7e01:e001:937:0:1991:8:25|:443...
> > > > > failed: Network is unreachable.
> > > > > 
> > > > > Before the 69894e5b4c5e ("netfilter: nft_connlimit: update the count
> > > > > if add was skipped") commit this worked.
> > > > > 
> > > > 
> > > > Thanks for the report. I have reproduced
> > > > this on upstream kernel. I am working on it.
> > > > 
> > > 
> > > This is what is happening:
> > > 
> > > 1. The first connection is established and
> > > tracked, all good. When it finishes, it goes to
> > > TIME_WAIT state
> > > 2. The second connection is established, ct is
> > > confirmed since the beginning, skipping the
> > > tracking and calling a GC.
> > > 3. The previously tracked connection is cleaned
> > > up during GC as TIME_WAIT is considered closed.
> > 
> > This is stupid.  The fix is to add --syn or use
> > OUTPUT.  Its not even clear to me what the user wants to achive with this rule.
> > 
> 
> Yes, the ruleset shown does not make sense. Having said this, it could
> affect to a soft-limit scenario as the one described on the blamed commit..

Alejandro, can you describe what you would like to achieve with the
specific rule? 

Regards,
Salvatore
