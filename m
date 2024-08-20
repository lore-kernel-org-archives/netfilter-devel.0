Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F148B18E345
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 08:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724141214; cv=none; b=ALbQ2dksJN0Xa8eAv+jBFuDfC/w9GZ9LujhM+Eoy5FL2217KQfVLcYjQXRWY0OhSKV+ZtgbGbYQrr7StljjkLrfsX0HfGPWzlbEi7LO9uijTK2hbVPQV3p9tYAX1GghjCBfPl5REPx/tq9ZBJYp1B3Ak3+/LJVLh/MytQg0I0gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724141214; c=relaxed/simple;
	bh=xEYCGoCVWRTlScME/XQYxh3creE6xWKt+vvMF4dPfd4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sZsXswjymBs8m+vhuQ+bZuTw5uW9w05YjV4IeLA9MhF2igIFBiT4gxEk54jsdAHFeG6KdHUWEA7dgPZ6iWnJpk6yuBpreGFk5zCoXP4LSYupLpl0oqz+QLx/vvpdYThx2kqrN2LqpU9+ahjv3sb91lp3qF3mscmmErba6h3+Uh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=YcrPUXyl; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=H926gqKk; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="YcrPUXyl";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="H926gqKk"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1724141211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xEYCGoCVWRTlScME/XQYxh3creE6xWKt+vvMF4dPfd4=;
	b=YcrPUXylmA/hfaVm21+KxlAVqwF8pgAX6Wufbd0igCGoFm+RtOzwamM4aOF8042+v9LLal
	xLd81YArmmrmG+ukRX7N5UezRqW1mDkG/T/1Xyscgjo8bVxw0SWzH7oI+X6pMe3g4tB5XV
	9bW7CNmB57xgXwwhs0L6iWhLWp+SufNUYtWF1sCR6IkQ5JlnRBvvKzFt8RHmUfitbcQg6B
	YRwmpMKvayZQYA2h6nIHtERqkZkuGD4GPTdTzZZJsI4Mplvpuw8bUuGZ2/zoIr8C4RcUln
	p0ov3Vi58NdC9QFy9C6wHRGXRDHrnUjsjSvmOEbGFo8LfJVLuS9jza22ttrHYQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1724141211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xEYCGoCVWRTlScME/XQYxh3creE6xWKt+vvMF4dPfd4=;
	b=H926gqKkmWlaVs//bUBr3AitjR8RdO7CxInrQ5covR5MRTlW2C1NSWxph6D8XEUlCaEGGS
	qz1occ+1zVpY+8DQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net 0/3] netfilter: nft_counter: Statistics fixes/ optimisation.
Date: Tue, 20 Aug 2024 09:54:29 +0200
Message-ID: <20240820080644.2642759-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi,

I've been looking at nft_counter and identified two bugs and then added
an optimisation on top.

This is just compile tested, I didn't manage to trigger some of the
pathes I changed (especially nft_counter_offload_stats()).

Sebastian

