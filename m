Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EB21C5F3F;
	Tue, 18 Mar 2025 22:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336129; cv=none; b=WX/AbOwN3/Vwcjx9DHRp/Z48GBCfN8BoF1d8uu4FX5tdKmZbaSFpNe5nWkGaQZslLj2zvspABKRqzfh0ObAKdllBBUong+qGTjxmxhex/vG2UtkcWvbLdGRcNGCY6y8Un5PM3oByd8uyWS1xfTccnaTYHN8ZEN2JHPCAcsTvuGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336129; c=relaxed/simple;
	bh=TV0f1pyj4SBaE/WiIgnt/bjow+VWWdSDQezjISQzfjA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H2f6lt1VoctIjsHyLLKgVEuYQOOiAHajbwq9KsHUob/EyWgZcxo37l3sdTPOu9LZkWRJGykSAgizmHxTnzeqnAKTVDaAZARaOdGbVyHD7GyTghCVoZfwTiZN19QXA/qo0BXNigoIYLqdMBfsBkXLQKwCOYj5yn8au6OaFojhnWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lvkjCBxG; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lvkjCBxG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lvkjCBxG";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lvkjCBxG"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C5183605B1; Tue, 18 Mar 2025 23:15:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742336126;
	bh=1cL/TUVdW8AtVi3rJUpmYTAOATbg99+txInbGBQvOdg=;
	h=From:To:Cc:Subject:Date:From;
	b=lvkjCBxGGjfsulizBLil2+HY7WJ9dzua20Svo/5Vapz6zhqdCM2eYU63yo1osWPdg
	 B+1IDPC5blNGRf6DFyy9cQrGw2xQ1gUxF3Q/JsHlV/TvYcZOQiQOMjKQapj//pJiCc
	 04Es6+mbTnxKvdCJ1r59U7N+JP3nUnavKetVwgUb/cxyJE0rGGiNj/EtkmjwDam54q
	 PJjBQhQ6/D2YBeuf3f7baPE45PxX1HRFUJlliIzkmW9wbrxtQlS7n2/Kx3gqyEl2Ed
	 OgOfhpr6IuxWoUBjZCKomVF/pVh9MF9nnkP71VenkxJqNWCJRM6ijoFYsDJnWwN0Ij
	 tCs7J1mjL8IEA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DDCE2605A1;
	Tue, 18 Mar 2025 23:15:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742336126;
	bh=1cL/TUVdW8AtVi3rJUpmYTAOATbg99+txInbGBQvOdg=;
	h=From:To:Cc:Subject:Date:From;
	b=lvkjCBxGGjfsulizBLil2+HY7WJ9dzua20Svo/5Vapz6zhqdCM2eYU63yo1osWPdg
	 B+1IDPC5blNGRf6DFyy9cQrGw2xQ1gUxF3Q/JsHlV/TvYcZOQiQOMjKQapj//pJiCc
	 04Es6+mbTnxKvdCJ1r59U7N+JP3nUnavKetVwgUb/cxyJE0rGGiNj/EtkmjwDam54q
	 PJjBQhQ6/D2YBeuf3f7baPE45PxX1HRFUJlliIzkmW9wbrxtQlS7n2/Kx3gqyEl2Ed
	 OgOfhpr6IuxWoUBjZCKomVF/pVh9MF9nnkP71VenkxJqNWCJRM6ijoFYsDJnWwN0Ij
	 tCs7J1mjL8IEA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.6 v2 0/2] Netfilter fixes for -stable
Date: Tue, 18 Mar 2025 23:15:20 +0100
Message-Id: <20250318221522.225942-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: fix incorrect patch submission.

-o-

Hi Greg, Sasha,

This batch contains a backport fix for 6.6-stable.

The following list shows the backported patches, I am using original commit
IDs for reference:

1) 82cfd785c7b3 ("netfilter: nf_tables: bail out if stateful expression provides no .clone")

   This is a stable dependency for the next patch.

2) 56fac3c36c8f ("netfilter: nf_tables: allow clone callbacks to sleep")

Without this series, ENOMEM is reported when loading a set with 100k elements
with counters.

Please, apply,
Thanks

Florian Westphal (1):
  netfilter: nf_tables: allow clone callbacks to sleep

Pablo Neira Ayuso (1):
  netfilter: nf_tables: bail out if stateful expression provides no
    .clone

 include/net/netfilter/nf_tables.h |  4 ++--
 net/netfilter/nf_tables_api.c     | 21 ++++++++++-----------
 net/netfilter/nft_connlimit.c     |  4 ++--
 net/netfilter/nft_counter.c       |  4 ++--
 net/netfilter/nft_dynset.c        |  2 +-
 net/netfilter/nft_last.c          |  4 ++--
 net/netfilter/nft_limit.c         | 14 ++++++++------
 net/netfilter/nft_quota.c         |  4 ++--
 8 files changed, 29 insertions(+), 28 deletions(-)

-- 
2.30.2

