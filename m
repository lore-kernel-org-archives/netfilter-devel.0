Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC111DC9BB;
	Wed,  4 Jun 2025 23:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749079709; cv=none; b=hl88dUD74hPNzFavSQ3V0Lpq3bOrhulN+JJ7IodUFecd/nDGSeRqm3FGoZFLVzwTvc8zhq9B97oh6ozm+03vSTYSQG7Cy40NwkJfGe90N28pBq7g4v95fRoGC8KcnSSXU+w5ztMChUMPI2KY7wOAH/JIdBIyFfatASfarvKj6jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749079709; c=relaxed/simple;
	bh=OSPUNvPDIA1nHg5uaxXSJTAlsvo/lC4UnHXIirwcXwM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d9SL7gHX2Ani7omeoWOuLfv6V2ZPvs1fJzHC6314OnpeyWmXs8E5TDg0BHAxgVM7IX0WhmhMR2vwfJK7IiMknykBg5M+lNnxddOSD16DOhQTywUnHfQ4cScPVAHcbuRzgwXyt76ZfQTDS/hjzePvqlZcgSDjJvPfOZcAvGiKznc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DDTCqxfb; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZOUMlveb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DDTCqxfb";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZOUMlveb"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 76CA26074A; Thu,  5 Jun 2025 01:28:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749079704;
	bh=YLVRmcN8n2kXOKhPPXv3+o050qohmrb8rJ48A7e1YZA=;
	h=From:To:Cc:Subject:Date:From;
	b=DDTCqxfbEYQSUtuRKN/wgLkmw6SWSNzI6cZCYHWJgrTp9nEXmx4GfYJlDXpHmCTmw
	 g4x2WreNcuUcajjBUWACndUydOMUV/iev5R5hTuyVGdCQxRd2+jO9WHBs+o5TrT67I
	 J0Wa/rcypzSuxl/T7d+tR/DkBloQK+QTINCDgsaRNrchhNqBD1fIs/ATDacGGcy4BH
	 z3zaFO1a4ADjV+xAJrndjEt+ONHHcf8asXdus+De/4ZgwZsUsSsHaw0fmSTVaGKrFR
	 ffCxS+l+NtaVLvXmcB5XVLyEzJ4sivuF5cJ3TfMPiqMcppdtaz0kQXgZKeHVzgxcRq
	 JRlPob6B5sE4Q==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A6CAE60744;
	Thu,  5 Jun 2025 01:28:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749079703;
	bh=YLVRmcN8n2kXOKhPPXv3+o050qohmrb8rJ48A7e1YZA=;
	h=From:To:Cc:Subject:Date:From;
	b=ZOUMlvebigWTCx6nIUx5zFonv9gzZWW82Yrpyx+b3PrfY0+LrlctVclLrJNFaweoi
	 cy28b2JUQj9OQMwibru6JNWkDYIPN1z5rUkBrxrcR50KgbRbuHHegICm647na90uZB
	 MOVrhdOzBq9WsBeOX8hmbWtuy2JVevGzmb7L027zYJW8doCZceDZxHrn0elo9F/lQU
	 wqJ1RzEakPulqoQdCkYIPhg4WPBvZiNm0S2QOD64TvRrZesKXS58zgmr2blK9ImKo5
	 +/z2gGOYT4FQpkeU9+0qLX4UaKGtkL30uBqsZFboQ+wFWe64Xe/q0QiP6DRq5C+Oxf
	 GY55afx8I14XA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.4 0/1] Netfilter fix for -stable
Date: Thu,  5 Jun 2025 01:28:16 +0200
Message-Id: <20250604232817.46601-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains backported fixes for 6.1 -stable.

The following list shows the backported patch, I am using original commit
IDs for reference:

1) 039b1f4f24ec ("netfilter: nft_socket: fix erroneous socket assignment")

   this is to fix a sk memleak.

Please, apply,
Thanks.

Florian Westphal (1):
  netfilter: nft_socket: fix sk refcount leaks

 net/netfilter/nft_socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.30.2

