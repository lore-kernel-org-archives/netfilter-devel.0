Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7794C8C53
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 14:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161474; cv=none; b=m0FAkUCIBa33wXWeRyQoBMyvbwXCrpRtblLNZFnYBzavrH2pyRpO18oX9G7Ue7eTTLse9BvNsd9hKJJRuhfgrxc40eVv+Kc+y5hAPdnCcVWP6ENDntWqm5fxMkJCXmk5+KxDlFRVtWycTAlJn9XQSTGd6gLuiyzESIJg6zxWPGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161474; c=relaxed/simple;
	bh=wAp7afOfTC8HUwyazn0LOftlGcbyrbQpAQhvKDn+ea4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eQGerHINpIbbTa0Ey9t/GcVm0XiZvukcyKPY6X4tO2D9rY5IxeF3KnYFL1L3OLq5Gl7dFRoB1S3yNABVYMgOBz5H/+Z2HcXBbO49LN7osHcFeLxsfy0F8NOlNK3Be3paMe8PtrxUealnm43IYFYOyZRs4ZX/W9o3wmrWT7xbw/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UL3b9nrb; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UL3b9nrb"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-9906034086cso6211241.1
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 07:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792161469; x=1792766269; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OvFMfxSzYVJ2lOTMgtJEulD+6aZKmETG2qDahrWDVzI=;
        b=UL3b9nrbT8FhDYiBNNTYMQ0g2P11ovzC/D+iI3qA4y96nANAG1iq0ojqMX+/39b0y/
         9yPzrDqw4LCorPMdnBZ9IQyzBRf37IGvuAMPhixVqu2Cf6AIYaM6N6yi4mLyNHM+9VMI
         JlQ+rI+YpN66ADhcxVN2SK+ONvAoPnuE0mHLJ76SUoSfQm0k4m4zpOwb0C6uNhN9RzQF
         K7CINHUyZFay7mfeADRsrvzs6YwLdwPYcdN5/dc+C9jet4vXdYSPXG3w91NqCgmUXFFV
         lnnwxThvbmRG12eP9WCBod6Xn1fTqDS4F2wmXoJ25pvJMvj0PmO3kyXsdJMVzaTTOvOm
         a4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792161469; x=1792766269;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OvFMfxSzYVJ2lOTMgtJEulD+6aZKmETG2qDahrWDVzI=;
        b=XSlh5sDldABFts8H5vpESsLMzIzZgW+scw1gZVWhGK3SJjlHR6l4fMgx5/74f+jBCY
         HMqVnQ71hrrW6ugzuIp74Pf8BKwOny5dbwJeip5WbGBJntwI0vAS25GZLN1svMmEhli6
         xhXAKZLGwrpf0o5NJlDYYMnPoM3Tt2S/5GsbDj/78yAYNMYlPv4ojvaQlq1dDpwpPS+Z
         ulfSVwhpStNrnvxd94Fkq7/FgvqAIzU3X0uZPNQXc6p/koxmJanxd+rLBFVfpa36B38A
         GwM9CZSDCnoc4O66rNy5gy4ISZVaAHKMWEawXkCp/dbG45B3n5EoaWHBYa/e2yvsgMqQ
         /Fvw==
X-Forwarded-Encrypted: i=1; AKwUvBwE1mrfRu4WuY41zah99h5QGlIF8Y3c0Vte82xWD3sI7bc8V2i0ujtiw/QygAplfg6bVZ7IIerz6ntfpFfOT7M=@vger.kernel.org
X-Gm-Message-State: AFq9FYKhWLwaS9sHVsjSPhS2kRVb8VNwyn+pzcx7PFvlzcdFBZKbzn5I
	KZBXCve8IGDF6tGYRK6oCbDCvQNRfyTi7tzwDmLo0aotfBYx7FZ+Riyf
X-Gm-Gg: AYBFou2sGLjeyTdktxWs9Dbd02puZ4lcGyhzL4Ig8tyQiho0AUC6e5Y/iusLbx7Lfpr
	zlDDPQIttz8er9Eh3vdK6EIiR73kv9hno3y7jmpuGZW/Pds932b3r7jxNefo3C4E94EIXrISXn6
	Vo1d9EppUhfA4PPkfHiOVBQqCcrqDSd6fjwDOu6o9QTdTo076zwNZlNGXwezESsIWWW2rekCpw+
	doE5/rn/XI8VO7SKcvW8wwrQMBbOaMjTs6OEbK09BoMsspz+qRA10zn6rh6xt5IT3RryGc5CnPl
	3eY/nGnikcmx0BQYi0vavJ2X9W7WeQLBXaBJF/SCzrdfdQywbeusbWheJFbu4HjNOtozUWN4xXa
	9/1UyCxUedcgfv/iqp9GLuV0BgT6cGL9BpmIOTlANTdfIestd393EhuuLkqKgXP/kzImE7YlmyJ
	JqRMsBrA4TGLpaHAjzhgHq7dH2ctL62FksGfC4xuYCO+3DRemGrBdNl1zvYdQe1DfFOholbKfXS
	5rPgU8a05QShzu2HWMoBw79MlNfpHJMdkZDZdO9iA5Pqy8ww5GIS2Vtzpjm2zM8kbtdT97uUoHV
	y1OdX393iCwqnGJ87L/ewAOFaq0tkdR3WAWxo3FtPcLTzvVYm+cG7N6y
X-Received: by 2002:a05:6102:c48:b0:7c8:3b8c:82ba with SMTP id ada2fe7eead31-7cb373de301mr5673762137.32.1792161468460;
        Fri, 16 Oct 2026 07:37:48 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2804:7f0:b100:ece0:b5:bb23:a54:ce61])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cc1983af93sm2248453137.8.2026.10.16.07.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:37:47 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, selinux@vger.kernel.org,
 linux-security-module@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selinux: don't label bridged packets in selinux_ip_forward()
Date: Fri, 16 Oct 2026 11:37:41 -0300
Message-ID: <179216146138.25460.7866279004288174372@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

With br_netfilter and bridge-nf-call-ip{,6}tables enabled, bridged IP
packets go through the NF_INET_FORWARD hook, where selinux_ip_forward()
calls selinux_netlbl_skbuff_setsid() and NetLabel may add or remove a
CIPSO or CALIPSO option.  cipso_v4_skbuff_setattr(),
calipso_skbuff_setattr() and calipso_skbuff_delattr() move the IP
header and reset the network header, but the Ethernet header stays
where it was; when the bridge pushes it back in front of the packet it
picks up stale bytes and the frame goes out with a garbage destination
MAC and EtherType.

Labeling a bridged packet based on its IP addresses is not what we want
here anyway, so leave bridged packets alone.  Add a stub of
nf_bridge_info_exists() for CONFIG_BRIDGE_NETFILTER=n.

Tested with QEMU, two veths enslaved to a bridge with br_netfilter in
the middle, SELinux and a NetLabel DOI 16 configuration, 5 UDP packets
per case:

  case                                        before        after
  CALIPSO packet, unlabeled destination       MAC garbage   5/5
  unlabeled IPv6, CALIPSO destination         MAC garbage   5/5
  unlabeled IPv4, CIPSO destination           MAC garbage   5/5

Routed packets are still labeled (an unlabeled packet forwarded towards
a CALIPSO destination gets the option, 5/5).

Fixes: 948bf85c1bc9 ("netlabel: Add functionality to set the security attributes of a packet")
Link: https://lore.kernel.org/netdev/CAHC9VhS+bdL_YnLQtd0sPmKKfy9BvS-LWV_6EhAuu4qfUFe_mw@mail.gmail.com/
Suggested-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 include/linux/netfilter_bridge.h |  5 +++++
 security/selinux/hooks.c         | 13 ++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 743475ca7..c1f7c3cb2 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -79,6 +79,11 @@ static inline bool nf_bridge_in_prerouting(const struct sk_buff *skb)
 }
 #else
 #define br_drop_fake_rtable(skb)	        do { } while (0)
+static inline bool nf_bridge_info_exists(const struct sk_buff *skb)
+{
+	return false;
+}
+
 static inline bool nf_bridge_in_prerouting(const struct sk_buff *skb)
 {
 	return false;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 30776b010..1e4f02f99 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -49,6 +49,7 @@
 #include <linux/fs_parser.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
+#include <linux/netfilter_bridge.h>
 #include <linux/tty.h>
 #include <net/icmp.h>
 #include <net/ip.h>		/* for local_port_range[] */
@@ -6145,11 +6146,13 @@ static unsigned int selinux_ip_forward(void *priv, struct sk_buff *skb,
 				 SECCLASS_PACKET, PACKET__FORWARD_IN, &ad))
 			return NF_DROP;
 
-	if (netlbl_enabled())
-		/* we do this in the FORWARD path and not the POST_ROUTING
-		 * path because we want to make sure we apply the necessary
-		 * labeling before IPsec is applied so we can leverage AH
-		 * protection */
+	/* we do this in the FORWARD path and not the POST_ROUTING path
+	 * because we want to make sure we apply the necessary labeling
+	 * before IPsec is applied so we can leverage AH protection; bridged
+	 * packets are skipped as changing their IP options would leave the
+	 * Ethernet header behind
+	 */
+	if (netlbl_enabled() && !nf_bridge_info_exists(skb))
 		if (selinux_netlbl_skbuff_setsid(skb, family, peer_sid) != 0)
 			return NF_DROP;
 
-- 
2.43.0

