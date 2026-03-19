Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072FD3A3E71
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 08:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773909905; cv=none; b=Ghb8W7D1HYo/xw96wHvDMqiBXVVhU7b+xQV8nnzdwZwVQQ1c7cM4vL7fKjuarLNaRSBiCbyp1Ejgt6Qe6PAI/GZ9B/oYF58jTRbECB2Bmi6FrPsID//+0AewOFTkJuemXYzhqf/srmzKueLpV64FKyP35AwSyNxwf2K+qzCbaQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773909905; c=relaxed/simple;
	bh=3GNC7qpyfUWAFD8/zUA9cu+cY1NU0svmPWQgrnshrwc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qCGv5qeKHx7Yf8XG3a3LBPo1ARSaw9BMombjd0dKjoT8xH2nlKZ7fMlpH1hYooK7kBBNS1ZEmdga0mBayXFcNF8GfayA7euDyyDRDDXOVOJPuyWJJC8RsEF4zO1dew95tWM+t5p+gm6zIwN9dpOCVapdZzLcGge6Aqsp/GOV9ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PSfiA5HU; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PSfiA5HU"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-485410a0a8aso5897485e9.2
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 01:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773909899; x=1774514699; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3GNC7qpyfUWAFD8/zUA9cu+cY1NU0svmPWQgrnshrwc=;
        b=PSfiA5HUJYJKGmaTd/WYVCP6CgOsrtqsUCrikbZdwjNzWOhz3rm/OjZRDricL6H+Id
         Gl+ShsdLPzvFZePzw46Vrt1alhOrLO35ZqwxR63+GJwJe5yORdDXnTzrTBchL26T61QD
         FjfOW38k6id8U0AHqUC6ik008q63p2ZDze24dCF07sReWiK4wIJPmN3b7RREuUJGOHJk
         pdbgTrwapD7SarLvCFPjxBGRnA/xK9mF+7111G2VlSvAGuqb4ewBvIgRJqWyPp+4+uxK
         Ltb0sd3YzjGTQQsUJeflXuK2nsiCv76oRDzbFRQ5qwZmYCQp6A+NnUuqsI22j/pUqZnR
         /feA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773909899; x=1774514699;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3GNC7qpyfUWAFD8/zUA9cu+cY1NU0svmPWQgrnshrwc=;
        b=VJU1uQ84nI4uJ10BkdLtUbvf3NA43DL1Iitk3NNkty4cZvZfrg7p9Bgb/m76PlRuhc
         ADGgCQr6+940tDtlWVGxDICmihDlnqeFAZmSigjX+e0NGUMEzfFODXhp5sXEr+Gd1dz6
         JiDdg1tEqEmlN++valS/pgRkUWHMqvN5SsPq1KH3aIyUS8s9jV/GOPZxeiSCDHDGIgfh
         xVECqOFC/hsED5RS1DIJK9I2XvNPVb55pJAU+xOBfN6pprsYYCEQaJFzUCD8w6SGJHu6
         76/9Oh6hUtWlpfzSbKKOmLbPawJPPZGPTeIrQiBDId3OGVDbZx1ioNUoDZqf7naYqxEb
         fbmw==
X-Forwarded-Encrypted: i=1; AJvYcCUcaXB72ZFNlNdh/xCFfPXowptHNqwjjXM0pIMPuFwKJ9LbP3de4uyF6qkG3WpBqj7TRjQHoGzEnU1406iOMZk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmIflyFmZLPQJOwqANtx09b3ZQwGnfIHfz8Tbv+jQeHOuw+fS+
	fjIlulaRFfFVeX/BIUpeXFLMlvRmMtHHDFQ0pv5awo+Dy9UIPvOMjujL
X-Gm-Gg: ATEYQzwgAHp38RVzOaDa5hgNu1OVLl7AjUN/3mT7BSWTX7oNuZxvIjd/6vJQ56+pddk
	LRvuI5XORumVAl7I7lA2XaddV8wHdTDwbK6V3/URAGHNif8LXZ+Ey4wj5FPN0ecF21V5ZqkmVjs
	h+Is7A2tgrfvY6Yv/jJUCXN8Sa6lRQKP0kd60PMceqVSwlCCw0pDx2qa08KMmUl6pjarvTs2lGb
	pRsjDzD3eE5IkEAIx/tR1f18FdbXSHjMi2TBVWb8Xih2X8PvN3Mm9qD0StxjyJ6awlkwjf1vhuH
	TfhIm10O3w8zZ2351ol4KMEVH8xVi+5vc50YduIEIFcYFzq2Wl9/aUFoAYeuOzG2IijuFJyy0ja
	QyTZ9OQYHRZcpJA7Lo/OtCJIlOHpxl/KsQ7QmBuLtbSIVwklA7cR7SPQ1Ha9/q/xoDmkUCSBFrG
	KzNN8eBSUZ77c7COTDaCXHvIaWkqFSsJM1Biqge3UQsfOsUT4Akg==
X-Received: by 2002:a05:600c:3e85:b0:483:6d4a:7e6d with SMTP id 5b1f17b1804b1-486f447008amr97772295e9.30.1773909898969;
        Thu, 19 Mar 2026 01:44:58 -0700 (PDT)
Received: from [192.168.100.165] ([212.230.233.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f8b296b3sm47004595e9.6.2026.03.19.01.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 01:44:58 -0700 (PDT)
Message-ID: <e24a281622cedf9e8f4dc93c961813aeb7b6ce4c.camel@gmail.com>
Subject: Re: Bug#1130336: [regression] Network failure beyond first
 connection after 69894e5b4c5e ("netfilter: nft_connlimit: update the count
 if add was skipped")
From: Alejandro =?ISO-8859-1?Q?Oliv=E1n?= Alvarez
	 <alejandro.olivan.alvarez@gmail.com>
To: Salvatore Bonaccorso <carnil@debian.org>, Fernando Fernandez Mancera
	 <fmancera@suse.de>, 1130336@bugs.debian.org
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso
 <pablo@netfilter.org>,  Phil Sutter	 <phil@nwl.cc>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet	 <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni	 <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, 	netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev, 
	stable@vger.kernel.org
Date: Thu, 19 Mar 2026 09:44:46 +0100
In-Reply-To: <abqfSB0TUik1kRU4@eldamar.lan>
References: <177349610461.3071718.4083978280323144323@eldamar.lan>
	 <c72a56ab-a16c-4866-9a44-a03393f074db@suse.de>
	 <b3cbfd15-acd1-4500-ba30-eac6f48523fb@suse.de> <abW2MAAqLnKZm3KF@strlen.de>
	 <177322336258.4376.10097494324750307114.reportbug@Desk1.simalex.iccbroadcast.com>
	 <4da571ab-fa1d-4ee6-b71c-24f4a28243ed@suse.de>
	 <abqfSB0TUik1kRU4@eldamar.lan>
Organization: alexolivan.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi folks.

On Wed, 2026-03-18 at 13:49 +0100, Salvatore Bonaccorso wrote:
> Hi Alejandro,
>=20
> On Sun, Mar 15, 2026 at 02:09:33AM +0100, Fernando Fernandez Mancera
> wrote:
> > On 3/14/26 8:25 PM, Florian Westphal wrote:
> > > Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > > > On 3/14/26 5:13 PM, Fernando Fernandez Mancera wrote:
> > > > > Hi,
> > > > >=20
> > > > > On 3/14/26 3:03 PM, Salvatore Bonaccorso wrote:
> > > > > > Control: forwarded -1
> > > > > > https://lore.kernel.org/=C2=A0
> > > > > > regressions/177349610461.3071718.4083978280323144323@eldama
> > > > > > r.lan
> > > > > > Control: tags -1 + upstream
> > > > > >=20
> > > > > > Hi
> > > > > >=20
> > > > > > In Debian, in https://bugs.debian.org/1130336, Alejandro
> > > > > > reported that
> > > > > > after updates including 69894e5b4c5e ("netfilter:
> > > > > > nft_connlimit:
> > > > > > update the count if add was skipped"), when the following
> > > > > > rule is set
> > > > > >=20
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iptables -A INPUT -p tcp -m
> > > > > > connlimit --connlimit-above 111 -j
> > > > > > REJECT --reject-with tcp-reset
> > > > > >=20
> > > > > > connections get stuck accordingly, it can be easily
> > > > > > reproduced by:
> > > > > >=20
> > > > > > # iptables -A INPUT -p tcp -m connlimit
> > > > > > --connlimit-above 111 -j REJECT
> > > > > > --reject-with tcp-reset
> > > > > > # nft list ruleset
> > > > > > # Warning: table ip filter is managed by iptables-nft, do
> > > > > > not touch!
> > > > > > table ip filter {
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 chain IN=
PUT {
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 type filter hook input priority fil=
ter;
> > > > > > policy accept;
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ip protocol tcp xt
> > > > > > match "connlimit" counter packets 0
> > > > > > bytes 0 reject with tcp reset
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > > > > > }
> > > > > > # wget -O /dev/null
> > > > > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > > > > rc3.tar.gz
> > > > > > --2026-03-14 14:53:51--
> > > > > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > > > > rc3.tar.gz
> > > > > > Resolving git.kernel.org
> > > > > > (git.kernel.org)... 172.105.64.184,
> > > > > > 2a01:7e01:e001:937:0:1991:8:25
> > > > > > Connecting to git.kernel.org
> > > > > > (git.kernel.org)|172.105.64.184|:443...
> > > > > > connected.
> > > > > > HTTP request sent, awaiting response... 301 Moved
> > > > > > Permanently
> > > > > > Location:
> > > > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/
> > > > > > linux.git/snapshot/linux-7.0-rc3.tar.gz
> > > > > > [following]
> > > > > > --2026-03-14 14:53:51--
> > > > > > https://git.kernel.org/pub/scm/linux/kernel/=C2=A0git/torvalds/=
l
> > > > > > inux.git/snapshot/linux-7.0-rc3.tar.gz
> > > > > > Reusing existing connection to git.kernel.org:443.
> > > > > > HTTP request sent, awaiting response... 200 OK
> > > > > > Length: unspecified [application/x-gzip]
> > > > > > Saving to: =E2=80=98/dev/null=E2=80=99
> > > > > >=20
> > > > > > /dev/null=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 [
> > > > > > <=3D>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ] 248.03M
> > > > > > 51.9MB/s=C2=A0=C2=A0=C2=A0 in 5.0s
> > > > > >=20
> > > > > > 2026-03-14 14:53:56 (49.3 MB/s) - =E2=80=98/dev/null=E2=80=99 s=
aved
> > > > > > [260080129]
> > > > > >=20
> > > > > > # wget -O /dev/null
> > > > > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > > > > rc3.tar.gz
> > > > > > --2026-03-14 14:53:58--
> > > > > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > > > > rc3.tar.gz
> > > > > > Resolving git.kernel.org
> > > > > > (git.kernel.org)... 172.105.64.184,
> > > > > > 2a01:7e01:e001:937:0:1991:8:25
> > > > > > Connecting to git.kernel.org
> > > > > > (git.kernel.org)|172.105.64.184|:443...
> > > > > > failed: Connection timed out.
> > > > > > Connecting to git.kernel.org
> > > > > > (git.kernel.org)|
> > > > > > 2a01:7e01:e001:937:0:1991:8:25|:443...
> > > > > > failed: Network is unreachable.
> > > > > >=20
> > > > > > Before the 69894e5b4c5e ("netfilter: nft_connlimit: update
> > > > > > the count
> > > > > > if add was skipped") commit this worked.
> > > > > >=20
> > > > >=20
> > > > > Thanks for the report. I have reproduced
> > > > > this on upstream kernel. I am working on it.
> > > > >=20
> > > >=20
> > > > This is what is happening:
> > > >=20
> > > > 1. The first connection is established and
> > > > tracked, all good. When it finishes, it goes to
> > > > TIME_WAIT state
> > > > 2. The second connection is established, ct is
> > > > confirmed since the beginning, skipping the
> > > > tracking and calling a GC.
> > > > 3. The previously tracked connection is cleaned
> > > > up during GC as TIME_WAIT is considered closed.
> > >=20
> > > This is stupid.=C2=A0 The fix is to add --syn or use
> > > OUTPUT.=C2=A0 Its not even clear to me what the user wants to achive
> > > with this rule.
> > >=20
> >=20
> > Yes, the ruleset shown does not make sense. Having said this, it
> > could
> > affect to a soft-limit scenario as the one described on the blamed
> > commit..
>=20
> Alejandro, can you describe what you would like to achieve with the
> specific rule?=20
>=20
> Regards,
> Salvatore

The intended use of that rule was to prevent (limit) a single host from
establishing too many TCP connections to given host (Denial of
Service... particularly on streaming servers).

I learnt about it in several IPtables guides/howtos (maaaany years
ago!), and never was an issue on itself.
Was it stupid? ... possibly... It 'seemed' to work, or, at least, when
checking iptables -L -v one could see packet counter for the rule
catching some traffic, without ever noticing it being troublesome, so,
at the very least it 'didn't hurt', and, since DoS ever happened over
the years...well, I tended to think it was indeed working the way I
read it did.

Certainly, I never (the authors of those guides at their time indeed)
though about the possibility of just target the TCP syn.
I have given a try to adding the --syn option to the rule to see the
difference, and well, it is way less disruptive that way, but it still
breaks things (I saw postfix queues hanging, for instance).

So, I have but screwed the idea of using connlimit anymore anyways.
Sorry for the noise. Lesson learned.

Cheers!
