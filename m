Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0184337BE6A
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 21:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777410163; cv=pass; b=Cb3y3UuviNbFTCA3lsS25MmclcR/6KTHPlH2bUuEfUn5llXfUfaSjHZW5Co4zyBDBMequqwLqd+Cg1gZXHMCfcYYdNhlhalrrLGT7K/axBl+Q289LkcprjxqE7y17ousq9HRTLCwKqNkEI0MVzizVl0FcxEHGlr+vH0pR2P4bqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777410163; c=relaxed/simple;
	bh=QZ5g0rywRPmTuJ69hvkprtR7MFhY68sDBLhcgw0FtUk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=DzHoTN1xYtp/jkbcn9irhf6txT251CEjhLUQeCIe1mwe7kMGOlqA9qGn4hukzmUI/sfo6GsqsJDZvs8I0Bc9vWFqZgAsiMtVUkPMgDUf7t5YqkTn235KL3zGQmTvo5DaFQAiv5FXPRiY3NUCeWgCItKok72nPp2CKraMor4bX7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20251104.gappssmtp.com header.i=@mojatatu-com.20251104.gappssmtp.com header.b=SiHaxxoU; arc=pass smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20251104.gappssmtp.com header.i=@mojatatu-com.20251104.gappssmtp.com header.b="SiHaxxoU"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c79467f11abso8030605a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 14:02:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777410161; cv=none;
        d=google.com; s=arc-20240605;
        b=fE3qGf6JuFUld7MNN2jBSe9xmjd5jzK5cFxsF3yQv6yOoT0x1zc+TYa5oTUQShUqXD
         3aoxIhnoVvuZsi+iyVvT4JLMS57kJFQ9iHsHjqXGEmelqAzShzZqdNyyWvX7lY6MCtJq
         EVpzy3JkoFXelGURChhDhvhj32zeZQNqnrwIkwCCdBswPv5//QDf0EH51En7ljxI1yU3
         YP7fVehmZKTbOrfxJJJqXZjw6W66k/beAgIMSLj3JLQKUTOu7PV1k8ImSnitMY2PBoIi
         srhlgpcM40PP5vafst9rYpdr2uHgl8w0FK7ySp7Zzi9bTkMg7yIT1ia23KTv3ybOm6hp
         w7tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=QZ5g0rywRPmTuJ69hvkprtR7MFhY68sDBLhcgw0FtUk=;
        fh=h+oGYf/KwoE/RRxUoSr9uvNH0S+lbqUBetgQcSkX1zM=;
        b=kBHbr/K2vneZX2BA2r3PxoDVwDEqBrYf+NLlAW2OAzBqWsSAkH+bBTBy3RKOqr8iDO
         MKJDdDALDwe+IzcDh0/qGRFMF72sEj+xyk2Yh8lE8h7TJKxmzdnMpoQ5MUbl95bxbSGV
         No5q7nFhgnX5Wc09pSJjiWUuhqaN7Do+sxJZII75Mmcg7XgjgeyqXAQwm68FQRNR0gsH
         GaE7q8F/WnqUxsORhDQmG1chs3hQJjLKs8t8aGjWghaBLZMkWAPUOEgRGUqtwVfxV7hU
         R6AlfYuhQ4zhrDP+UXvg1IEBq5HxeOSnZ36vL9UGr286WMxlYWIP45ifJIL2l6Ph8A1M
         jXiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20251104.gappssmtp.com; s=20251104; t=1777410161; x=1778014961; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QZ5g0rywRPmTuJ69hvkprtR7MFhY68sDBLhcgw0FtUk=;
        b=SiHaxxoU4y/Y2KPdUjP5E1imfmZialfvd/cWpcEqFEvAe6q3YrReObRIgOm9QdUgiy
         omiqDXA3o/pcWVR+w37kVsh6xf8knA3bem6ruW96/fx0y9GK13FQYckQ0Xfgf8csyMeJ
         +jGoNoiBStSHfXyEmqgiG/1AU7yw2n0mXS/i1Cb9+BKYfT7Avt+AaDwmvcSBJWjJNkFo
         bBm3+8EEQdw9J3D4NJtM5b6zDYQKLcfZpz5AsGoEbqyuEoyJqvNatqhJlYuhBVikR4+t
         DQ7AJ7MegJq48WX/jfB5brsaouFW7v4KMXHm5pup3XvvZbS9HPuKaKyZifysD0lUkB02
         YNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777410161; x=1778014961;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZ5g0rywRPmTuJ69hvkprtR7MFhY68sDBLhcgw0FtUk=;
        b=mspBbJMehH75bQW11IU3O5afP1oipa7i5dDrg8Xr0dM7EUtD6KLvo6zxSA961/pp7B
         AHWUOa4aXg44/N3x8qVuHUZwO3HIJdc+e4/yKj51IFiYxPpjlfNDqhMZ7cZhjV608w2g
         CxIEmYufvf7yb1mzdR1BKsIWUBdzZFf0wh8YrVc2JK1cVrkrNSX8aGaaHMh9VR3n3Die
         STBf4MKK8J2cjt0Cs95nBVvC7GHRK+CQPKCLnhZQWf0swI/qh8y3Ebl3EmjC3iin/3Tp
         z7G9DGtnJ2lzKMCsAqQUB4N/Sl7T71ibauV9NtZgCEYBmqg2qfQ1smZqSb7P14rB+3AU
         Q6Yg==
X-Forwarded-Encrypted: i=1; AFNElJ9eR6AI6vL+/bERle17KdlV3f6kdCtmH8SWG03ZInZCkvoQTGlzgdDuEVSCW/kfXQhnTPPuJex8GhiMIeGDoe4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZmnCtgtvEDX6WgFhnv9OHrB43x2RHaZxPalm+W8VmUV3YPFVS
	dKsEkHBiFwecdYYVdc+/ueQcBY+B91uZV0SNp8JHv0yczf8uoBFUZBEOHhOhBYl7CzmnoCcLfrj
	dMdjQMMamGjbfWzUAA22+X0xSmPvz5EgMdt9DqNL7
X-Gm-Gg: AeBDieuCWTy3mdGT3M7sA1NI/TDAET6qIz81Um93xw5Ffm15MlxiAZODncmOrGGpiXI
	CDxpxKiwRcgXRluSwJiqjdtyJod0XTkgJ1su4vkemKCAy89OlkyopdHj7wj4CPBbe6ks3I6N4WX
	jE9jPtQlClR/5k7lqEfq2mu7g7u16ABZZ88k52EGijYU92OYlaACqOoNEm5veOlfIOUGAAWHPGr
	WOYfYtveOqEZza7wgc+2BiKon3RqCbcRL0zpcGYq7eud+qOWHurCTOK0RUOFZqRnwjGLVtqhMAl
	n07w30hXLW7Nj1tJyrFW9IKQEzOtoQ==
X-Received: by 2002:a05:6a20:9146:b0:3a2:df61:50e6 with SMTP id
 adf61e73a8af0-3a39c3da898mr5265488637.47.1777410161237; Tue, 28 Apr 2026
 14:02:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 28 Apr 2026 17:02:30 -0400
X-Gm-Features: AVHnY4IPbL50MGY9wUIpXRQqsPuw4TFCQyKCgR4OtAo8xSoWCQRt5lBPiF8oDqQ
Message-ID: <CAM0EoMnv9ZDWFSDGMK3iX9dXjXNLs+v30ak-GgsLBq3EQ+hQsw@mail.gmail.com>
Subject: 0x1A: Call For Submissions is now open!
To: people <people@netdevconf.info>
Cc: Christie Geldart <christie@ambedia.com>, Kimberley Jeffries <kimberleyjeffries@gmail.com>, 
	Stefano Salsano <stefano.salsano@uniroma2.it>, lael.nasan@gmail.com, 
	PJ Waskiewicz <pjwaskiewicz@gmail.com>, program-committee@netdevconf.info, 
	Linux Kernel Network Developers <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org, 
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

We are pleased to announce the opening of Call For Submissions(CFS)
for Netdev conf 0x1A.
Netdev conf 0x1A is going to be a hybrid conference with the physical
component being in Rome, Italy.

For overview of topics, submissions and requirements please visit:
https://netdevconf.info/0x1A/news/netdev-0x1a-call-for-submissions.html
For all submitted sessions, we employ a blind review process carried
out by the Program Committee.

Important dates:
Closing of CFS: June 1st, 2026
Notification by: June 10th, 2026
Conference dates: July 13th-16th, 2026

Please take this opportunity to share your work and ideas with the community

cheers,
jamal
