Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3142396B7B
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 09:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770109871; cv=none; b=CJaRs//OT4KJEDM/sEEY+bBwEvUfCPreZqj+tckyb8p/WfIvs6k/k31vuda4SPWFdliRIv87+ytZ7A6DgNDoWV4g7DQIIXtcqoPWNdNvy6Op87V2CyZYrMNxHBHHQySSeGah06YjxvUzVv/L4eg/4ixwCHj55kY8TsNRlGW3L3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770109871; c=relaxed/simple;
	bh=cfdU1kSo8gBSVmXxXxV+VeJp31P0ZwNjDc7NslD7Etg=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=R0Atur1RdsW2DfEvG1e8N5NHzfmgJdxEoQE9N+MAhSL/4ptmVEBOg9Vf0FEruDp46rnUDIYFIMnWBHbD3/uoV03f+BPFzLvVClQmUzT/lHDxFoTKSQQgrTE4nqLiBpWnTfkmLASaXXe6lBqXCr45CH9nGQM4GzF5+EfC8vvZnIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NrpWvaUQ; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NrpWvaUQ"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65814266b08so10647275a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 01:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770109868; x=1770714668; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cfdU1kSo8gBSVmXxXxV+VeJp31P0ZwNjDc7NslD7Etg=;
        b=NrpWvaUQ7ZMI9gIow61dAaW4Ip7by6kXP9mns53l8SYTiJpJ3xRC2CVHYNWuWBVT/q
         8Qj0/oyvoqt+/2w1AeAvmQQRce2E5PXsJThn5RI+Olwo7VvXwmclR85KRq3oIoxWbduf
         f/3IJxns7vWqYy8JK30LrO4dgubIGk7vV9q/yELstasx9PvdVN0XSFVEUjen2rS26eXG
         rXlLJq4zCzUTshwIcOEQRuGlORLqIkwubzL7CgegZFFrF1HR1M2pXtWyIZ7eBYkSTzBs
         PxD1Kv1GAcl4fehwcAERT1BEsC+yQWzoXae/tbNJbU5g7+QVfOrL1FetJiaaxdbJwsjS
         RL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770109868; x=1770714668;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cfdU1kSo8gBSVmXxXxV+VeJp31P0ZwNjDc7NslD7Etg=;
        b=wpU5MlyZauUzpzRIpI1rZ8gMAHQejHoUO4Vb/EoVFyILNT35ty4IcnvWHOTENtNoia
         iUeqcVWfONOyNIpGyczyqwyTfrg5Mh2n6OEqZdbhhOkBwbAVwezy5wf6KlItsF73CFG3
         ioS0woegH7Ubce1++6GG8nDMlAH289wNZlPJtSYxhk9nN2dHVtjyIrWxxU4m9djhXFLF
         KgIU6h4EnMf3d4OOWdreOtsfUsX6bJ9kKa0Yap7sz7DLC10iVwZMwZRbHfBXh3DPsE9T
         QNkV6JmLx6q3X8Bals2uqPf+5ZB7IkJFsc9x/uRsL3BHIbdCnbQVrpyZ/ShBw+vygIQP
         yxcA==
X-Forwarded-Encrypted: i=1; AJvYcCXPJq+jcQ4z7VJ85MFp60XnKndpjNtreRbCJAs2U36t8rqqsniFZPJjv6YiacQ8ab24Wi+3d4NGgLthFs+zku0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqe9C/FgDysWXVOxKOQonr3LUVaAwvTD9FpEH/yPKgX3YZ+5QL
	sP4qCHAy5KGswO1wC/GqqIK63vR8/yE8/oNZLFY8jkPtRsZ9oVJd++Gi
X-Gm-Gg: AZuq6aKElWBm7aWikvCOVy2hEoffbqEcx8wK8bra8XSD2f8mGmIZiJJwjMiik6Wu00B
	u3Xp9EY9Tlk3fetoBayzhtmedLc3VgQQ0TNB0VS2MTJXGxRRQ5mMdGzsT4UIXROgMGqWKmTVzMT
	069IG4IJuknxyywzjXeHpSybDw4l5CcFR3bRLqd2Eqf7aetegpV7U/sVb/6pqeowU9REUtJOkt9
	qGNBz7f61J+qbhiLO2yhtSEFlpx2JMG+pIQXXhYtSnvS/MqGc2ZKqp19zfbvrVYxrZgsLcHfQDa
	/yBkT+gY1Jm4Yu2C9CpVUlJ6CMITKi6NhsceYKeTYRLhAtFynBdDl0NC+MMeHVyyBA4fKQIvKdp
	gejnj7AUb7Fd8LW70Jub8Nn/3jghkAr/y00NcgmCUpiXErvZUaw7O5j+cJ4Pc+13xm8/hmUZEIs
	EkjmmJ6SdihnjHCciyzlQ7EBU=
X-Received: by 2002:a05:6402:50cd:b0:64d:2082:d027 with SMTP id 4fb4d7f45d1cf-658de5a2f83mr7948742a12.29.1770109867713;
        Tue, 03 Feb 2026 01:11:07 -0800 (PST)
Received: from imac ([2a02:8010:60a0:0:c42b:3329:fccc:c347])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b42563dbsm9307740a12.3.2026.02.03.01.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 01:11:07 -0800 (PST)
From: Donald Hunter <donald.hunter@gmail.com>
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>,  netdev@vger.kernel.org,  Pablo Neira
 Ayuso <pablo@netfilter.org>,  Florian Westphal <fw@strlen.de>,  Phil
 Sutter <phil@nwl.cc>,  netfilter-devel@vger.kernel.org,
  coreteam@netfilter.org
Subject: Re: [PATCH net-next v7 2/5] doc/netlink: nftables: Add definitions
In-Reply-To: <20260202093928.742879-3-one-d-wide@protonmail.com>
Date: Tue, 03 Feb 2026 09:04:05 +0000
Message-ID: <m2jywu9p16.fsf@gmail.com>
References: <20260202093928.742879-1-one-d-wide@protonmail.com>
	<20260202093928.742879-3-one-d-wide@protonmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Remy D. Farley" <one-d-wide@protonmail.com> writes:

> New enums/flags:
> - payload-base
> - range-ops
> - registers
> - numgen-types
> - log-level
> - log-flags
>
> Added missing enumerations:
> - bitwise-ops
>
> Annotated doc comment or associated enum:
> - bitwise-ops
>
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
