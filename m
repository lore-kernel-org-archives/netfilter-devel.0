Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0A923BCE1
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2025 12:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399339; cv=none; b=EPmXHptKXVFZ3RLLDF0cbaC9R/4ZJLXDXAUOm17Mlzb5mziaejlyQsGF3msy6sl7Uvto6FPevXvOvFr01R72iCrQ433S26BLPh6xFkO3EA3ieUyxdqWuAdsU4HQP1UNjU4Pj2IAz8lwlbEJlpX0/RbDB90mJ8Gfrav30GrFOdu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399339; c=relaxed/simple;
	bh=+dqFc7LUWhjiAvgz9H1wmJirUHA7NMdnkH+c7iSAXqs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=d6j2Vr5ZyiRYDSPEz4fSd3SYypn764nUvUnbKhsPTYNbbqQjRICCOWP46lIyTktMu0vYir1llCzBCueu8c7NiN1HrZTr3xQhuxMEY52UXSgODfmZhR8n/dEJ2D9rCPaQjrMjh8wA8anDH1PQJvDn5il3YgfGGS4uc83GKnl4Sts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 654761003DB07F; Mon, 24 Feb 2025 13:15:28 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 651C411009040F;
	Mon, 24 Feb 2025 13:15:28 +0100 (CET)
Date: Mon, 24 Feb 2025 13:15:28 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Vimal Agrawal <avimalin@gmail.com>
cc: netfilter-devel@vger.kernel.org, 
    Dirk VanDerMerwe <Dirk.VanDerMerwe@sophos.com>
Subject: Re: Byte order for conntrack fields over netlink
In-Reply-To: <CALkUMdRa5uRo=j4j=Y=TtJe2OW1OC3sAi8U0kSRx7oZvFoNZxA@mail.gmail.com>
Message-ID: <236795po-444p-rq2n-r64r-n08q0116r540@vanv.qr>
References: <CALkUMdRzOt48g3hk3Lhr5RuY_vTi7RGjn8B3FyssHGTkhjagxw@mail.gmail.com> <642q17p7-p69n-qn52-4617-6540pso33266@vanv.qr> <CALkUMdRa5uRo=j4j=Y=TtJe2OW1OC3sAi8U0kSRx7oZvFoNZxA@mail.gmail.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Monday 2025-02-24 07:25, Vimal Agrawal wrote:
>
>But we don't send everything from kernel to userspace in network byte
>order. Even on netlink I see some fields are sent in host byte order.

Historical oversight? I couldn't tell. It certainly makes it harder
to send netlink packets to a different host (not that such is done
often in the first place, but you never know).

Changing it is not easy either because now everybody expects that field
to be wrong.
