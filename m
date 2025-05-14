Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E5E1DFE8
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 02:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747191259; cv=none; b=ObJ+t2nbtzRv3BM53A4GDvR8j7Akf7++YCcekAEiPltcjDBxcTbXXxttMB6FxWHkzeGWrh5B4M5Khb77rhiX1TTbALi2xf4yAIAUq35SThVjLLVcSP7KL/+htvmBNNUrTJS2yEPcZLy0aZDRNPFdI6rtPCxXxi+1raxNFBbTCOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747191259; c=relaxed/simple;
	bh=aEVtejBO9RZYmIQjubc592cuKBW60b1EHXaK3Y+Kx2k=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PbMmmaza2Km7s6M/7tNZpjcXlndXS3Iv/GE/eFbGivdTNXgCCwiA1BLJCGvxyb5zGGEVHfK7n2mC+1Unpl20bMHwQhud5RnefbpswkmT5HsitIkTOuvbDfIJ1Ws7UF5FdlxBcP0M4ufNFaZ+7snd61ZnpsmzsezdtJibRvq0eJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FgNN+9pO; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FgNN+9pO"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4769aef457bso77598061cf.2
        for <netfilter-devel@vger.kernel.org>; Tue, 13 May 2025 19:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747191255; x=1747796055; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GEKFVhL6hCb1xNlmq13kTzUPUrn4LG2l0oIWGcff+8c=;
        b=FgNN+9pO0qXjf/QuIkM3MHeptRvwHG2gWf9YkZG6PcHp3X73PC2vQ34zPHecY1n7wJ
         YdRxMp4lBdpD7pRWX28uBvmCMPxtCGkCSU/ZJgkX8bluiqB8zgqbb6OAf49Mdbf0HVq3
         1WN3sUh0LSb9qTGKft/wJIyU9Au5l9+XJ/BogG667DUJkgs83d/v+1IhAPQLwraoTX1k
         cC+/JKEgAjRwU+05jRv0+vbKkoDxr/FXUDqElfHq91uEW8XnzmXqeKkaDdYZ3IZycvZ5
         3n/Sv+v5B6KIGXAg3sY9xkPqlOYUCWXIHfTnFAT6ZYOk8PEpDEi1dYlZUpNxDybMZzZ9
         AQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747191255; x=1747796055;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GEKFVhL6hCb1xNlmq13kTzUPUrn4LG2l0oIWGcff+8c=;
        b=R7YWCKb2dxNHHQXO3PuCAxXLC4Tm+g+A7RVqhl/5aWZhovNc8rNCaEMG3UJDygzThC
         0ide5ycIbcw38VKD8QqEi33VnMtfgootXtCyKCFmQhzMnVcWBWV15xRwUHtYRe49/cjG
         xgAWUOWvhFenM/US7UDOF/1w10xlrDP2U+O4gKAfqxDbZV+9v9Wq/d1+zJzui0sxhu2S
         EIHzBUvlJmcVuT+lRCI6FOx3CVp2XeqP2OQbInWVb//ll1fpdyMCPAAohR3tpWrD1E+G
         mxf/oFuhDMx4GOygpkHtIET1Vbks54BDbsQepN3qs0F1QnnjmEqmKEpmuAYzypNwVqIK
         TV9g==
X-Gm-Message-State: AOJu0YxWNW1Uup2Qka5Lkc1TDw0nQGJ1Ut6vFaI8K3SaxZXPFt6Vq410
	Mpcm55zg4maRLAYtctuOHHsOfCwppoWx2naSslMJJzi2ghtX1NEKfxIxeA==
X-Gm-Gg: ASbGncviFmwlyUnfvD/vU1LnnySVvjtsOCGoaYsF9XGmsi2q95IrSempjIswsmP5B53
	ECaR0ROzHHC1lyXmwDy3SE9TQtMPvojGTw2dWI0L4cFnH2vgHX4pnM+G3U+n4QuRiBZlZNLlOG0
	HUNHIdeMUjz+xcw3OPRAK0NemrH/dTtZSVJD+VHYglKUhlwD31eqWM19qwTsW6XmuUfeF9PXn2+
	mRt9w01DPLw8Rj9KQUxjT/iiC0CgCtXXcOXfqJwQHwzsffpPEp3xneBEV26rGVFXCFRHQLviv8D
	TKriaQGsAhAHiJOncEA8nuj4OKrsISPAWo0k/ZQozMdwJ2J4on2TivK/AcL0YD3kLZx4KMQCXno
	6cd1bI/3Znp2DO/VfGYQ=
X-Google-Smtp-Source: AGHT+IELPBJCRMdUqVdKQbzxeQCcYeacCXjWZqijVoa0htqsyPt//BVeMUp6DhuXffYAgDXLf3VTOQ==
X-Received: by 2002:ac8:4cda:0:b0:494:993d:ec36 with SMTP id d75a77b69052e-494993df0d8mr3129261cf.14.1747191255582;
        Tue, 13 May 2025 19:54:15 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-494524bc561sm72580031cf.35.2025.05.13.19.54.14
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 19:54:15 -0700 (PDT)
Date: Tue, 13 May 2025 22:54:13 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: Looking for TODO
Message-ID: <aCQF1eDdqgmYE3Sx@fedora>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Netfilter-ers,

I'm in the process of submitting my first patch, and have very much
enjoyed the process.

To find the work, I browsed the netfilter bugzilla, looking for
something I felt I was capable of, and started hacking.

I found this link about the Core Team:
https://www.netfilter.org/about.html#coreteam

6 bullets are listed as to what the Core Team finds valuable, one of
them being: "Implement what's on the projects TODO list.".

I possess no delusions of grandeur of being on the Core Team, having
just started, but I want to do impactful work for the project.

Where is this TODO list?  I looked in the various git repositories, and
some of the userland tools had TODO files in the root, but I did not see
one for nftables and wouldn't know where to find one for the kernel
code.

If there are better strategies to knowing what is the best thing to do,
even if that's back to the bugzilla mines, I'm all ears.


Thanks for the assistance!


SB
