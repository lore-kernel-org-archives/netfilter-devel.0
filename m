Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5A9626CE36
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671975; cv=none; b=A5FzBTgawW4tDEnC2W4luj9lfXeXI4Yf93/GCi7WWy0aGRQdWdYDU2UVF3tWXKUp9Mvnpi31utoe+z0yodejciGiA1xSb4Fhu6TIte9EXntuhYNSSso4Yq2XREv+7c4I73LT2qbOMzofQRuHhpeU+/xI383MelAI06RSebUYW5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671975; c=relaxed/simple;
	bh=CdEM95MDS3MiP4+qiTqGLFYvfQVR4GV50ZbmDBooJhE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZWXLr6RDTuxnzL37gH0vjMYPSGwkRQ1P2j67DvXH7en98eg6NNd37cVpa3yee9FFJh7MWsl2RFl1hhikuq0VnJZToXllkyDJ/ugd6iZiddVH8KzzHrx/I6e6jNpBNoQ+47BBqIWdExj8Lx9GntekRkSxUBHvTVXiZPusbGLicCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 407371015FA993; Tue, 28 Oct 2025 18:19:30 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 3E89911020CBFD;
	Tue, 28 Oct 2025 18:19:30 +0100 (CET)
Date: Tue, 28 Oct 2025 18:19:30 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 5/9] tools: depend on `sysinit.target`
In-Reply-To: <20251024023513.1000918-6-mail@christoph.anton.mitterer.name>
Message-ID: <87oq102q-55q8-3137-5377-s74r778qn718@vanv.qr>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name> <20251024023513.1000918-6-mail@christoph.anton.mitterer.name>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Friday 2025-10-24 04:08, Christoph Anton Mitterer wrote:

>As of systemd 258.1 and as per systemd.service(5), `DefaultDependencies=yes`
>implies for non-instanced service units[...]

The explanation is sound, but long-winded. Feel free to shorten the
commit message to simply sy that no reason *for* DefDeps= is on record
when it should have.

I was a second-hand submitter, and did not question what the distros had
concocted up in their .service files. I acknowledge no additional thought was
given to DefDeps=no, and that's on me.
