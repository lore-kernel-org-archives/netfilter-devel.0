Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BA61F4161
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761672264; cv=none; b=uRgQr+Z+wsTi1BT3k6V24CmzUJNAUiYDhsxVMULYtjyHdhR3BK8hQ6+ivNs5R1/JoZ7q+K4iLsJ3A7y81v3fGpy9V4lekNJMp3BeaF3ifqP7y2LgV1UdFOi5ejFgLqOZKrHCmkAbLW0pJNOU1rjt7VAd3zECqJaJMvWF4l4tX/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761672264; c=relaxed/simple;
	bh=EkuAA5Z9cF8TWElEis+xAgeAwOk9ocodRpr/P5UxIag=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WbK6O3e2OlMfH27g5TJD1DH7ulStFT5yB4lhbjZKr0n/dF+5WTBOmsMCmDTFgV3btG/qsKx+GAH7F+8ZKD7g7+BPQpGS030ofyy5bWD8pP1WSc3LWmEGrm7b7Vuj2XWS79/vvgEpr/whTVjXtBZi2HS8YYOxmgkElgW/f0b76ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id B5BC91015FA992; Tue, 28 Oct 2025 18:15:33 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id B3B6311020CBFD;
	Tue, 28 Oct 2025 18:15:33 +0100 (CET)
Date: Tue, 28 Oct 2025 18:15:33 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>, 
    fw@strlen.de
Subject: Re: [PATCH 4/9] tools: reorder options
In-Reply-To: <20251024023513.1000918-5-mail@christoph.anton.mitterer.name>
Message-ID: <n15q6p6p-1qsq-2pr3-r2pn-339n568nr9r2@vanv.qr>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name> <20251024023513.1000918-5-mail@christoph.anton.mitterer.name>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Friday 2025-10-24 04:08, Christoph Anton Mitterer wrote:

>This groups related options, orders options/groups by importance and
>separates sections/groups with empty lines.

This one feels unnecessary, and I do not think there is an officially
supported order of directives.
In addition, the file should try to stay simple enough that order
does not matter.
