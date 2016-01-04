From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH 1/2] iptables: nft-ipv4: Add ip ttl to the buffer
Date: Mon, 4 Jan 2016 22:49:40 +0530
Message-ID: <43eb8fe0401a5c813cfaa1002799dc00f667c4b9.1451927507.git.shivanib134@gmail.com>
References: <cover.1451927507.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36862 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbcADRTr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 12:19:47 -0500
Received: by mail-pf0-f175.google.com with SMTP id 65so160079511pff.3
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 09:19:46 -0800 (PST)
Received: from gmail.com ([106.201.42.190])
        by smtp.gmail.com with ESMTPSA id 85sm54464887pfi.18.2016.01.04.09.19.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 04 Jan 2016 09:19:45 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <cover.1451927507.git.shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the string "ip ttl" to the buffer whenever a match for ttl is found as
ttl needs to be specified with the version of protocol being used.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 iptables/nft-ipv4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index ede8f17..684096f 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -477,6 +477,9 @@ static int nft_ipv4_xlate(const void *data, struct xt_buf *buf)
 			   inet_ntoa(cs->fw.ip.dst));
 	}
 
+	if (xlate_find_match(cs, "ttl"))
+		xt_buf_add(buf, "ip ttl ");
+
 	ret = xlate_matches(cs, buf);
 	if (!ret)
 		return ret;
-- 
1.9.1

