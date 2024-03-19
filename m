Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A3A210E6
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868359; cv=none; b=cAgqSvexOol2JGrLbN9LWHw9oCII50+EY5W3J7jz2mLABD2P4AN4INK6fxDYZVjof/bCJaCM87obOH1iSD1EklwM4thha4o5kgw+5vUJnT7eW34XJsMxXimlFvRfHZOaYGMW9oeLWBKIW3fagM5DJWip+H0EBpPamk1SlqKMZlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868359; c=relaxed/simple;
	bh=O9O3F9HU/hMcDoSTtoQzcin9VN0ZVl6aSy12uGPf96A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDg16gloLEkoMfJt5dgFDfuWLe4rVQZaDgph8qDwNaRlM/4z//7tMf1DElIQPmNasoIvpJ5AcwX7lH1wYoiF9rh+5PfepyTjXHp6F2oQ8/7gJeihS0FFf6UBFb370muXRJ1H/zk2K2VTvbkP6o6ccMGL9rPbCKqziTAqv0BptBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PoJT8Fhh; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PoJT8Fhh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=COVdgqetbd7vv0P6S/UOdUwHNuznjpsy4YdnHTuEiOk=; b=PoJT8Fhh12592eeTuHtP9pT1HE
	MIdPLO5F6605LxXELgheEfcg1MPnwuA3WtqVAcoufp/vjT8b3o2IeItSAQJ1U4B3I9DcRcOMiu5EN
	U7HuQTHeNvgM7pOwmw/D9SplNErYn//X1rX0qL6vSxFHUQmyX4ZaWtVcscbmFBrxt5+D8+0Nzi96K
	IPXMUwY1XV4QMIXTysCNV58VXSCmKwf9uXwTk8FPoCXbGbqYNX4Q4/zE4kK/WaRwDgHBMao7lvFUG
	tg+hfzxynCm/SbSyZHTteJbyvVeFqEs4Bcq+EtdJWj1h3UewibvZMZd70MpBiH2sioGx7GQRJTnv0
	LIIXqivA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0u-000000007gj-3r7P;
	Tue, 19 Mar 2024 18:12:36 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 12/17] obj: Call obj_ops::set with legal attributes only
Date: Tue, 19 Mar 2024 18:12:19 +0100
Message-ID: <20240319171224.18064-13-phil@nwl.cc>
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

Refer to obj_ops::nftnl_max_attr field value for the maximum supported
attribute value to reject invalid ones upfront.

Consequently drop default cases from callbacks' switches which handle
all supported attributes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/obj/counter.c    | 2 --
 src/obj/ct_expect.c  | 2 --
 src/obj/ct_helper.c  | 2 --
 src/obj/ct_timeout.c | 2 --
 src/obj/limit.c      | 2 --
 src/obj/quota.c      | 2 --
 src/obj/secmark.c    | 2 --
 src/obj/synproxy.c   | 2 --
 src/obj/tunnel.c     | 2 --
 src/object.c         | 4 +++-
 10 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/src/obj/counter.c b/src/obj/counter.c
index 76a1b20f19c30..982da2c6678e5 100644
--- a/src/obj/counter.c
+++ b/src/obj/counter.c
@@ -34,8 +34,6 @@ nftnl_obj_counter_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_CTR_PKTS:
 		memcpy(&ctr->pkts, data, sizeof(ctr->pkts));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/obj/ct_expect.c b/src/obj/ct_expect.c
index 7e9c5e1b9e48c..60014dc9848b5 100644
--- a/src/obj/ct_expect.c
+++ b/src/obj/ct_expect.c
@@ -35,8 +35,6 @@ static int nftnl_obj_ct_expect_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_CT_EXPECT_SIZE:
 		memcpy(&exp->size, data, sizeof(exp->size));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/obj/ct_helper.c b/src/obj/ct_helper.c
index f8aa73408839c..b8b05fd9eee8c 100644
--- a/src/obj/ct_helper.c
+++ b/src/obj/ct_helper.c
@@ -37,8 +37,6 @@ static int nftnl_obj_ct_helper_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_CT_HELPER_L4PROTO:
 		memcpy(&helper->l4proto, data, sizeof(helper->l4proto));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index ee86231f42965..011d92867a077 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -162,8 +162,6 @@ static int nftnl_obj_ct_timeout_set(struct nftnl_obj *e, uint16_t type,
 		memcpy(timeout->timeout, data,
 		       sizeof(uint32_t) * NFTNL_CTTIMEOUT_ARRAY_MAX);
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/obj/limit.c b/src/obj/limit.c
index 1c54bbca72fef..83cb1935fc8e9 100644
--- a/src/obj/limit.c
+++ b/src/obj/limit.c
@@ -42,8 +42,6 @@ static int nftnl_obj_limit_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_LIMIT_FLAGS:
 		memcpy(&limit->flags, data, sizeof(limit->flags));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/obj/quota.c b/src/obj/quota.c
index a39d552d923f2..665d7caf4a5d5 100644
--- a/src/obj/quota.c
+++ b/src/obj/quota.c
@@ -36,8 +36,6 @@ static int nftnl_obj_quota_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_QUOTA_FLAGS:
 		memcpy(&quota->flags, data, sizeof(quota->flags));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/obj/secmark.c b/src/obj/secmark.c
index c78e35f2c284f..83cd1dc2264ed 100644
--- a/src/obj/secmark.c
+++ b/src/obj/secmark.c
@@ -30,8 +30,6 @@ static int nftnl_obj_secmark_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_SECMARK_CTX:
 		snprintf(secmark->ctx, sizeof(secmark->ctx), "%s", (const char *)data);
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/obj/synproxy.c b/src/obj/synproxy.c
index d259a517bebbf..f7c77627b56e9 100644
--- a/src/obj/synproxy.c
+++ b/src/obj/synproxy.c
@@ -27,8 +27,6 @@ static int nftnl_obj_synproxy_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_SYNPROXY_FLAGS:
 		memcpy(&synproxy->flags, data, data_len);
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 19a3639eafc01..72985eeb761cd 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -76,8 +76,6 @@ nftnl_obj_tunnel_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
 		memcpy(&tun->u.tun_erspan.u.v2.dir, data, sizeof(tun->u.tun_erspan.u.v2.dir));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/object.c b/src/object.c
index d363725e10fb8..bd4e51a21aea9 100644
--- a/src/object.c
+++ b/src/object.c
@@ -149,7 +149,9 @@ int nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 		obj->user.len = data_len;
 		break;
 	default:
-		if (!obj->ops)
+		if (!obj->ops ||
+		    attr < NFTNL_OBJ_BASE ||
+		    attr > obj->ops->nftnl_max_attr)
 			return -1;
 
 		if (obj->ops->set(obj, attr, data, data_len) < 0)
-- 
2.43.0

