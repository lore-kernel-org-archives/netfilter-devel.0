Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27C32F30
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Aug 2025 08:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754297211; cv=none; b=bSrnFyvVQHeD3NzYoBL3faB35Zc/rtKEMSqNgGBxSnJv1wI9rP6fga5I9Ehow9WsLLN47j3K3BQ/PrC4Bs4Z/99k3e6XwY2BiQYSItvjW8zym9k42EphqorVhvzYRzOLeUfhq1Gflr3kKPz9E/ONMmHafrHym+OGPtD9ae8e3X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754297211; c=relaxed/simple;
	bh=etM1uTveyF2mZgk2p9S/aqFaPRdFb/vbIlMDR6YPUUg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HUPyRL4Qji85ssSe47a18MVv/o+wr7DBEpQMm7RyGIBHXVE/ZtGT8GFi4xLoRxWUY2OiAo/GZHvPZw0FRtJJGpSY0dKHdyFk1Hr0TBIRYfJSst1Jdk5QBQHTGPjSzUHrzH/ahdTjlKz6SsxegaQwIFBxAVqGm5OHZdApDhBUW2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HLHjqhcY; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HLHjqhcY"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-458bdde7dedso11035595e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2025 01:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754297208; x=1754902008; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dhZWF2sdFW7qEWxqGIrfYXJJfrCw5VNYGMTRCrJuPRo=;
        b=HLHjqhcYhDj6ChDiIwTdgyMl0cxlioyOpg2DUUAk5cMCRJy3hYJsfPzcG/nWbGY0U/
         e7UfRnQ3C0mGWZuO7KoRjJiSmN3DBahfVdARQyfVJKwuDCmejGW8+BOEEo19B+Lo+2bm
         qRwYjgA+0eWG5spIKMP1lMVQG0n+ZuzFw4NV9X2p0UIQbcJoJT2ivCiTUoMejbVcX+j6
         1FymZDSML4cSuvOUxhbAm4vdHqOQzrfIbGXsIJJfgKNoHJ8ecVtQZdrIOluZEFSn1xsd
         w94XvdOmYRv42M2LQ75bjD/O/t0THk6QsyUUtqNAmd6dnAFgjuq5/SKOMS2Ke4wGi89o
         wrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754297208; x=1754902008;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dhZWF2sdFW7qEWxqGIrfYXJJfrCw5VNYGMTRCrJuPRo=;
        b=WJEixyJ0d59IIxikhk7ft44fQEkoRKiXJreQZFQTWSWH4hzTAkilrAum2LbByXMI3q
         2Jn2VLJVN4pZvswCg/xnZj3BN8ucUHI6biVc19ljtlW9//6T626Xri83eFrmfUlgFXKy
         Q/xv4DRo+6VaXzBkda/Uc2HABHRUkDD6D056gsGu0V4IqJM6n4LjyrJXoU5gRjOrODDL
         z5lKPoLV6fz/hxyBqzzZTlyZBSjeB6Av5hT6WzdlHT0taACrpNaarF+s15z4kdxXh0jg
         Vs82pQCESXOeq6y/LMUmu6Z8ncXT8IVpdOeE/AmGqQo8jzXqesANyhBogDFdqYJHyFBG
         vZIA==
X-Gm-Message-State: AOJu0Yy4+vIeOnUgrxZyrtHtzE38G6dLC7KuTEl5DFE1pUlgdmW9Y5P/
	o/spkVF6io4lCsbx2yenyjXkmmhQE/bP3NS2GQkbjIpINaMq+3wA+xtCLSbiBQzZ3kY=
X-Gm-Gg: ASbGncsMHx10zYOU2wuWURoBCZeej/oCuXS1rfuVLGjGjDGCTtKlip8zdY16xD+sjOQ
	00ejm9mhSQ2Jb2niNVwjGZtQRdWImkxpJkQJ8v+uMqbPEEMDMndk2HcTXppMfwNEbQpMhGS/usr
	dtRPoRcakF0GxJC1rKuNFjyxmrxJpy5Cp9Y2/ScyY2E6kvgUm37pC3CC1kdgTPy9S5xj7o1FDA7
	cp4L25S6SADi+k0L8a2BnCWUCQt0OwBmnXcbSAu80fgRg2ySUEfmWNkdoXxlFdV2eWryffmwinv
	0iy2n1nKwgAjdcObCw7caizxfgIiHtQ6MGbidQXGImcwCAy151mxknCBdUK1V6hoyEpsNFh/cP6
	2jeUl0SfFSBMmG8/xYdHwzfbw5XdKlu5MhMzvVw==
X-Google-Smtp-Source: AGHT+IF9xS3poHFUv33zYTLD66bjwStiZ1Ja8wst+Ad9eX2f/OEFKmXoY7nMRbhbECOWGT9Anrwekw==
X-Received: by 2002:a05:6000:250f:b0:3b8:d582:6162 with SMTP id ffacd0b85a97d-3b8d94c3ceemr6992770f8f.46.1754297207851;
        Mon, 04 Aug 2025 01:46:47 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-458bb04c612sm80717515e9.0.2025.08.04.01.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 01:46:47 -0700 (PDT)
Date: Mon, 4 Aug 2025 11:46:43 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: [bug report] netfilter: nft_set: remove one argument from lookup and
 update functions
Message-ID: <aJBzc3V5wk-yPOnH@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Florian Westphal,

Commit 17a20e09f086 ("netfilter: nft_set: remove one argument from
lookup and update functions") from Jul 9, 2025 (linux-next), leads to
the following Smatch static checker warning:

	net/netfilter/nft_set_pipapo_avx2.c:1269 nft_pipapo_avx2_lookup()
	error: uninitialized symbol 'ext'.

net/netfilter/nft_set_pipapo_avx2.c
    1148 const struct nft_set_ext *
    1149 nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
    1150                        const u32 *key)
    1151 {
    1152         struct nft_pipapo *priv = nft_set_priv(set);
    1153         struct nft_pipapo_scratch *scratch;
    1154         u8 genmask = nft_genmask_cur(net);
    1155         const struct nft_pipapo_match *m;
    1156         const struct nft_pipapo_field *f;
    1157         const u8 *rp = (const u8 *)key;
    1158         const struct nft_set_ext *ext;
    1159         unsigned long *res, *fill;
    1160         bool map_index;
    1161         int i;
    1162 
    1163         local_bh_disable();
    1164 
    1165         if (unlikely(!irq_fpu_usable())) {
    1166                 ext = nft_pipapo_lookup(net, set, key);
    1167 
    1168                 local_bh_enable();
    1169                 return ext;
    1170         }
    1171 
    1172         m = rcu_dereference(priv->match);
    1173 
    1174         /* This also protects access to all data related to scratch maps.
    1175          *
    1176          * Note that we don't need a valid MXCSR state for any of the
    1177          * operations we use here, so pass 0 as mask and spare a LDMXCSR
    1178          * instruction.
    1179          */
    1180         kernel_fpu_begin_mask(0);
    1181 
    1182         scratch = *raw_cpu_ptr(m->scratch);
    1183         if (unlikely(!scratch)) {
    1184                 kernel_fpu_end();
    1185                 local_bh_enable();
    1186                 return NULL;
    1187         }
    1188 
    1189         map_index = scratch->map_index;
    1190 
    1191         res  = scratch->map + (map_index ? m->bsize_max : 0);
    1192         fill = scratch->map + (map_index ? 0 : m->bsize_max);
    1193 
    1194         pipapo_resmap_init_avx2(m, res);
    1195 
    1196         nft_pipapo_avx2_prepare();
    1197 
    1198 next_match:
    1199         nft_pipapo_for_each_field(f, i, m) {
    1200                 bool last = i == m->field_count - 1, first = !i;
    1201                 int ret = 0;
    1202 
    1203 #define NFT_SET_PIPAPO_AVX2_LOOKUP(b, n)                                \
    1204                 (ret = nft_pipapo_avx2_lookup_##b##b_##n(res, fill, f,        \
    1205                                                          ret, rp,        \
    1206                                                          first, last))
    1207 
    1208                 if (likely(f->bb == 8)) {
    1209                         if (f->groups == 1) {
    1210                                 NFT_SET_PIPAPO_AVX2_LOOKUP(8, 1);
    1211                         } else if (f->groups == 2) {
    1212                                 NFT_SET_PIPAPO_AVX2_LOOKUP(8, 2);
    1213                         } else if (f->groups == 4) {
    1214                                 NFT_SET_PIPAPO_AVX2_LOOKUP(8, 4);
    1215                         } else if (f->groups == 6) {
    1216                                 NFT_SET_PIPAPO_AVX2_LOOKUP(8, 6);
    1217                         } else if (f->groups == 16) {
    1218                                 NFT_SET_PIPAPO_AVX2_LOOKUP(8, 16);
    1219                         } else {
    1220                                 ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
    1221                                                                   ret, rp,
    1222                                                                   first, last);
    1223                         }
    1224                 } else {
    1225                         if (f->groups == 2) {
    1226                                 NFT_SET_PIPAPO_AVX2_LOOKUP(4, 2);
    1227                         } else if (f->groups == 4) {
    1228                                 NFT_SET_PIPAPO_AVX2_LOOKUP(4, 4);
    1229                         } else if (f->groups == 8) {
    1230                                 NFT_SET_PIPAPO_AVX2_LOOKUP(4, 8);
    1231                         } else if (f->groups == 12) {
    1232                                 NFT_SET_PIPAPO_AVX2_LOOKUP(4, 12);
    1233                         } else if (f->groups == 32) {
    1234                                 NFT_SET_PIPAPO_AVX2_LOOKUP(4, 32);
    1235                         } else {
    1236                                 ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
    1237                                                                   ret, rp,
    1238                                                                   first, last);
    1239                         }
    1240                 }
    1241                 NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
    1242 
    1243 #undef NFT_SET_PIPAPO_AVX2_LOOKUP
    1244 
    1245                 if (ret < 0)
    1246                         goto out;

Needs an "ext = NULL;"?

    1247 
    1248                 if (last) {
    1249                         ext = &f->mt[ret].e->ext;
    1250                         if (unlikely(nft_set_elem_expired(ext) ||
    1251                                      !nft_set_elem_active(ext, genmask))) {
    1252                                 ext = NULL;
    1253                                 goto next_match;
    1254                         }
    1255 
    1256                         goto out;
    1257                 }
    1258 
    1259                 swap(res, fill);
    1260                 rp += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
    1261         }
    1262 
    1263 out:
    1264         if (i % 2)
    1265                 scratch->map_index = !map_index;
    1266         kernel_fpu_end();
    1267         local_bh_enable();
    1268 
--> 1269         return ext;
    1270 }

regards,
dan carpenter
