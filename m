Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A236D386C28
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 10:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775817329; cv=none; b=QRgIC+WDLZBuR+Xnd2EelPPzhJZMyA5kk8HG2mK+MSM3AkFREOad4yP7vq9q9M/e+eq8+VU774wWg31FwzhjKXt+KFMD5j/zUjVn+fS3fQwbQOQprSp66nZTDIyjqF647EiRe10BrqkQzcDOaC23ut0bCmMwvnrD7uwmeH6Ig5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775817329; c=relaxed/simple;
	bh=FVJpeczI/1480WreFRplZDOUCLZ9v2a2BkgBWpDgeh8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hU8/SmXO6Og/M0qVs2qG9faeHQwPowUQCBEtFIHLnZfScb8tf83niy3SRdcZxruvnUSKGjSLOSMOhUwJbv/rsl2/NvvSDupkbpYX8Z3ueDsiCXws56q9X/DqR4U8+ZQaDxLW3p1OEqk70xsP/Ry+hOtX8ELzSw2TwtUSqLJuS/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WQEN0WNZ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQEN0WNZ"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43d17bb1c1dso1477854f8f.2
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 03:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775817326; x=1776422126; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pRG0gsef/fAwLr2Q15e2XSmu3TQP8GBQsRjHLRuwRr0=;
        b=WQEN0WNZIEa/IJQyvx8m75doBQV8tT2HEj1IMpR6QvKiwLyFB0AhN8X0gClx7ndxpV
         RS6fo8KBT9qHcm9Gtchxz7YWB5lGVbJ6bmLTlw9fIstBMJJx5d1V+bqf6sgY+hJfwOMQ
         tfoDz+2Od9NkLmJ6JJgxfz/efMbebdr2kzWenSUTyzNpwxAWktgHh1L41F5vGHfsqJob
         56lVSW9fKFngzh2+Nepx5JQRcSIJUkiI/pbIfWuBgUB42cShZQrtQTqW7eQi0FoTsfpC
         ZisW1SRmCafHKltC9IP/v9mmtVxWx01ZFlULoX5lp65ckX8o1cUcjEJc/1t1dtyxu4he
         XW7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775817326; x=1776422126;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pRG0gsef/fAwLr2Q15e2XSmu3TQP8GBQsRjHLRuwRr0=;
        b=SiuCO1mol4br9Bu5GnZiI8WqXQhE/cTNsz4YzXhnjm8DLxaGn9nrUpF7MMlx2VL+FW
         iQm4pRFVtNn38N/UfyqkIOgNj90AX9NU5aiE8ambebHdCauS/bhlECok8E9hjzH96ck/
         Qx7HnWSwMKtuBNUI20iiK5Arzhxk4fDayfKPvYZkQm3WlbvpHHL4PdaQ0pExNPjqx4Ve
         QFIyYYfjdeGOWr5SnFECjQglI6ysD1VvLgZY/oJQMmy1/WsHdkJFuRT2pgq5eg2cOhBK
         zqtZEkBxmFykreVXuZ3fXvu1gAi7v4J6NKP9QmqTWNz6MQJc6qhs9mTUKkPEgY60K0VF
         /U3w==
X-Gm-Message-State: AOJu0YzAEtTzDDFOGp9xJpTH4oO+wcIYmPMGbk5b+9Oy4Wtwt6aQBIcO
	EDk5LbMmDhEtsW8uSsYsOiZCOt3pmPXxGn2NFbFQXCd/2mwtj3TSSTNe
X-Gm-Gg: AeBDieuhAe6LoYNuF9k6P6AQLF7Hmio/2MnHnEZbolYnnVdDFprB/wjAcIWHFs+kkso
	gnZbpqLvEPxiWSvxRcxuJ/QXXCAMcCev4oNOKF4hEkjHXMHBWrU/iqP9ZUTLrJrvGCSn9RyLex/
	fGfLtLICoEHOsgew8Kd4pEJXWI8ZEPyr3aIDFjmGBsUSI4gbpP3b+/BDhh5MIBhs5+uAWS1r2m2
	qHnJ9VHI8P6N64fsjPHJ07BgVhc5XwzaHjWQa/egQGwOMm0i0TaiiSv7QUsIHhpPwv716BmqvUc
	vbzcTeY7Z1Ci+qTLsd460SCl/qkNFfAlK6CwiNZw0S0pmHjIoiWVMYerKAHeyPyYniiy7hTQH+k
	WlxfY46KBbXNgpWYDal29JWampye6/cnBa/Iq/z9FIQYESfEZ28PbC2zXOC9hL4qTLcydcNeI3m
	lVA5pcjSSOO81oK0YRUIM=
X-Received: by 2002:a05:6000:2489:b0:43b:8f04:2ee1 with SMTP id ffacd0b85a97d-43d642c4ee9mr3911267f8f.27.1775817325756;
        Fri, 10 Apr 2026 03:35:25 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e5ccdasm6713139f8f.34.2026.04.10.03.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 03:35:25 -0700 (PDT)
Date: Fri, 10 Apr 2026 13:35:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: [bug report] netfilter: nf_tables: nft_set_rbtree: fix spurious
 insertion failure
Message-ID: <adjSaolTji0mPgqx@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Florian Westphal,

Commit 087388278e0f ("netfilter: nf_tables: nft_set_rbtree: fix
spurious insertion failure") from Sep 28, 2023 (linux-next), leads to
the following Smatch static checker warning:

	net/netfilter/nft_set_rbtree.c:399 __nft_rbtree_insert()
	warn: 'removed_end' is not an error pointer

net/netfilter/nft_set_rbtree.c
    379         /* Detect overlap by going through the list of valid tree nodes.
    380          * Values stored in the tree are in reversed order, starting from
    381          * highest to lowest value.
    382          */
    383         for (node = first; node != NULL; node = next) {
    384                 next = rb_next(node);
    385 
    386                 rbe = rb_entry(node, struct nft_rbtree_elem, node);
    387 
    388                 if (!nft_set_elem_active(&rbe->ext, genmask))
    389                         continue;
    390 
    391                 /* perform garbage collection to avoid bogus overlap reports
    392                  * but skip new elements in this transaction.
    393                  */
    394                 if (__nft_set_elem_expired(&rbe->ext, tstamp) &&
    395                     nft_set_elem_active(&rbe->ext, cur_genmask)) {
    396                         const struct nft_rbtree_elem *removed_end;
    397 
    398                         removed_end = nft_rbtree_gc_elem(set, priv, rbe);
--> 399                         if (IS_ERR(removed_end))
    400                                 return PTR_ERR(removed_end);

nft_rbtree_gc_elem() returns NULL, not error pointers.

    401 
    402                         if (removed_end == rbe_le || removed_end == rbe_ge)
    403                                 return -EAGAIN;
    404 
    405                         continue;
    406                 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
