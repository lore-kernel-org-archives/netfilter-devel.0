Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82113C2FB
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 00:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731456066; cv=none; b=df+1MZ2L6TT1sG2umFgd96aIqBXOktW7sUMccFHl6X8Z0owMWVV+71s4+uLzPTzxIcOoMMDF3LNlXL+RmZSmc9NKBr/WEnJh11VGoy7jC86Rd0Wse3jaoAR/SmpKZL2mqo2GPIzW3xwHoiT6Dh7Wdlad+SqTwiwfvngQxjjbkEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731456066; c=relaxed/simple;
	bh=FoGmaHNM63GqBq0BQy8qKOtath3he6N2gYMwzHPG5lI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=l/ZXiXuZ7mEV0zFxJufW7pg94+xnLilpTN6U4Katbj0C2olsaaUtuOQiR4Klv0/YDyBstNVfx+bDQKzqgv0WlZ1Y5qz4s0soN1+8hL2p6UYVevaG9qGe5RN4o5MGAQvD6Jbm2JVaF1pOsHdeyyAIoY24LQ0zQslUf0ShfIxfoBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=NOYshMNV; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="NOYshMNV"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-720d01caa66so5987926b3a.2
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2024 16:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1731456064; x=1732060864; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FoGmaHNM63GqBq0BQy8qKOtath3he6N2gYMwzHPG5lI=;
        b=NOYshMNVjSOTVgdvo3zfE6mXikzn4pYqNHipj0T21Z3Hebul9xRMKp7a+PtzsHjzKZ
         XalpWnvHO7XPWIqwHoQXHBVX9K7RF+rSzyQF9iW+lRslUFGXvpspzxj36JfvPnMILaJJ
         ClgMLJgafCGgmuBE5k1X0cmnHNG0enMQz9c9mlZD8wjOhxi8wcMf5DtcwcdAjpQBiyQq
         q/iPcgNsM4k/VdpGffIFODf3oOV6u5iYjUkC70Z4DzhYfGu8bZQnhBFOFMG1HNLGjoQn
         kNLzSSZadhtSSVvoVUVQx7Etq2EIHBbt20cykdaPXgR1UGzMpqFx46YUgsDb3qc9R72R
         0tWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731456064; x=1732060864;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FoGmaHNM63GqBq0BQy8qKOtath3he6N2gYMwzHPG5lI=;
        b=nYM5GFImBTqjvangq0+G6kGVJKPL5e/GWU1bayO6RBaK9mPRKbBa4qlicnQnIvRg1C
         2UFADl8kCWtypnLr4X9no7mXIdiRWmalB2uV2SCPqgTTB9h+h1o93qoslRBqPUiAdJ8p
         OJbHikPhlz7IC6TQC4G+iKxK/Nxa3XdhIEBZtE7rmKVNSpVN4WBZPbT3+8HgMlGmjO3o
         cz8uy++8Yoh7dk5ZYTogdJzRp6Y0IGH6DsMhmI6ERZaA/cZNjqZkC9DPPn8xitU7yS09
         KT77axvSMpVCd+IIRxk8qWBaeNSbOrJpDZFqWczs1zH5w42i+R4Jtu2Q8tQO3UeL6wXW
         z4mg==
X-Forwarded-Encrypted: i=1; AJvYcCXNHHetnRPYkvIMF6ZDmoqQsBvZt6u+cOOnNUa0c9RiE6vlHLyM8nyqBpEmsjKFsFDxr1xORT/KjmT3zeEMCBY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz43RWJ6IsV2OLSzGMcn4nICuaxCpqhuAUgBGbX6jJ23NG7E52z
	zWLVZQoq+BkRAqG/aw7rl0E4+6eyQSLxZGihZdW7pEUaw5vvQCR71GYcBxdRuO6iLFLCK5/rLYH
	oPtH0jCwdrMRYXICtFW1BS+6yr+K8lVgCKjWw
X-Google-Smtp-Source: AGHT+IEYm3xrjN3OhpDff0TCYzAQLcLBy7Ie7ujNcFbKW96oksbJ7FAxRHHehy6fUA3rjkmHB85DZUo8zI+0z4ZkvRQ=
X-Received: by 2002:a05:6a20:734b:b0:1db:eb2c:a74 with SMTP id
 adf61e73a8af0-1dc7037a94dmr1440958637.12.1731456063780; Tue, 12 Nov 2024
 16:01:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 12 Nov 2024 19:00:52 -0500
Message-ID: <CAM0EoMmoLXpz70sF6z301OccU-ghgNSOad9cQVhizipy-is-Lw@mail.gmail.com>
Subject: 0x19: Call For Submissions open!
To: people <people@netdevconf.info>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>, Christie Geldart <christie@ambedia.com>, 
	Kimberley Jeffries <kimberleyjeffries@gmail.com>, lwn@lwn.net, 
	Lael Santos <lael.santos@expertisesolutions.com.br>, 
	"board@netdevconf.org" <board@netdevconf.info>, linux-wireless <linux-wireless@vger.kernel.org>, 
	netfilter-devel@vger.kernel.org, lartc@vger.kernel.org, 
	Bruno Banelli <bruno.banelli@sartura.hr>
Content-Type: text/plain; charset="UTF-8"

We are pleased to announce the opening of Call For Submissions(CFS)
for Netdev conf 0x19.
Netdev conf 0x19 is going to be a hybrid conference with the physical
component being in Zagreb, Croatia.

For overview of topics, submissions and requirements please visit:
https://netdevconf.info/0x19/pages/submit-proposal.html
For all submitted sessions, we employ a blind review process carried
out by the Program Committee.

Important dates:
Closing of CFS: Jan 17th, 2025
Notification by: Jan 26th, 2025
Conference dates: March 10th-14th 2025

Please take this opportunity to share your work and ideas with the community

cheers,
jamal (on behalf of the Netdev Society)
