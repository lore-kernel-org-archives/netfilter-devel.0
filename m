Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB17143861;
	Thu, 13 Jun 2024 11:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279219; cv=none; b=NGuHb9Cldhe+XxlHHC7/xYUa1ADp8tdtH82cZM+K9hZmSegFJu6TrcOsYz3r2XfjE/nZhdIUaJCqx27c4YptyAyvQphqtTdVR2yp8BiBeuG+VlNht52YgSZ6XORhYGt0IOgngdhDrEdW2br3nnu6ZtmkW8aZ3yP+YkNMVf0Hmd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279219; c=relaxed/simple;
	bh=qedXbED6mauAF6Y6Nxfq7W9uAC4doo/GyJAsfdFyTPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuvo0y5DL4+3X4Df+KSCy77rz/OYm6Qbw1MopKdRbPiTBZVMGbfkA1SBWqHQnmkgX7DwLlXm5KGlYwon5PFCSW6iwIf8c8x0qNYAUjbmbwuBjiwMe+bzhrrUoZB6Xw84fbkBHuS2MzTECIXw0bb86YdddtDCpkqFMKQrxtzQB0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnRqfaoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnRqfaoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EFAC2BBFC;
	Thu, 13 Jun 2024 11:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279219;
	bh=qedXbED6mauAF6Y6Nxfq7W9uAC4doo/GyJAsfdFyTPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnRqfaoeRFfrg3ZKxlZBpjH9VEezxhwHEIwnvCkNYVjFoOZ38i6Xq10PP7vr77RNJ
	 6R06FWMU477BozVraoG7k7fSvdR2r9pSG8np0O1wbYPAZHSag4MqrNAknPimX1SewA
	 ji+HID57swqM0g297Txrm1STDS3TShBu1NNaccxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 184/213] netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush (for 4.19)
Date: Thu, 13 Jun 2024 13:33:52 +0200
Message-ID: <20240613113235.080337055@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per
net_device in flowtables") reworks flowtable support to allow for
dynamic allocation of hooks, which implicitly fixes the following
bogus EBUSY in transaction:

  delete flowtable
  add flowtable # same flowtable with same devices, it hits EBUSY

This patch does not exist in any tree, but it fixes this issue for
-stable Linux kernel 4.19

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5956,6 +5956,9 @@ static int nf_tables_newflowtable(struct
 			continue;
 
 		list_for_each_entry(ft, &table->flowtables, list) {
+			if (!nft_is_active_next(net, ft))
+				continue;
+
 			for (k = 0; k < ft->ops_len; k++) {
 				if (!ft->ops[k].dev)
 					continue;


