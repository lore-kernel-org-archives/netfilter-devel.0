Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6C4C433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 05:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78D0E2186A
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 05:01:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=metaloft-com.20150623.gappssmtp.com header.i=@metaloft-com.20150623.gappssmtp.com header.b="zh14li9I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbfHHFB6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 01:01:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35011 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfHHFB5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 01:01:57 -0400
Received: by mail-pg1-f194.google.com with SMTP id n4so1641130pgv.2
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Aug 2019 22:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaloft-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HprVMKR1+23XeVLomuA0F/VmWho41kh02MotJAK115g=;
        b=zh14li9I5L9LU6KID6iUUopgpiv4bUOrFP8nIVO+kHCNzb5eulvjsc+XwJqysMDASU
         g5d0CTR63J8aJx4KqKtPTN0LpqaVDxbvQCzDs8K7hgJAr1LrKi4QB0TdIsX1zMo4SxxV
         QMFu7XIPtK9/NIZ1HEKRFJRz7nCBAWTXjEvSJh8xv3LABWqmWmZX2EHe/jWjYJMv9FKn
         yxZ2b3UF/qMgMiSuQOj6/N373ErasFK8xEChlxmtMyJ/mjFNsx4Pxq65lTvJ+lnfmSl9
         8boN2H/uY66UvquPvnO2KqwgrL6l4TdTHZpD7ufS8xwd1CrYoLwiXbw26Dc7ObCE9IA9
         dTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HprVMKR1+23XeVLomuA0F/VmWho41kh02MotJAK115g=;
        b=eUyD3nrTwJg75YQS/guoOAAPg4sp0r0X5STp8neeyXcrSZQ5ArfXc6U1oJwhJgMpFN
         ivSVQ5zCN3rQyWNl4Ek+0LLcA7ycvYTwF+MzN8fh7JCWG1F3FbFHGfUQdNWvP0Cfa3O3
         lr08A9TralUY8YfSphYETKGgTHHoE3rraJtCMjBkmXnOwo/Faeeav9PF3uzXYk4tzeN2
         dcQgQ7enYTnC0O0zu+EvzaPeYhbdoINW0G+yaCZG+Z0hV1Ec/urjF0AEjywpQNfyt6Y6
         2+J/lzE+LH3swH86DTg0D5gZFdrMm1gsTXeBIaiQFWRTUQVl3o55S5mj4XfSbpDbvKpf
         /p5A==
X-Gm-Message-State: APjAAAWJ+rpOQmNUSV1pX80WNqO57lLIrg8MU4QaSaF6eG0LJS5YBP6X
        uZUUWgWLLAuV9VkECUJbxjw5T8ovW2U=
X-Google-Smtp-Source: APXvYqz51PA338ERljZV1EC/eQRXZsupK5MpLjiIr2k3I21Q/vsmc8zey8plsrhT6h3DQ47ijnpCqw==
X-Received: by 2002:a63:4522:: with SMTP id s34mr10871370pga.362.1565240516413;
        Wed, 07 Aug 2019 22:01:56 -0700 (PDT)
Received: from ?IPv6:2600:6c4e:2200:6881::3c8? (2600-6c4e-2200-6881-0000-0000-0000-03c8.dhcp6.chtrptr.net. [2600:6c4e:2200:6881::3c8])
        by smtp.gmail.com with ESMTPSA id u7sm89901520pfm.96.2019.08.07.22.01.55
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 22:01:55 -0700 (PDT)
Subject: Re: [PATCH net] netfilter: Use consistent ct id hash calculation
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <e5d48c19-508d-e1ed-1f16-8e0a3773c619@metaloft.com>
 <20190807003416.v2q3qpwen6cwgzqu@breakpoint.cc>
 <33301d87-0bc2-b332-d48c-6aa6ef8268e8@metaloft.com>
 <20190807163641.vrid7drwsyk2cer4@salvia>
 <20190807180157.ogsx435gxih7wo7r@breakpoint.cc>
 <20190807203146.bmlvjw4kvkbd5dns@salvia>
 <20190807234552.lnfuktyr7cpvocki@breakpoint.cc>
From:   Dirk Morris <dmorris@metaloft.com>
Message-ID: <f58a512a-0b74-c98d-067d-70ef67da0a95@metaloft.com>
Date:   Wed, 7 Aug 2019 22:01:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807234552.lnfuktyr7cpvocki@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 8/7/19 4:45 PM, Florian Westphal wrote:

> 
> So Pablos suggestion above should work just fine.
> Dirk, can you spin a v2 with that change?
> 

Yes, will do tomorrow.

Also, just an idea, I also played around with just adding
u32 id to struct nf_conn and just calculating the hash inside
__nf_conntack_alloc when initialized or even lazily in nf_ct_get_id.
This seems to work fine and you don't have to worry about anything changing
and only calculate the hash once.

I'm presuming this method was avoided for some reason, like keeping the struct
size to a minimum.

---
  include/net/netfilter/nf_conntrack.h |    3 +++
  net/netfilter/nf_conntrack_core.c    |   30 +++++++++++++++---------------
  2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 93bbae8..9772ddc 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -74,6 +74,9 @@ struct nf_conn {
  	/* jiffies32 when this ct is considered dead */
  	u32 timeout;
  
+	/* ct id */
+	u32 id;
+
  	possible_net_t ct_net;
  
  #if IS_ENABLED(CONFIG_NF_NAT)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ab73c5f..614fd86 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -312,21 +312,7 @@ EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
   */
  u32 nf_ct_get_id(const struct nf_conn *ct)
  {
-	static __read_mostly siphash_key_t ct_id_seed;
-	unsigned long a, b, c, d;
-
-	net_get_random_once(&ct_id_seed, sizeof(ct_id_seed));
-
-	a = (unsigned long)ct;
-	b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
-	c = (unsigned long)ct->ext;
-	d = (unsigned long)siphash(&ct->tuplehash, sizeof(ct->tuplehash),
-				   &ct_id_seed);
-#ifdef CONFIG_64BIT
-	return siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &ct_id_seed);
-#else
-	return siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &ct_id_seed);
-#endif
+    return ct->id;
  }
  EXPORT_SYMBOL_GPL(nf_ct_get_id);
  
@@ -1178,6 +1164,7 @@ __nf_conntrack_alloc(struct net *net,
  		     gfp_t gfp, u32 hash)
  {
  	struct nf_conn *ct;
+	static __read_mostly siphash_key_t ct_id_seed;
  
  	/* We don't want any race condition at early drop stage */
  	atomic_inc(&net->ct.count);
@@ -1215,6 +1202,19 @@ __nf_conntrack_alloc(struct net *net,
  
  	nf_ct_zone_add(ct, zone);
  
+	unsigned long a, b, c;
+	net_get_random_once(&ct_id_seed, sizeof(ct_id_seed));
+	a = (unsigned long)ct;
+	b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
+	c = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				   sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple),
+				   &ct_id_seed);
+#ifdef CONFIG_64BIT
+	ct->id = siphash_3u64((u64)a, (u64)b, (u64)c, &ct_id_seed);
+#else
+	ct->id = siphash_3u32((u32)a, (u32)b, (u32)c, &ct_id_seed);
+#endif
+
  	/* Because we use RCU lookups, we set ct_general.use to zero before
  	 * this is inserted in any list.
  	 */
