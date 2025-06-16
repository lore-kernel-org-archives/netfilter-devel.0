Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048D22222AC
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2025 21:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750111058; cv=none; b=UeHcrov0FyUS06BREtdMyioeeHN018J7NuSchAvjcKbPIJdFWPQTiCr6eK9YhOFV7JWhTQARQq9/hCT6ZJ9gSfr58whI5IbYrLDdD9xUO3U1SkSffjDfPyFtPs247F1RUpyRucaeEdlID0BFYNFhHvtLh3/bhNN0C5p/t64yq60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750111058; c=relaxed/simple;
	bh=mJILJejdca3npoUYA78IMA+qYPa+7fro4DJiOiahH7c=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=otFMw0f3OSFKr2Vm0BJje14sIK+3FLtp7cONPTlbLxGPKUhHqyf0TIsQzvOAJVZCGb2w4cVfb7WnLzp5hZdnnJ1ABry7vv3VK1ZpmyPoXkpGWlyWDCPMLgUo067InrzVhHsPwvWZUu3ubJ3dTWDzIOVQFlzejUJ3O4/LinJqqRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SaBq6McJ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e6y3NsKO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SaBq6McJ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e6y3NsKO"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0932F603B8; Mon, 16 Jun 2025 23:57:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750111047;
	bh=xADV3pSc8+jqGKJnySZn6VuVz7YJ2DAH9A29w7UocSQ=;
	h=From:To:Subject:Date:From;
	b=SaBq6McJGBgWjOp2XnZmxjdjszHHFpP4CcYk0DvBDHquPY6u05oW3ZUgnXtpOqPKD
	 tykTlaNOZzhzLqedW63goQpipZCs8qXKgED/xsGWXhUK/KU0F+3vYixAzyBAc9adDX
	 8DL63OAyW+e5uRaXL+M9ch8uz1RmHdcL8domb+XQ/s7K5R6WApOw74cxENUH5hFzz7
	 Dh9xtUHX5Af5Ac7X+pQARqTxsA/Jb8AtK/x5ZqVtzUhFP3DKFLjKukG5mCYEij68cB
	 LJZ7CmdJYc6meQYe/+ZTl55CxPRuacL84fSD46sPV1YRkzxrdTuKHDd2apS3Pdw+JS
	 ltkVuE9s/9ohg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 67800603B6
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2025 23:57:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750111046;
	bh=xADV3pSc8+jqGKJnySZn6VuVz7YJ2DAH9A29w7UocSQ=;
	h=From:To:Subject:Date:From;
	b=e6y3NsKOtx2cCkS6pJUUVEfYwdCLN0cDsE1bIcySVdNjK7TMkXaAmDfAGeU+ov3l4
	 o4gqiILMKDVpa+k7cBh198rKaze/4Sjov15RavKUDhk+aqFHaU1f9HewZUsPdkdEx8
	 bau9HZOFMn0kb6tsxG6/GzoCwfSemb6GwzTbMxf65Xyl6hWXnVbqf0T3GNyhVYfGws
	 KoLg6J/KlUq52ZUbksOZgxxfdgC5+sHu13mvZJARswv7V4fGFjTsSKg1j09ghnL8G+
	 KLBa32TiDn6A+yo3FPwhVcaigBsrkuQA75725MaLBdTbsG9S300aYaoJuOjhObq0CY
	 kQOdLvDxVRhhw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/3] memory reduction in concatenation and maps
Date: Mon, 16 Jun 2025 23:57:20 +0200
Message-Id: <20250616215723.608990-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series uses EXPR_RANGE_VALUE in maps to reduce memory usage:

Patch #1 reduces memory footprint in concatenation of intervals,
with the following 100k example set:

 table inet x {
        set y {
                typeof ip saddr . tcp dport
                flags interval
                elements = {
                        0.1.2.0-0.1.2.240 . 0-1,
                        ...				# 100k-1 entries more
                }
        }
 }

Before: 123.80 Mbytes
After:   80.19 Mbytes (-35.23%)

Patch #2 remove EXPR_F_SINGLETON in EXPR_RANGE_VALUE that is required
by next patch.

Patch #3 reduces memory footprint in maps.

With 100k map with concatenations:

  table inet x {
         map y {
                    typeof ip saddr . tcp dport :  ip saddr
                    flags interval
                    elements = {
                        1.0.2.0-1.0.2.240 . 0-2 : 1.0.2.10,
                        ...
         }
  }

Before: 153.6 Mbytes
After: 108.9 Mbytes (-29.11%)

With 100k map without concatenations:

  table inet x {
         map y {
                    typeof ip saddr :  ip saddr
                    flags interval
                    elements = {
                        1.0.2.0-1.0.2.240 : 1.0.2.10,
                        ...
         }
  }

Before: 74.36 Mbytes
After: 62.39 Mbytes (-16.10%)

This is passing tests/shell.

Pablo Neira Ayuso (3):
  src: use constant range expression for interval+concatenation sets
  expression: constant range is not a singleton
  src: use EXPR_RANGE_VALUE in interval maps

 src/evaluate.c   |  8 ++++---
 src/expression.c |  2 +-
 src/netlink.c    | 61 ++++++++++++++++++++++++++++++++++++++++++------
 src/optimize.c   |  3 +++
 4 files changed, 63 insertions(+), 11 deletions(-)

-- 
2.30.2

