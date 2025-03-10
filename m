Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3A5288A5
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 10:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741601636; cv=none; b=jzulsuT5Yf8iFPoiSTqm5Mm8HGRmg/kxXuz/eTCSqnf0mnXkQsbQi4zzJXuuISyR6IJTySz8dKNartIht2deZD4pl5g44oM91B5rxFIfkfKQLeEiEqUQxobrUGR92b8pOaQb1Ghslm6s8+xThpIPNu1Bt3iQ9fty++rehE8xJko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741601636; c=relaxed/simple;
	bh=xqjeg88g4YY+rfU7UR0/QK0cy8MsaHBWobw9Fuxu0yI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfnBW490KhZePEcm2XyQQE89pVECRe/AbSlMa621ZfH+5egvWizp3bMSY1QoCkbfCqG1BPNbyVazYiKwA3Kbnmwd5Ix4koEIeEWFXP/Fl/129HD8AgI2VaIiiQjn938NP3vsRHNzM4waG3CvZSWSFWtKswN+plqxRgXd/FmmeeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KjJMiHJe; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KjJMiHJe"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-224341bbc1dso39408905ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 03:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741601633; x=1742206433; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xqjeg88g4YY+rfU7UR0/QK0cy8MsaHBWobw9Fuxu0yI=;
        b=KjJMiHJeBRR6sqCCXxSg8/riXBmbXTUTRmsdmqv0qz2vWbjcw7Zu3GJblL2wS2mxK5
         Vn8//Kfgqr6L+lUhOtHSbyD4FULsxNfaUrNE5OftrFduKh6dShRrsbQDYSr09KCz4W5J
         w72edvvv0SwCXnq6961is8tZ6/aPuIKaZraRyDq2zfPnvNjzuUVBOMxF4H7O8TZZD5Y3
         Pfqa5PfKRd45xzwTTNdcs4PAKFoD6AqOzluYYrRpm3TqQiYsdlnJ+svKnTp4dNiNYtlk
         J49SUrI3fr9CfUMhrYTwjb7jrtOyHPGTBEyKOv4OsrmtdDWM91cz+TDYKKnRmTrO2TSd
         h31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741601633; x=1742206433;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xqjeg88g4YY+rfU7UR0/QK0cy8MsaHBWobw9Fuxu0yI=;
        b=HHX6HiB9hFiMa63epF4ZCSo1PbNPix1ES+J71irfUCWetPDI4PqDCqylg6Y0rN3q03
         ObuJcBU3uNDriSNjC55gH/dB9rK9o4Kv3r3Uorl5uVoUN7SdmXCuszL8+SHEBWk6EuVI
         UuMQl862J2cYKA/Jxe9l9aAnRPjSq6xXuQF14TgkELkz8slRT57kPH19E4RS/5xGcHrF
         7a9zcCqZkRi/+7hYzP5O3yOZuzNlQFIYqRxJaBqiY8saX+TbCxr6AQjSs+7kAl+bN9pE
         Deq/veUTC4aAf6HmP9K1kgIs0CzPEgK7x2h31kxJpveWP0KCUvSpvCptZuTgLIINYeSt
         kTMw==
X-Gm-Message-State: AOJu0Ywaml6lcm6D05VWZ7PtWJ2xSCX7sN9Hwg+2VvBEoWFwqlyvIdLs
	fvNIWRYHg9SBkqP8ftYCEcUPqGe6ZvYK990tfqzlScUNp6rfR4Dp
X-Gm-Gg: ASbGncsGpSyF7H9AfEBTKvD1wTqM/SICdvAwjsBlGVmfVAeh9S17GSEg9XjTzB/5WXG
	AqSBC8lecNq4LAdy9Jcqh0pRvA3t8XGC4/j9LaeZFGHRro7vprV13iiP5DKxe2UZdJzZWEzt6KX
	JazsAmg75MJrLn8q25ntGzTBkjq667Y0p9QrZ5voeq1wtFSvemhd6HPUE1ILXsKOZzSHy/HD1DR
	k0yODwRctr+SvX4G6GUVNZH4gSpPqpJP8SIAek848jn6Jh0DXWzdX8DuEyYIr926vL59rkpAu/x
	MIKYca2cPPV6SuP9FebzLC/ky6rLHR+ZHVAd2qLboGdEv32zrUqT/K1NGqQPqFoMQ8ainiR6H4Y
	FOcRGCunX/G0ggIFn5HDTwg==
X-Google-Smtp-Source: AGHT+IFrcpvWJ7gfXXRxRC4zbUaPr1RsYTGvk4vbbEpSB+ihw0Ajcvx3slC41d0Z1CX67WWBap+q7g==
X-Received: by 2002:a17:902:d48c:b0:224:1c1:4aba with SMTP id d9443c01a7336-22428bd4341mr182052485ad.50.1741601632852;
        Mon, 10 Mar 2025 03:13:52 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a93fe5sm73587255ad.206.2025.03.10.03.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 03:13:52 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 10 Mar 2025 21:13:48 +1100
To: Florian Westphal <fw@strlen.de>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log] autoconf: don't curl build script
Message-ID: <Z867XDT/eEA2prdX@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20250309105529.42132-1-fw@strlen.de>
 <Z85FG/1qImu3tiSS@slk15.local.net>
 <20250310083446.GA8451@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250310083446.GA8451@breakpoint.cc>

On Mon, Mar 10, 2025 at 09:34:46AM +0100, Florian Westphal wrote:
>
> I absolutely hate the idea of fetching stuff at build time.
> And in this case, we fetch an exectuable shell script from
> untrusted location.
>
Ok in future I'll send build_man patches to libnetfilter_log once they're
applied to libnetfilter_queue.

Have just found an error in the latest update :( so will wait for the fix
to be accepted.

Cheers ... Duncan.
