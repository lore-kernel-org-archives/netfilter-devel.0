Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBD443C7C5
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 10:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786444426; cv=pass; b=aa6l9CKBKNOma9CxbDJOMZIEOnqW6qyRWEsWqYw3LOHvr/j80SGwm2WdbOgCCIhiKdjLMOKWwKuO5ZigZXfoLzRUOCXjoPyy0nD0rkpCrPbl4MUnhpcDsZqlT7Zx6w9p2K9tnHIZPVA4WsBlbc0YSA6IBkadVuclwxvQqjWgR08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786444426; c=relaxed/simple;
	bh=yQbZGFh0h9s7+8cS1mdgwrDyPoSg8JGPq3zFUS+Gr14=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WYNKidO77kFXY5vDzBWbYBpJ/lUkV/l2AgX7bx/ymv1bIKXeiTdPCFtJGEJ6JzM28QME+1Qkeu2NP48m/f9o9yvod+PAdOZJd+Sr9g7o+NO719N/1Y1LWztgWToIqMcoRA54kyorIFPCKu8vx8buadz43VCVt6XbwHGKxI9O1xI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lGrx/fAr; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGrx/fAr"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81ed2a00f12so40180977b3.2
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 03:33:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786444422; cv=none;
        d=google.com; s=arc-20260327;
        b=AFjnGdPEj/r+e75G4G7JKPMDOSaUFwy/PjkiNju22dViBO6Mc58B4HOV1gB6iCyyrZ
         s/MQGfikvkunzgOgRbnR+LYPDAhO2RJ4ftZ0h+fCw93IXozZdJaQlfHK//sPewEq0hp2
         zSWbcraHSYgRCoQ/NN2doHFOvV/k+IUlbcdVbtgKTHUamNChb8Ee6/SQNALKxPlZVpZH
         YlzSzH34ReYOZj6Gck81n9kFDM5kIsSEuizFrexMB1FHHzBra3ad0yNQ/QcqUyFhT55q
         6hBwFj4i7pYYsHoNi4xoZG3hCJRovcyfvLhrky4I7yXY5jsfa25+uvgDyUwvVMpRxpqJ
         rKJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yQbZGFh0h9s7+8cS1mdgwrDyPoSg8JGPq3zFUS+Gr14=;
        fh=/PNsMMP7rAwBPc6phpUG9QCZtJ8Y05Ci15Dxz1CkqEU=;
        b=X8vk2KiP+qBzre7tSxCRFdKnoLA10nHxQORDplXa/L0aKAYMY2FaGR2uzvMQPlEaou
         5/tDJYESPi49QZeNMwMqaIQeff01yeEzEWcuuhiR5ynr3FKSV5RWp/ztLXg8Z+qY1z03
         7hCjozqdL6MwAHnT45ix5hZjkcS4zZV9aluSkn5Kk2PzJQnyxv6YN7QSQWI0uimb/jnI
         lPNcUAn6anN0+lj5xPRcbhOShKQBr3iMhN76hMq9DZ2M9dw4Rw1vT8qxDGKJUWavu1+j
         MfZgk8aSINKZbZypwRFZS4KLJbEpLSt8y8IXt7sHS65WAuBdyr997nF0WGlPk4ZEDYWy
         OQ/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786444422; x=1787049222; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yQbZGFh0h9s7+8cS1mdgwrDyPoSg8JGPq3zFUS+Gr14=;
        b=lGrx/fArsR0myy68+zSeTtcDR4uspMMCDoopjSlGnXF+8eWec757LZSSM3zqYx/X3Y
         /z8PLGSvDiVJ88mwE53XcVnKaUPVeDY+Cjl8POLhLxDwhSntdIZ9kbIh1jLzglhOd/pg
         etQkpXdOLjMzs55fhbD/dpaJ+LhipfrxTcEk9AoVJmC4vjD0sXGh13jFpl1QY1Y+ToMw
         1Vl09kZ3KvF/xCnd9J58HsD0G+Zy31OxtpTWtXVVxFLUWAOjrdqFkm84AX5zfiWKu7Wf
         j+0fcweUFxSKuP+BWPD/k7nikMoHw/QDEVwVZ2hwPHiR+djR5z0YCtXiQsg40FfYxA3+
         4tUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786444422; x=1787049222;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yQbZGFh0h9s7+8cS1mdgwrDyPoSg8JGPq3zFUS+Gr14=;
        b=el7QzesvkutA7WjGwgV76LljPC0mquznqNruLvVLah/N74R7rdi4rMbNCbAMvZ8OG2
         XEFTwW2E927gYXP2B+Msqc7FTuMkawrSx+ZOPehXe5ozbMJHJyUHramygLQfNyXrTYh3
         0I8Kiiu7Ftya8CLVmU1GWo5Hs/WVyiOZKdV2vtS+pir8riwwyiLwLbuvuSLoQd0atKe8
         QRq476xc82OVby3YXe9MSsblhT3VW3indK6M6/nORsmHISUy0mgiwfNrzTZa2G+u9kL0
         Q4lAopIo3ZbWvUUqNk18zx7ejmdsjoCQFqFabQIBMozHKV8wRezbASufZggvelzZwqOL
         v/tw==
X-Forwarded-Encrypted: i=1; AHgh+Rqi6iy+ANmDiE11Nmv0XZroFMQ4W2QVBoq6JsvL6+7wvDzIm9J+lezOoDvj5NKzkhKxlACora/Qc/S8s0ndgt0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPQ585502DaRvxt5C+SXtBfQtfjXnQC91NURPXR3w7+fI5Cvaz
	HbZLapWv/KiQ5dFIHHHYV0eT+qoiGki67+WDLeKhQX8w2zt1fwGS6tTKSUCqlSzNG5AwjVknoXb
	mGyPYSje31nUPessjxDfzbipby6wtkmE=
X-Gm-Gg: AR+sD10vQnJecNoPKPMzKfec3QZd41QklmuqjBIGrfwHGODRfRskA3dBUoQ2hzOPEZ5
	1Rx2Zvql4crn9aqeI8JHJUw/4yJmkTlEIDLTNSbYCoWb1W3o1QMfheV0H1IISPyQwW9URXkfzcm
	huuhbBt8WkHexzjhWa88qDZT3H2Io2Wlqfn8cRB+iYwoGQU4Q/gy/t4ZQe4M7DbTq6czsJqsQVE
	fMz/2O6vQ7BiDrcipW+AW/prm4sOKJ6eQGtqpSBuoc/LM7Z/01iv+n+K39SdCP3ty7+laIcCuuu
	sXaSp/mZ6wMXf+6Z6ZjplHcg1cRq/xv/f37Lbq3he6vU
X-Received: by 2002:a05:690c:3683:b0:820:1014:526a with SMTP id
 00721157ae682-82f2df88113mr15247657b3.29.1786444422303; Tue, 11 Aug 2026
 03:33:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANE+tVp8_NhE+KL6ZNPGjaGMLPxrCWw_A5sY0jotrvThB6idXg@mail.gmail.com>
 <anr3YZJrnS_2RbEp@strlen.de>
In-Reply-To: <anr3YZJrnS_2RbEp@strlen.de>
From: Wei Fang <void0red@gmail.com>
Date: Tue, 11 Aug 2026 18:33:29 +0800
X-Gm-Features: AUfX_mx0_SQIjUQgBGSgpUeg4ronIV04joJHHqMJFuc0qvjB6Nvhk6ftzvg81xI
Message-ID: <CANE+tVr69qqyreBbWWk_2FqpMfQAqde-JF=weECditGJF=uZ3g@mail.gmail.com>
Subject: Re: [nf_tables] pipapo: inserting an interval that strictly contains
 an existing one is accepted; rbtree rejects the same insert
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, 
	netdev@vger.kernel.org, k.chen@smail.nju.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Maybe I=E2=80=99ve made a mistake?
I thought the behaviors of these two backends would be consistent.


On Tue, Aug 11, 2026 at 6:20=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Wei Fang <void0red@gmail.com> wrote:
> > -------------------
> > expected: both backends reject the overlapping insert (-EEXIST)
>
> Why?
