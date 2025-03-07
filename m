Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC83184E
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 12:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741352205; cv=none; b=KHr6IEQu7oIMfUvX7T748wnqxyY1pMAdCJPYrFckXDj8SQUVfVbumW23itosLq4fR7MbnvfDWp58ZT1d5mYReuGqNvSalrSOt/ZmGm3V56r01M3pInJTVmAjSU8MPYyDmTsdAIWkNtcFFrwV0y4dH5a7IYW/ZFsK5FM5NeuTxAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741352205; c=relaxed/simple;
	bh=+xnuCHpgXqxzHESj2IDMsVTY2ndP7sWhfZsrBWya+DM=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=cIB2rfMzXwVQyvD+pZLp6U3Jgp41edmMmctByJpI3HMTf3C0KN+dQjQMcmgrGQIMDxcMUYU6CmLM7pNY8LZAhpyh9ODL9XKRJXX3ePBwxfXg2a+LKmFlWMu9ZIAD6w8HdlhGqsanIBhM/yGdrHeBjFSo+D1gOR0/FpGyDBk6MaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MKQ6c0aX; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MKQ6c0aX"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5497e7bf2e0so1963712e87.3
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2025 04:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741352201; x=1741957001; darn=vger.kernel.org;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZPsyMKCSlPp9U6mvvh9KAiGSvuOwxYoel69p//w4U10=;
        b=MKQ6c0aXHHrFHzo0EPVIHLi8LgUOBbgIQ6k+Hq7X+twRv7UFw7/65bXeYG9mJ/hB96
         GnwogK8lRKBqAcGRf7vfgf47U4oNZ5/KBMwdpKJdceEON5dbCpCOdQamIP3UFobyxw0a
         2xFg2Y2q1LfThmVpf/nT8rrzAjOiybYviurdhMq/eS+xN8aCZvql/wKsOKrj1FYF8Aib
         lO3q9iZhtRENDZX4BeyBqNI4emeqzjNcDPqe21I7bedYQgkQdvJJGPztMOLnqNgVjU31
         xpFoLU2aLdhw2E3qRA40vLqMUmnP3dBke8xHErEc9valsfyfYx//t3RgoQIs1ajw7+mk
         CP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741352201; x=1741957001;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZPsyMKCSlPp9U6mvvh9KAiGSvuOwxYoel69p//w4U10=;
        b=eLWr7sOSFcfjHAw2OT6+3969/xs1G8oaT5eivo32y1TckNG35aY3RgSXdH5FEu1lb2
         ta8LK9dGMn5Ib2aGkMtydctYsZ3csy6IynEh20T4WZ65h5jVsmmmniSuNbeyY3PIPBR3
         77mT9MP9QFPr8V1iybb+aNQAVQtsWQFMrlYB97otr0HooYyIvHOOXLjdlCbwgv4JDkrW
         W6OPZxsM5LhFaNQ4U0rtdg1Zhif3d/SxsYpLNWZmupooZVbc8TXrnm3qTCWET1dpwTmS
         6QktZ5xrh8CH4a0guampHrBgMP5s2JoE05yiK3PduPzNUKxG/0i89e9mgDjolECvXe0V
         wZfw==
X-Gm-Message-State: AOJu0Yz4Zrz8IX5qXRVl6cKcWjTGZP5I/iCjJZwAiHhs+rFSwsSyspTc
	L+JohFV/6mdW6ohyJVGXiwsDEsgGuly3Xlt6VTWpEC81vSfGWuBvnSpO5A70rs0=
X-Gm-Gg: ASbGncvpTenNvHSVQW2y6abdSMiJK+88rsw25gXD7bxvRgRqZ60L6lnDMcU1F+fQO7K
	zH8NII2sC+2NyUleLLD/WAJqc8XDik3JO431V6WcWoATMSrRYAFPE/W+BVX1uh46gBsBxAxtWqi
	A/lgbhcJiBT+2NYgk8+g6xCAaoa6Oqj9JVxfjI7Kh+qwEp0bdBQO2nTjrr3iBE5hd9qEoKn+3xU
	M7NRbRS/8AQlfUMKL3XUPWsNsV9VPXaruBQeWqwwR2eKe/iW3WCHtjTRiJTrkqCrHx4T4zASZkX
	L1EdcG9prAKnbZO2YsAmdQkk9yas0sVsfOFS2TpKTOiuFhY27JnmC2/Isko1
X-Google-Smtp-Source: AGHT+IGY3UxzP/XIRHRctI8IAHKh99i0wBiANhwB1m+5hRW4Ic3zImeGjrVvnY32eieE3l594XyQIQ==
X-Received: by 2002:a05:6512:ad1:b0:549:8f47:e67d with SMTP id 2adb3069b0e04-54990eaaee5mr1147503e87.34.1741352201130;
        Fri, 07 Mar 2025 04:56:41 -0800 (PST)
Received: from smtpclient.apple ([37.99.86.132])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54995d86ed6sm66014e87.188.2025.03.07.04.56.40
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Mar 2025 04:56:40 -0800 (PST)
From: Alexey Kashavkin <akashavkin@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: Generated value for filtering from two arguments received from
 the command line
Date: Fri, 7 Mar 2025 17:56:29 +0500
References: <AA705D8C-131B-4305-81A6-840C38AE6E54@gmail.com>
To: netfilter-devel@vger.kernel.org
In-Reply-To: <AA705D8C-131B-4305-81A6-840C38AE6E54@gmail.com>
Message-Id: <2C2AE2EC-8862-4ABB-864C-78467E668575@gmail.com>
X-Mailer: Apple Mail (2.3776.700.51)

I have performed the required translation in lex (scanner.l). After =
receiving arguments from the command line, the required value is =
generated.

args_for_gen_value      ({digit}{1,3}{space}{digit}{1,3})

{args_for_gen_value} 	{
	unsigned char paf_field[14] =3D {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, =
0, 0, 0, 0};
	yylval->string =3D xstrdup(build_paf_val(yytext, paf_field));
	return STRING;
	}

Hopefully this will be of some use to someone.=
