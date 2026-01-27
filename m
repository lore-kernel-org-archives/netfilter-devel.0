Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E86D2FE582
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 03:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769484389; cv=pass; b=mdcFECZmEcAWRt5w1wDMF9rNVTOutL5up4FJaJ/n7CtCRLwjQTf0YdcM7uzM1RUVQGeWi5c9lnMwUBZOfhhxnaquhRDK0Km/SalUCWeJKcQFsi8Kd0ugnP6081d70zCKEiNTVloM/FD4i7pcNhqj6UX+dKLWZ6sOupfxDj9tMzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769484389; c=relaxed/simple;
	bh=TgPDz+N7xPqRCVDZETjhUk3bfM+xUP2qP0o3+ocSwMA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=BW7r24l4c17soXp540Sd00M3tSHCvZhZRehKo70LjWeZoMb1XQTBVl1GpCrAm0TQvfale68UrMJraWZQWQ7LJzhFFXhTCgPuMMB43FUl5R6J5dGoOg0xLVfbOjgVSdqqtAjBfLjr7NG1LARA7MB1udYvu1bbKHa7SpV8lAUnp74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dhr1juKd; arc=pass smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dhr1juKd"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2b70abe3417so11741135eec.0
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jan 2026 19:26:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769484387; cv=none;
        d=google.com; s=arc-20240605;
        b=lHqSt7zgw4Kc66ohkiZkySBcavxzx7Nq2waRq69DLYRgdcbu+LxnCscARNwN6ruGDG
         jw8vETt6frKWge6xWbnRbpuPFdnZXiH6KqL1RN9Rc3aKsCyPVTePcz+AqXM/NsgC20oB
         bvlyswko0t9813fD8ZClni7tYALusEatwQQ/V5uMxXm2biX+P5lQtLTNXN1nqWvQZzVB
         HsM/nVwl5mfxYkpzDFq3HJtEfuxb/hkz9YEb89TyGvPyyV7UN66UHL1ACeNhHDvrKGDm
         Bv5N9jdepmxR+zhJkH+4oSyngdw3hTMCH4hQRTPoRsRWXeQFRmo3COwuFarpA1wibvEw
         ZxAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=BpRooRzIG3q5cO6zqoFpypS5yXPD8oAVt4zCD9WCqM8=;
        fh=94XZ0kbhVmGEa7CVQQn7x19t/0l9HgwgaJK+mk7Jllo=;
        b=erL0IGKYypxTGr30cKQkFyeog+rNUgSTg4bIAdxce5/Q7ABP4N6/K73AJ4rVoMJqN5
         K9TeNjgFFXWXIOPDv9FBpllpax1w92G7WJCzSvT6v5x/Hk+4+A8xmqlbFHpgQygRio5n
         KiivAzaWKN3OUiN0FKywESxc8O7vKGRINht8wA9p6yLX45z7LMzzpEpAD1TeOBBfYhIR
         U+79hSmsKXtY4G5mjCuY86KpCAUILND/q5zPBLKJ6NDtKWITHlhoDhvFucbNrdSRSBj5
         b/gV6fgPp0iYA2vTFAu2Xfc9itf5XvutNvJHJoPXVLc9rz95L0BcdDyZcagwHu7xoAW/
         xUMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769484387; x=1770089187; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BpRooRzIG3q5cO6zqoFpypS5yXPD8oAVt4zCD9WCqM8=;
        b=Dhr1juKd4ACYeJ+azuSx43V1AvJ3D9NB000WyS97jy+C4kS6d4MCrwtqjvlqpRCux2
         PzrNQSyfAnmvHT8aAsD9kTN7b7JeWeo+a+Jzs9NPO/+KQhVSfKBRBHO7TQ65E3IZ6KyX
         mpE5I5Sx1mt1IG1P28FffMhIk4jAm2YWXgJ/E3cLMb6L9GIox9CuyNWfVzlfGaxNVBdC
         J91gl1PSl0F0vnyeOUSEa9lqooDa8ZlNjiE8gjHxWEM4bPIB3/WSQ7UsBcKeMkp4fXv1
         WlrB7qc8tnzUnHmQuExjFtXu7rB5h6Va+qqS+qXDjE9BfffS9/4WGlrU0SrWGQ5R6OKe
         xjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769484387; x=1770089187;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BpRooRzIG3q5cO6zqoFpypS5yXPD8oAVt4zCD9WCqM8=;
        b=Ynd73n/QyuJXKOFhm3XMxYR4yI1QZKTf3yRW1xTlMaTIZrF9CFXzf/uTtUblO1zijz
         badZrW4GIEzu+q+ytk4l5bwrt8b8+A0I6ZzUfwrqHTmgEiXxPccTjHdCa0Y8MjA2O8z9
         4wTP3qZQSbSf1LdeC2JilCTjwGHLTjT2Zs2PEJ2y1acV0CrnbJUziXYycHGGxv+T6ken
         XkjvPh3xVfTVTevTuufPk0ZZzYh6YJzdywJN6m8fAlZtVeJm5nsjgY7KSedHksvTB4dv
         gfo2TpTDnGv+q0fCvr/nLdZC5X85jBzvs+lQOJswGyTURSVZj5Du7K63csAh5hE2kMcR
         mhdQ==
X-Gm-Message-State: AOJu0YxNkDTX37nmorC5EpF8xV7MLHJNFeE9Gqs2JBBpaJkfy3IXPdjA
	rBaGIv2FdWZ4XOR+mKcTUSYOJPLkVq7fZYbnroiCyy6O2wIuC/b2MkFw24r/lafmco9WHW2YGZ7
	4W8B7FTG1Qgn9n6rxbSsCGp2rnIfnwUViPvRN
X-Gm-Gg: AZuq6aJ8UHMdnNvAoi1MzJDWrAK8rEy1hvnzbRVSAV6cCIgfWUJC/twJxzziqZIniyU
	QBSTPbgJl5sBmsXFYSqEt+k4uley73yi7jXGfTz1nJwoT9JKb0r98cgTZsl2m4WPVMKlJ33h1tu
	czm/fQJVZJPb74fp2emMCKdgIkPjdIKAjZtXWwZ5OBhtfyMLvy9dDKJsul2o6SsfgRL8V5XDacN
	EYlotenOKCGdTgGdg6LooV/pN3TPW8u5kO2Atb++5Im6abMM2IEICHAyrFJuMMl6EM5AWGbeTQp
	58OzHjemp9cIdr0rDJul4Taepg==
X-Received: by 2002:a05:7300:cd8f:b0:2b7:2ce1:3e9e with SMTP id
 5a478bee46e88-2b78da1a306mr286747eec.39.1769484387362; Mon, 26 Jan 2026
 19:26:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mathieu Patenaude <mpatenaude@gmail.com>
Date: Mon, 26 Jan 2026 22:26:16 -0500
X-Gm-Features: AZwV_Qh3dQXU12rTe2o8vLee-_1LjBL6syYNDfTA2f6lw3xvBsjnZ7UX1CLmieo
Message-ID: <CAJ-1uKHCK_yGx7WUAyOpoTn5QJFhu5khG4W17Foj_3ovgTjPwQ@mail.gmail.com>
Subject: nft bash completion
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Just inquiring to see if there is any interest in adding nft bash
completion to the nftables project tree?  I only found a reference to
it dating back to 2016 (patchwork RFC), but I'm unclear if this was
ever merged or if I'm just looking in the wrong place.

I wrote something that works:
https://github.com/mpatenaude/bash-nft-completion/blob/main/nft

Let me know if that can be helpful.

Cheers!
