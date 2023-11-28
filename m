Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IiPjXTwk"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F2EAFAF
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2023 13:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hTUc9UTm+HTNYvdwaP5TYnKZtEWGjC78Z3JLO/jAUy0=; b=IiPjXTwk3wHrgmDEuozMVVxw9S
	SNCb6RYyfOcxIyW27ymRoITXBHkS+Q5T09/ndo2nCOHZXSlTpTmv3jAPjkU3U+2lfJhPDSxwUMI7F
	HXUCJR7gfmcz0PG7YnMaTQVuYwXWefYheEybjgJ66boVb+Q9FDVEbgIX+BT99NVJ3258MHNrWRIb/
	jqS9r2sj1vFflfv+ypV+IjyfMZtHXt50HPuW6H7XewglFZ9xylD/Mo5IGMC/Jm6sHDJcfoenOVcMs
	XcZDNZvpwQz32/m2jInO8cs30K4ItEhKgFo3tT87WpRr9k1d2OfC5sRsQaup6rnRIws3E2v/oAQiJ
	yzL92QeA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r85PF-0003ym-QG
	for netfilter-devel@vger.kernel.org; Tue, 28 Nov 2023 22:14:09 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] libxtables: xtoptions: Fix for non-CIDR-compatible hostmasks
Date: Tue, 28 Nov 2023 22:26:31 +0100
Message-ID: <20231128212631.811-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231128212631.811-1-phil@nwl.cc>
References: <20231128212631.811-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to parse the mask, xtopt_parse_hostmask() calls
xtopt_parse_plenmask() thereby limiting netmask support to prefix
lengths (alternatively specified in IP address notation).

In order to lift this impractical restriction, make
xtopt_parse_plenmask() aware of the fact that xtopt_parse_plen() may
fall back to xtopt_parse_mask() which correctly initializes val.hmask
itself and indicates non-CIDR-compatible masks by setting val.hlen to
-1.

So in order to support these odd masks, it is sufficient for
xtopt_parse_plenmask() to skip its mask building from val.hlen value and
take whatever val.hmask contains.

Fixes: 66266abd17adc ("libxtables: XTTYPE_HOSTMASK support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtoptions.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 433a686c2b595..02025e99d4832 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -692,6 +692,10 @@ static void xtopt_parse_plenmask(struct xt_option_call *cb)
 
 	xtopt_parse_plen(cb);
 
+	/* may not be convertible to CIDR notation */
+	if (cb->val.hlen == (uint8_t)-1)
+		goto out_put;
+
 	memset(mask, 0xFF, sizeof(union nf_inet_addr));
 	/* This shifting is AF-independent. */
 	if (cb->val.hlen == 0) {
@@ -712,6 +716,7 @@ static void xtopt_parse_plenmask(struct xt_option_call *cb)
 	mask[1] = htonl(mask[1]);
 	mask[2] = htonl(mask[2]);
 	mask[3] = htonl(mask[3]);
+out_put:
 	if (entry->flags & XTOPT_PUT)
 		memcpy(XTOPT_MKPTR(cb), mask, sizeof(union nf_inet_addr));
 }
-- 
2.41.0

