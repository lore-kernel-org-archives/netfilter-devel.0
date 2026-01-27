Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25CF346AD9
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769551981; cv=none; b=tmjtYzkDS0wbAMd8K7eWw3H5b9Ar5XIWUuVx1CgKi2PpYZZWq1HW2WSeS3JFHsQrnHJjQvOHsyYuiBD+AOpRFAkHEP7uVNxUwRvTXCAm/DVOvCLUBbwhziSVf/nsol3r9/FywqYoRzQq5KFg6g6FVaC2JdXANSQQeI3HFm0LLg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769551981; c=relaxed/simple;
	bh=+FLZBneW1lPZt6QY7GfiMTSKorWmVlyrXdh1vktTcMU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lHf6ega09gWKVHcvgQ2M4TTjiSK6X3/n4ZpcpYfVDX5Kc5N3DHqDL/mtwYgctzMxpSXrOrB92eGFikt3I3Iu6NMBr5qw3a8CthHiWTeu8Y9TYXhZrY/LRHxgor+nlS4GqyVyqd2dxhkbWDiw8rT+dawP6IsqskF9lYgEmMr+dUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KckOAm43; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KckOAm43"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lEzA4t+NrpHUwv2ckyUCpYrHc32cAkmbgUyb4QaDK9E=; b=KckOAm43A73iGY/v0irMW4k1Pj
	mUhWACehgF9eOvDg+CG0IG34S0FPG67hcP/X+828xZ4Ihy+UCLT3TXDCHUlKvrSQjVcJeYBbUa7R7
	uCTzuYFDYiwTc/HjG2BXHD5PCngs+DnuC1N9wwhiVyhIevu2D+L0RcOL8v3NAokXpQB/JVfvVmVgM
	jnFl5yyVoQB5Mr1zQeKqK1CSxPqo3AdAw+hsBdghzO7FYq33IKVnSR8iIYydfIA+rNBSwJdmwdqPh
	cRjiF0dYpk7f/4No5UI873VWksg61UV0QQQ4v7325swpJAchZqcUUdSYezs0HUrHbGacZiYcgpCBG
	3i0qOLjA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vkrIv-000000002Sm-3xI7
	for netfilter-devel@vger.kernel.org;
	Tue, 27 Jan 2026 23:12:57 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: nft.8: Describe iface_type data type
Date: Tue, 27 Jan 2026 23:12:52 +0100
Message-ID: <20260127221252.27440-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An entry in data-types.txt offers space for a name-value table. Even if
one would refer to ARPHRD_*, some names are not derived from the
respective macro name and thus not intuitive.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/data-types.txt         | 27 +++++++++++++++++++++++++++
 doc/primary-expression.txt |  2 --
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index e44308b5322cb..0b350effbea68 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -83,6 +83,33 @@ filter input iifname eth0
 filter input iifname "(eth0)"
 ----------------------------
 
+INTERFACE TYPE TYPE
+~~~~~~~~~~~~~~~~~~~
+[options="header"]
+|==================
+|Name | Keyword | Size | Base type
+|Interface type |
+iface_type|
+16 bit |
+integer
+|===================
+
+The interface type type is used with *meta iiftype/oiftype* expression. Its values correspond with respective ARPHRD_* defines in <linux/if_arp.h>.
+
+.The following keywords will automatically resolve into an interface type type with given value
+
+[options="header"]
+|==================
+|Keyword | Value
+| ether | 1
+| ppp | 512
+| ipip | 768
+| ipip6 | 769
+| loopback | 772
+| sit | 776
+| ipgre | 778
+|===================
+
 LINK LAYER ADDRESS TYPE
 ~~~~~~~~~~~~~~~~~~~~~~~
 [options="header"]
diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index d5495e2c86291..bd80cd7f92fda 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -149,8 +149,6 @@ String value in the form HH:MM or HH:MM:SS. Values are expected to be less than
 Interface index (32 bit number). Can be specified numerically or as name of an existing interface.
 |ifname|
 Interface name (16 byte string). Does not have to exist.
-|iface_type|
-Interface type (16 bit number).
 |uid|
 User ID (32 bit number). Can be specified numerically or as user name.
 |gid|
-- 
2.51.0

