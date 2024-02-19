Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164DA537E3
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Feb 2024 20:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708376102; cv=none; b=pp/FRWr1FBDsv/BqKLtFY6gSQwno6AxP8S3lkb0kLLSdMVcPxsEHomR6U07zQ0jsjylOdSqHqzEup8MrL8SkCnSAM8Gaod6mONaaqKUisRZ4l6dIxuZd9bdaaIW5IPJkbMVQYUPkLq93TXsa8aFK5wKFQaQgf1I95VpwFMyoO1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708376102; c=relaxed/simple;
	bh=PRWFNSl5rdyh0LIam4lOCvZVzrH50yS0VHN/syfc6O0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=QVaFOkKLFiYMIJ+Q/Tz6HyLWU6r06mBBotSaJXR8g62Qm+9qHJPhlXxzpvfKyziSq+PPjL/thK2cySPKOmSmpLJ089zipY+SNNyvJ5jn413eyzc6lEPbs/2WDdBhHuDjWdOaCwJPih/Dxv3T1I46d0i5svrUEw9U6m8LxF7kGW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=wZQgpTdg; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="wZQgpTdg"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-d9b9adaf291so2960620276.1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Feb 2024 12:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1708376100; x=1708980900; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PRWFNSl5rdyh0LIam4lOCvZVzrH50yS0VHN/syfc6O0=;
        b=wZQgpTdg1IXJW+3pJz2pDeRelZJStxFfeYZwj1TCN3I9wndQLgPucomWofYrPaG3ye
         +/i5OWWAQwr8w3FVbI4IQli6X+Y9dQ3lgZPko67X+9SlAG5U0R0Fa3g3zS5yVTkgRHc/
         Sxa6Wj6TkMok77tlYPsMR6ptSswjiWksNxA/Bx879L2xSJDBetC2k2JeEbdptMOjbmh+
         C2pVGUpE6qYSeOKe8OjSjNHGTc2EFqEOU1fJACWhjaWcM+vqfFpwm42cqDTvBitgmnZz
         Rwlpb8/XaRaWmpJj5UX8gewFS0sfKbZO2WjGobr9/dMI0eshFakhNB9rDyc35HJA28po
         YXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708376100; x=1708980900;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PRWFNSl5rdyh0LIam4lOCvZVzrH50yS0VHN/syfc6O0=;
        b=BZQ7ROWCTkRnayuaAdCxx5D5YhKt34BcqlG6vhcNRMy5EISBExDfbewGk0KWTQUBoM
         nH7SnWBHhmG7V8l+7afi3u0zKl4Mr4s1/uA6kS8kiilEHsCWDeZM8/HKL7pk4XncvqYV
         SKc4VPmiIOOXJUNmobDUSYZTqxeB363iuZ3hn7AhE+iRr/2V9iLrD5tTGOI+38xR6GHG
         o/euwHi19zNLMGXxIDBSV2CjZEVUIDmh7iVHF2bioislVmyxpv2SjhzFwlF4Kw3rRZQK
         3qDmVT7N61SpQ08sMo/Hv9ghhIRhx8Ys8/lrQAt2Q62iNTlNDTjbvUDVSpxYH+WQtcde
         09CA==
X-Forwarded-Encrypted: i=1; AJvYcCUWrvnJXsmy5mIyE0TfDG2I8Mgy2JSIkNCMoNtuF7ZIw9Erj9vSZ/4unZX6bboqTSjfp71JLA4Xm/79MsaXDawB5iE+WL5s5GDiD1HtjeyB
X-Gm-Message-State: AOJu0YwufDvVfQ3VqU70K80Iwwo7FUppvadrlX5n+xwJvSj9vBDP3rt8
	M/zi9eYY6IPcTp3QRe2NDOl0Hvv+2DiS/PPCxhhTMjZLamGDLwHHDzWQkpE04vzZn+R6x0lKIFx
	QrTnipLo2lI6tyqlHsFVZxSuaee2jERe3laQk
X-Google-Smtp-Source: AGHT+IEYs9O4Ab1yXvBQtfWhC5ZqPyatv9UEtkAwagoVjMYA+WQEKbhT/qSO3Lxx5Ueqx9uSy89tetRorYJ3R+zsRQo=
X-Received: by 2002:a5b:18d:0:b0:dc6:e75d:d828 with SMTP id
 r13-20020a5b018d000000b00dc6e75dd828mr10375199ybl.18.1708376100043; Mon, 19
 Feb 2024 12:55:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 19 Feb 2024 15:54:49 -0500
Message-ID: <CAM0EoMm1Vff3hLrLEySnL=bfa6vr3BRJd7L+TjiN5zsAY_As1g@mail.gmail.com>
Subject: CFS for Netdev Conf 0x18 open!
To: people <people@netdevconf.info>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>, Christie Geldart <christie@ambedia.com>, 
	Kimberley Jeffries <kimberleyjeffries@gmail.com>, lwn@lwn.net, 
	Lael Santos <lael.santos@expertisesolutions.com.br>, 
	"board@netdevconf.org" <board@netdevconf.info>, linux-wireless <linux-wireless@vger.kernel.org>, 
	netfilter-devel@vger.kernel.org, lartc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

We are pleased to announce the opening of Call For Submissions(CFS)
for Netdev conf 0x18.
Netdev conf 0x18 is going to be a hybrid conference with the physical
component being in Silicon Valley, .ca.usa

For overview of topics, submissions and requirements please visit:
https://netdevconf.info/0x18/pages/submit-proposal.html
For all submitted sessions, we employ a blind review process carried
out by the Program Committee.

Important dates:
Closing of CFS: Mon, Apr 22nd, 2024.
Notification by: Wed, May 1st, 2024.
Conference dates: July 15th - 19th, 2024.

Please take this opportunity to share your work and ideas with the community

cheers,
jamal (on behalf of the Netdev Society)
