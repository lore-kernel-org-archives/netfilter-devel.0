Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30F5374FF;
	Fri, 15 Nov 2024 01:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731634222; cv=none; b=qnPapH16bquE0zMqb3u4aIgoKALpL9CewYa5EIjDcpbmN5uKZGGwyM6sWFE8J0RDwtOtOlxlT6/gaI0WQrz54XFVoY5g5nw1t9cuuz2z6FQC72+cAA4+tX3RZuWQQt4dJkyEEBG/3aRF9bkISbk7h46JW6enZhfJqcs2B7vNqCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731634222; c=relaxed/simple;
	bh=fTf7rEuFlp3tVd7pNE4f3mFqJW1hNrKxt4LO6XPSTMY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OYWFSY48M8Y/GjU0vRNRKJvKNDj62zYixqRb79hioL9DTLj/+Wyqsig0CiSkD43N4l7aqJWcdUHrpUBBXc/YwZhA6HuO3z6Xo+YnZvC3e+F112t1TdCDXOK2NT8chnuaJaw0Vj03ZocXP6EczsDQm2jhNhKYK3yQjlPjEBF21IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDXoSL0b; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDXoSL0b"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7b153047b29so77944685a.3;
        Thu, 14 Nov 2024 17:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731634219; x=1732239019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTf7rEuFlp3tVd7pNE4f3mFqJW1hNrKxt4LO6XPSTMY=;
        b=LDXoSL0bIyBsaqE4IYtdpUJ/AA0MnZpb8tztCU8cldSlLJ9gdPV5PEJvYhcf69jzkW
         TPPxAcz3DjTwuoL9/zeICKOOilXlths4lJVTu/8mHLprEu+xIqJ+mPude1Jd9SJ6gt3s
         t4X4SaAD2UCzw3jKybEoZgmCOu4iJS7pY3VP/vJAaDrCG4XAkRlR8hypAWQd7q7MG7vL
         LEM1NrJuIrDs2kKtUYEwyR+b8diDLgHAo0AWDHstjcxE6tPede/t4NkqiBqoEYNTTc2D
         agNNJQW/uBJtndZhyL7Wl14yi3b4c88sNjMKXR4tvI9YMcLdc5a2N/iA9pQ0ZrkYYs/K
         A/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731634219; x=1732239019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fTf7rEuFlp3tVd7pNE4f3mFqJW1hNrKxt4LO6XPSTMY=;
        b=hkAwwOrDoAhSTHzIcFSsEU1ei8xi21YLgp+NB3+jc1Pp09gML08jqDI8aFCr409X6l
         WUAhtmCIOtHdDq2h2wDuDtGeL2BAFvOYEGMc9aNDpKYGFlqtxSXp+xszxj0qhi8lKgUp
         BnQoiLn6B2Iw1DjQnRLgH8i8ZjMB6qwhGHdzpDDewj+3sRCKc+j7cEdW8G9qqRbMK4H3
         g/pak000/I0k5BmVDcS9me7sMMQ9HF9Hi8Zx5QOrgxDtV95+lnHqaVUWC1V1kAqYYLkB
         yeJVZqxxvwsvOOxUAGmtVAB88HN8OQ2qzqtClZr8IhQl+GyP/oFOYnRblRRNhXx/Vc2w
         rbOQ==
X-Forwarded-Encrypted: i=1; AJvYcCW38LQxgy2aeixId/JXI+E1JWRk4be9q5jpymq/zAAeB+scgKzp2RIHVCXuO4x6OpvbbZH6TeAVoTA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZLC2xzfhnQohhPrEFH1cUwOEMjSFslsHCYyhZuRINGUywvNIS
	oxNn9iXRSyo36SuUb1Du4n9keiFtG6cRtPlwoXzGeCBXFviRzhYypWVOD+99
X-Google-Smtp-Source: AGHT+IHo+lzY2Iw6tYR7Cgb585T7WW7OwOetsOyFv+CWLnWn3Nc31swGSy8fKqKk48nB25RQNuKNnw==
X-Received: by 2002:a05:620a:424b:b0:7b1:7f5f:4975 with SMTP id af79cd13be357-7b3622f55f5mr150444785a.36.1731634218565;
        Thu, 14 Nov 2024 17:30:18 -0800 (PST)
Received: from playground ([204.111.179.234])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b35ca4d070sm108542285a.103.2024.11.14.17.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 17:30:18 -0800 (PST)
Date: Thu, 14 Nov 2024 20:30:14 -0500
From: <imnozi@gmail.com>
To: Thomas =?UTF-8?B?S8O2bGxlcg==?= <thomas@koeller.dyndns.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: Dropping of the end of a chain
Message-ID: <20241114203014.38526924@playground>
In-Reply-To: <f6857dc4-84a7-4bc5-aefe-c3b893671e8c@koeller.dyndns.org>
References: <f6857dc4-84a7-4bc5-aefe-c3b893671e8c@koeller.dyndns.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Nov 2024 15:01:33 +0100
Thomas K=C3=B6ller <thomas@koeller.dyndns.org> wrote:

> The nft manpage states that if the end of a chain invoked via 'goto' is=20
> reached without a verdict, 'evaluation will continue at the last chain=20
> instead of the one containing the goto statement'. I cannot make sense=20
> of this; what is the 'last chain'?


I believe 'last chain' means the chain that called the one containing the '=
goto'. In programming, 'goto' differs from 'gosub'. Here, 'goto' has the sa=
me connotations in that it skips the 'calling conventions' so that returnin=
g from the called chain without a verdict is the same as returning from the=
 calling chain without a verdict.

N
