Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B7E2375B
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868358; cv=none; b=eU0HhDBuUJST6XZuvNebGlwkez5mJn91Fg81Ey+fltYzcu8KgKTZGYAYuEW00XqkiCP6xhLlxH4Z9PbvBEnmcmqm/ATOwunQNCgsWmhZc+hzn4TtvIF13xZkyZAZy5LvvCzha6PmS4uLq88/qsO+CekcpTHZO4HASfNiL7u7i6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868358; c=relaxed/simple;
	bh=vvml5wa/qs/5pdJW9ed/JnJhBqlTeXRHOVi3da3Z9nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2TgQ3wZH1tOT8tXDOfr9upTSDGSwuOO9f6XXA9iL6zqL/x0ptkbXRfv8uMvuve7hF9cuwk8BlpNoSD1cp+8y+ZfgXlJWr6qZtoJhbnFqNYWFk9lOaPSf0oR1kALQiEJ5gT3JeoG5F8wuhzfI0MZVXU+So09fDy7SMIBIHDjHu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Sd/cwdLl; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Sd/cwdLl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rqAi1U04BBXNxL09pkxDNtqU4CZ2CDVq0XnJdd9lLuM=; b=Sd/cwdLlsqDttc1l00jv2p4OZ9
	Xb0lPBfi7KlfIJafOFaOd2XmTIJ3AeyFHvo1duC5CMkpwE8+DUc/YFeh7A0SLy9BZMqOWL2TW5nVZ
	slIFH716PYszCZLPPSciJ7gfhWGShRJoqG/ZOomluOA5RBIlKjx4w3kPjA3coiJ0TBHA8YPxBnBXC
	n214cWlsy9Z0e8zVPFvjauIPcsTKl5Zrm4TBudAXYvnxrIlyaJID2xuY0TTP5L1CUffhwztWBg97r
	I4SCEdV7224OsAc9ywhT6XzAs7WGT5SJoDsXwnhQWz+BMQn3t2pus8eIZx8DVLLqI08EzGmbmtcBb
	9mV+xoOA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0t-000000007gY-3Jlw;
	Tue, 19 Mar 2024 18:12:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 14/17] obj: Enforce attr_policy compliance in nftnl_obj_set_data()
Date: Tue, 19 Mar 2024 18:12:21 +0100
Message-ID: <20240319171224.18064-15-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319171224.18064-1-phil@nwl.cc>
References: <20240319171224.18064-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every object type defines an attr_policy array, so deny setting
attributes for object types which don't have it present or if it
specifies a non-zero maxlen which is lower than the given data_len.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/object.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/object.c b/src/object.c
index bd4e51a21aea9..2ddaa29cda0be 100644
--- a/src/object.c
+++ b/src/object.c
@@ -151,7 +151,12 @@ int nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 	default:
 		if (!obj->ops ||
 		    attr < NFTNL_OBJ_BASE ||
-		    attr > obj->ops->nftnl_max_attr)
+		    attr > obj->ops->nftnl_max_attr ||
+		    !obj->ops->attr_policy)
+			return -1;
+
+		if (obj->ops->attr_policy[attr].maxlen &&
+		    obj->ops->attr_policy[attr].maxlen < data_len)
 			return -1;
 
 		if (obj->ops->set(obj, attr, data, data_len) < 0)
-- 
2.43.0

