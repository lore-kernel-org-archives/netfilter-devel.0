Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD6C1854;
	Wed,  1 Jan 2025 22:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735771635; cv=none; b=d+xzV8krx4bA1kVCZz1uBmo2YvxpPLSgOVjY92dVZApZDlVT+qcjro1v+LYEdKyf9pPUL4w6S/YF7Lb2HmdMR1sYnOF/BZTzN99OWrCyQuwqyVmqlyUsLNCskDnfRTp+op/KEgn5QHasdGYEiqnUIprrOqX+NAa5MWsD8j5EgsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735771635; c=relaxed/simple;
	bh=ahd/QJO6Q7as529L+v7oNJmAI0N7zxKISCMqjqOWR6g=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WmYTzm/c7qtnW0IABBos5hWQ9wcrpikf/AU2OMLMjQEOoRtCPk9nsf4MsDdzLr61IUMwVCjq8h20NxCx8ul3xoygAfUpAXnI2xw0uDxzvtsU0NPrCVGxVKiZIjC9XLTRHcQYf8j1mWlJuw+m94dm+aqOgqIETxm3vf69lI9zLKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 06C081003E7EC7; Wed,  1 Jan 2025 23:37:40 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 04F031101004BC;
	Wed,  1 Jan 2025 23:37:40 +0100 (CET)
Date: Wed, 1 Jan 2025 23:37:40 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: =?UTF-8?Q?Benjamin_Sz=C5=91ke?= <egyszeregy@freemail.hu>
cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
    edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
In-Reply-To: <20250101192015.1577-1-egyszeregy@freemail.hu>
Message-ID: <66s73o2s-1959-7r33-2509-q0s240545263@vanv.qr>
References: <20250101192015.1577-1-egyszeregy@freemail.hu>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Wednesday 2025-01-01 20:20, egyszeregy@freemail.hu wrote:

>From: Benjamin Szőke <egyszeregy@freemail.hu>
>
>Merge and refactoring xt_.h, xt_.c and ipt_*.h files which has the same
>name in upper and lower case format. Combining these modules should provide
>some decent memory savings.
>
>The goal is to fix Linux repository for case-insensitive filesystem,
>to able to clone it and editable on any operating systems.
>
>Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
>---
> include/uapi/linux/netfilter/xt_CONNMARK.h  |   7 -

breaks userspace.

See Message-ID: <706544q5-q0o9-8sq0-9q14-onr01r8rqq5q@vanv.qr>
for how it could be done instead.
