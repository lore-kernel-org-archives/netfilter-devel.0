Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245552594
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 02:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751596605; cv=none; b=Y7M2V04VGG/4lU/nyi0pqdyYu0EoL6vqq6leMmKL7VjQEjAntBS8tdJrjlR85KxzVP04P837kM/8Y9SXBy3x2WSmPjRjWNFe1xUPuIS9h3A6ZFPb6hm++ZNAYVOV0f0ID8aFrEs2keV7NtIvkp6BuyboJlbsVQUILMcmMrNgYAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751596605; c=relaxed/simple;
	bh=nbrv5Em4Z9yh4zF/0JUixgS4/lxl0m27Q6QC1u29PGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=uFpEZ0nK9tbUeiGo1SSORCveq7fJw08kCs4VYRzxJ7Q5F1U3gj+VVQ+rabOMDoDNPp7DFz82XYbjKwL+qqQxw3hCxvHH2WOSxy8U6ip7l8rlMSnu7YHpfHd1q6pjYmQ2bUQN/OCnirG43HKfLNWEwH2Jo+yKe15S7ALceGJ2OR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kuCqBXGn; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuCqBXGn"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6fb01566184so4092846d6.1
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Jul 2025 19:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751596602; x=1752201402; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/MsF3FHNu8DZevB89F0fP1g0u/Fll5IS8rvhtChFsU=;
        b=kuCqBXGn6tUfexL3QJdiIm1hIS/PEsZAJyqtWo+vF4x2pyJSJkJ2Gh6M42J7Ku2dZl
         LdegojIj7zBbDbT+SWSXnsLyhCi0F8m3jA178gOC0njajnNszwLZMpoQJbnisXhhrDTc
         5MHg8nYdWlIvZvf+YH29Bir8HAJDsjR+fk/Nk9/itGrO5kBEebd8quAdhNIK2KrK3kog
         Ucd4i9VzRwlrAy5YqC/gnmP8c1cJlS/c/1Gn/9XZEXY9QI0jUi1PWd2FTZCgAVmX2Ibc
         EJTuDBL/9379PErY5ohfGF9bxieub2dMFCstUKrbc3k98yzyf172Lf2XyvgIRaz8G1qV
         eumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751596602; x=1752201402;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T/MsF3FHNu8DZevB89F0fP1g0u/Fll5IS8rvhtChFsU=;
        b=NCTHbNHfZgM/nke4S4mVwIdhVrz6KWeLAfJ0wW5BGK4TFZGJoleYoI37lJVO67YNXM
         h4xgIj9jRo6Wn6z/UzJ8dfjaDzEmIqcHrkNA0g2Qs5SMb9htLSI86M3GOuHWrFu4VD2o
         637n33gKcwOYFM4vfdE/wn0UZOj8TI+ItPVL/EwRxSXZmDbL22iE0tTAbED9/ihSXQjr
         kNvaS5KTo9pCqA8zPgeaIz4sGcA9OzyYfQ99AGHB9yeZJkv+F0a1dPOvlaE62K6noSXe
         2Avd8HqKA26CBGsabh3l6SkT6CNCs2sZmQ2tKa4qg84+hobSky2JdWRoNJvGrpHiJV50
         fJhg==
X-Forwarded-Encrypted: i=1; AJvYcCVZUrbegbT3Knb0NDtqK+xNgmE/LhAd5oRZchziC7SMwmuj+HJr6TDJa8szlls3k+Db//EGvqTVI7A4zSBg+p8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzZfUU327srEuKCEyZkiksMYovSv4LkUvObaRetlOdy1OfVVnm
	2DfKlhBMi1YTzR1b7STHX95q3q/kjMD04JIeZUqvWjZeBm/SSjZuaMq9ML5EytMeNLnOVI/v4Gl
	3C9FkK+YJLDJBtBeOz5KSeDsHWKg1nHo=
X-Gm-Gg: ASbGncsUL23G0zhXkjC+wf48as915mH+oFo94pxmth/rAGrM9pycIRE04NefdO5Nvyd
	5K4Tpc6stv82qJEQilcIoYwDp6kzOHxAlnlD74keWTgjwRd4ILDm9HCUZafNfpoWrfhU3w4pqiO
	P8ofPCMuziVJUKYbS0FTfXib/oOF2wpCtvQ1T7UorXgvQ=
X-Google-Smtp-Source: AGHT+IHW+7CTp1HtZ3uDE9P2WD/dfTGC8aG2yzHXD7tjiAOrM7h7UDnuJfdIt5GSQn3pn79Vv+rWdsMIyFc0VMx9JIw=
X-Received: by 2002:a05:6214:1bc6:b0:702:b28b:d4c2 with SMTP id
 6a1803df08f44-702c6d3a3e0mr10477356d6.17.1751596601934; Thu, 03 Jul 2025
 19:36:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703135836.13803-1-dzq.aishenghu0@gmail.com>
 <aGaN_9hnyR9AdOdT@calendula> <aGaTBm2-wSvSySEN@orbyte.nwl.cc>
In-Reply-To: <aGaTBm2-wSvSySEN@orbyte.nwl.cc>
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Date: Fri, 4 Jul 2025 10:36:31 +0800
X-Gm-Features: Ac12FXyMmKesWnRViUcMG1rpjWjn9APVfgdCD5CMvac7GJDHiKq6fUW4KFjiOqk
Message-ID: <CAFmV8NcEF7OhmHkjebvLJ+vDR+4KNn7akimiVP4hmYhdnMLJbw@mail.gmail.com>
Subject: Re: [PATCH nft] tests: py: correct the py utils path in the source tree
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>, coreteam@netfilter.org, 
	netfilter-devel@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Simon Horman <horms@kernel.org>, Jeremy Sowden <jeremy@azazel.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 3, 2025 at 10:26=E2=80=AFPM Phil Sutter <phil@nwl.cc> wrote:
>
> Hi,
>
> On Thu, Jul 03, 2025 at 04:04:47PM +0200, Pablo Neira Ayuso wrote:
> > What does it break here? Provide more info.
> >
> > On Thu, Jul 03, 2025 at 01:58:36PM +0000, Zhongqiu Duan wrote:
> > > Fixes: ce443afc2145 ("py: move package source into src directory")
> > > Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
> > > ---
> > >  tests/py/nft-test.py | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > > index c7e55b0c3241..984f2b937a07 100755
> > > --- a/tests/py/nft-test.py
> > > +++ b/tests/py/nft-test.py
> > > @@ -23,7 +23,7 @@ import traceback
> > >  import tempfile
> > >
> > >  TESTS_PATH =3D os.path.dirname(os.path.abspath(__file__))
> > > -sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
> > > +sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/src'))
> > >  os.environ['TZ'] =3D 'UTC-2'
> > >
> > >  from nftables import Nftables
>
> This is a needed follow-up of commit ce443afc21455 ("py: move
> package source into src directory") from 2023. Since that change,
> nft-test.py started using the host's nftables.py instead of the local
> one. But since nft-test.py passes the local src/.libs/libnftables.so.1
> as parameter when instantiating the Nftables class, we did nevertheless
> use the local libnftables.
>
> Duan Zhongqiu, could you please point out that it re-enables nft-test.py
> to load the right nftables.py module in the description? Also, please
> add:
>
> Fixes: ce443afc21455 ("py: move package source into src directory")
> Reviewed-by: Phil Sutter <phil@nwl.cc>
>

Hi Phil,

Thanks for the detailed description.
I'll use this information to post v2 later.

Best regards,
Zhongqiu

> Thanks, Phil
