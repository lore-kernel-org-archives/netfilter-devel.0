Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06BF01586C9
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 22:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724106353; cv=none; b=s6VRBzm/5a7+znMSDoXNsP5b6qOSw5fAkUuYhHPMfIAn7NaZg08NkmttBYa5p5YFUI6O10IAuWRLkE5S7Qf4vjKnAaOlJemhmFaHMzq+mER/ckvxGHjvsUPpIGVkLUTmFklV6a9l3n4Wz1TvfBMdiuZHeNRQnxklf2wkib3LpSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724106353; c=relaxed/simple;
	bh=w3K1Lqgt7rYfCOVJTSxPIOD9faGVOBcNRrW+QtGtehQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fq04TFv1cOF0U9Vu2H5sWOGDX1CWTn8FMKohK7wutqD+pPpvEeJT+Io3Y8jJFNAqcHR5dSKIjHavSeAHormNeSzJrSmpBo5njplxxgy9shS2HMm4FshKzx3mJYe9At7Kp++4U886UOmqGFhJBT5EKlblGudSoNqqKxRcf8BLOBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: sebastian.walz@secunet.com
Subject: [PATCH nft 0/4] fixes for json parser
Date: Tue, 20 Aug 2024 00:23:00 +0200
Message-Id: <20240819222304.1041208-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is a series of patches from Sebastian Walz for the json parser
including one that is based on another patch from him too.

I have split the original patches and applied some clean ups, any
mistake in them are my fault.

Pablo Neira Ayuso (1):
  parser_json: fix handle memleak from error path

Sebastian Walz (sivizius) (3):
  parser_json: release buffer returned by json_dumps
  parser_json: fix several expression memleaks from error path
  parser_json: fix crash in json_parse_set_stmt_list

 src/parser_json.c | 121 ++++++++++++++++++++++++++--------------------
 1 file changed, 68 insertions(+), 53 deletions(-)

-- 
2.30.2

