Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4812FC892
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 11:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756900302; cv=none; b=I12XnsOTpuT7Qcq+GonLI6y7NrY4n2t/eO7jcUIwr0Dbly4o6RLYprO+szCxiHHOpgJxwxvXkVkNiw3GT6hvCGWjC8d1TQTu7rtXqgW0eVcFPPToYjecsXme1NfLbda1LAv1uDOZS24jWeTUlx3Lq/vD1E1MPmKN+ehk3q0lxmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756900302; c=relaxed/simple;
	bh=9uGVkNtz5drWUFVhT87GN4H0YBHO6uPdw1cQ5wBL/ok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uI4IQsHOhdu8Z2w2bVZiYTSYvtGrTS3IjJnFiCJt4/Y00rzbVMgj2e0YPPBoSOT8AgbeQuQFyZEVBc102tstRHFTT64/s8QiM6+W6UT1D5wuVwhft6nkp2yQ7QI/5/WgAJIoFCanC0WsIBGI28+mokrV0F4ySg5C/hwxIjcuxwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XFdWyuFU; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XFdWyuFU"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3f453812254so6097845ab.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Sep 2025 04:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756900300; x=1757505100; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9uGVkNtz5drWUFVhT87GN4H0YBHO6uPdw1cQ5wBL/ok=;
        b=XFdWyuFUFVFJduHD5xXV9ZMnD3UajkPD0X6i+Mc4BuPpNHU89w7IZjmqoDEFpmUk1F
         r5B7VG14mVINddLeLYPDdVvhmvMGl1PEMZxybygbTMLpZCkGjF368jUAi+0Sy9Za+bxc
         PAWmGh1F9jJeqqt4zT+K46Vd5vHS8oBf4ny1htxzB0htpqMatUaEzxAhFbmC6+f0E4FF
         CCjvR2isNyXrOJD0x7SbjzOR71HLniB7Jxb6wRWaqLUUxndPRaKrFW5SNudSp8H5v94L
         sFjIHxCfa6OWdUm1nTXQk9lbqRFmNp9q0CP6ZXGWshs5bDSmSxKciOPoZShYLbPx9e+4
         4BYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756900300; x=1757505100;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9uGVkNtz5drWUFVhT87GN4H0YBHO6uPdw1cQ5wBL/ok=;
        b=fVURCZtFpSU+DVz4ayQ3KKWouYj4Kgy+Xf5+0fujr49Xjqc/K++DoPP62DOvd/eZQk
         vx1xNkGuzqKe0ww5gBrxOyxwutxAApdcbieKoSJ8ifmyHle5duzVhEEWkHfHQYNRrfw/
         eeVytF3feq8tMCU7S8vEbtOA3Qpf5k2CMwM6ZNq7H/xrH3Xp5sRqOjfV0hZj8ldHTEDC
         PvKvCnN8j4EO2Gci3V2oXU3N/3A+QD7nX3pADI3cMeJFz7qkhtG1JoKnpTFoccVQjZkp
         i0saobSADiBk0HOQ+jLclQHvJ27iA2zfDDg1U1yJ2hCVkk4iIV7ub7AWted3sl4pd2dC
         OaOQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9K0Hyq9W2nsEZR75YK9s0qn7lgMf+wqjUy+uFtEyc9KWtXkxJomb6gSerAx/MgDiF125wZlGYO8mgg54hc+4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwejmR2Daty7yeKk36PZpP4iytdh+L/GwCTQ3lpqkvGoVVXlGJx
	8Whr2FaD8E/1ZtJxZhYGK7QWTq+evqGfZ0wq72pTcvIdpQH3XK5tdCtcUpJmiRG8hiYWDeQ54SL
	vcBpanCWStM+ucjMmpt2Nk07/NC8bMmM=
X-Gm-Gg: ASbGncuobUpvXxvyVeOgQGfxVXwxjcrYYi2hIUeeLrvSt7mtQlD466BAha2pW3Ewoo/
	A3F++m9JI7SXgQidU2ubPLUF+D9w+fv77FsEJVYaeAz+n+p78GW7DJVP1/fpm2sKMOeYcshw7Ds
	3yOrzH2Ly1ddCECspkW8YcRvI86KoNgPv/WOq1ADRykYZILSILh5w024y4vLdWVC3S4aMOOC1my
	nqs11305ui+isXkqRCWvTKfYWYBFGFpDFKZmNav3vbSviGfdER54NeQ/lhgOfIdNG7p
X-Google-Smtp-Source: AGHT+IGe9uXmeimAFJdmzHzs0BVVT6JNNUhKL5gsOgAQimGnOeV4v6T/KwuzC8F5uDvRPtiY/pFRf7K1oJBpJnBvUDw=
X-Received: by 2002:a05:6e02:1488:b0:3f1:1e6b:564d with SMTP id
 e9e14a558f8ab-3f3d65c04fbmr217928455ab.13.1756900299693; Wed, 03 Sep 2025
 04:51:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+jwDRkVb-qQq-PeYSF5HtLqTi9TTydrQh_OQF7tijiQ=Rh6iA@mail.gmail.com>
 <20250902215433.75568-1-nickgarlis@gmail.com> <aLdt7XRHLBtgPlwA@strlen.de>
 <CA+jwDR=zv++WiiGXTjp3pMrev2UPxx9KY1Y-bCFxDbOV7uvjbQ@mail.gmail.com>
 <aLgUyGSwIBjFPh82@strlen.de> <aLgZoVg-lIffgWI-@calendula>
In-Reply-To: <aLgZoVg-lIffgWI-@calendula>
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
Date: Wed, 3 Sep 2025 13:51:28 +0200
X-Gm-Features: Ac12FXz0VU75O-cfSYw-46o9t8eP1GcM75qrObSmSbYlIXaMz2aDdC3wjoTrjA0
Message-ID: <CA+jwDR=cn1LhPLjPW8YLSwjpGNYLisHJr=DGLh9-x1OSVaVjkA@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack
 expressions in inet tables
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks for clarifying. I'll look into preparing a userspace patch
when I get the chance.
