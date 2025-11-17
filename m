Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B1C243367;
	Mon, 17 Nov 2025 21:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763415569; cv=none; b=jUJ6/Xvn9jfE4GMTptik14qy7rl4nIejtXr3atvIs/evf2dBaxnw08gGdcJdASjI+FNpfjXi9IadwnwOp+s4wqqpx6PW76oQconner2V5kpj9S6QIJWiWmaaBD5LS7D4mje0FhpCGQ/U8JFIVcvMfNwJWN60Uld/Uljlmm9EGac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763415569; c=relaxed/simple;
	bh=f/3vybOK+kFHS7PD6yBenlALnIO0WWp0vF+oBT9Nc0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NhtaHGSRGOCCpHL8IfX2pwUpxmpYEPM0OmCpVjlSsoJhSSmpoEbhZlccSl/BdQeQseSqZBOxIuCsrBxqr9e0pUvuFDirfeLsQJ3bKaYa7eclHUaJXdyJLiwV7V96I6KoBY1t7v1WDjeVD4FeqIvjaIlMimpYZLsAk8oXwDCEW8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Gy/uuGH/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Gy/uuGH/"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DA64F60264;
	Mon, 17 Nov 2025 22:39:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763415566;
	bh=yctjzv3RB1JImSRz6fXGGs3iK9QEMAF2bazlj489d3k=;
	h=From:To:Cc:Subject:Date:From;
	b=Gy/uuGH/wP27eLul/6fI3E8gxxLq3lliDD+GgdosB9td5G7JTOiQyqXNGiEcUMZYp
	 Z7zxThiEr1o9T1NLomle+HUyWiTwLIE8vfWWcRPGXUr8stWqe5wxTuAwUVgDlHz+Wx
	 SkgoF+bSoModn5UkwF3tLV3ceAu0Qp36VGZaCaIGEKM+vXNTPfgh+ekC5Gm2iGMzMf
	 DDN+uY0CrgokMJqEzDFwt8i8t6Dq6ozUpVqu0hvP9tuTaOAlvy6aP+I5HZGUFh9BBe
	 YIqg78R7hcp3O/OQ2FxQX+QKNAsUY5zAjMgTzP5HabObKZzxDFQdhWkCXKC2hy0+hB
	 f0zokcvoDbRHA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.6 0/1] Netfilter fixes for -stable
Date: Mon, 17 Nov 2025 21:39:20 +0000
Message-ID: <20251117213921.858836-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains backported fixes for 6.6 -stable.
 
The following list shows the backported patch:
 
1) cf5fb87fcdaa ("netfilter: nf_tables: reject duplicate device on updates")

Please, apply,
Thanks

Pablo Neira Ayuso (1):
  netfilter: nf_tables: reject duplicate device on updates

 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

-- 
2.47.3

