Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B08F1E495
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2024 07:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730444883; cv=none; b=FUxb4KttUq8M5bUyEEUdIt0uX2uOX2wwO7s2YvjnDV3E8KpqTJL3Je/3FwKAMFXm4cHCmVtw9kXnnkarNVeEVvjMFoXf8KwNRZjxvl8SSh58iFOQW95QKWelHbAM4kRaMgLtxanNfC2gChZg/UOLrXw5tU1loRVQokv5QJLL9eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730444883; c=relaxed/simple;
	bh=JutYPB/3oXVJH99Pr39tDq9r5sOqucdhb6oQbo/MObs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=d8qZvV0ouNatYivZLxdc+VvgPuuwV8SVvn/8jlq/SDGQAtTa+AZoZEUYF857bnWtrjnQzYYozaDJuemaBvwqf3wuzbNJUVqqCpJxB0iLdIMazNrxA44uLJxEVDdHgfgXuhvV7awrOd3iLFlwyx4Foc8+0fJU6oRcqdEvL8fFHcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yM/dKyWs; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yM/dKyWs"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4316cce103dso18289015e9.3
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Nov 2024 00:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730444878; x=1731049678; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S+Ifb642LkdinlwnAChfN9N1WVHKlmNGlParRQonuAM=;
        b=yM/dKyWs1uCzW9o52EMIYBulaFrnVVV9iJu4Yb1qEj6XEU6Sf0OIsRwBnLTITEXht7
         ez+NF3YVTuO2bPeNNiMEAPTt3Jndsi34N4IbV48jHnVKA7bV2D+ftkzIFCYvDgxjOiso
         Jw/Rq/5UtEJRVuEZ+5qHGiihb9AVRV5CRBGWU/LePa1HyybbsgCM1UXs9fHnIWsQwYoR
         HgZ2cptjMYWOBQUtCZyat9msfbEWxiP384rhBov9YsKFXVLq1pFzzzdM/oMxf8s2H3Mm
         DC6bxszCLyBrLWqd1CvMRE0yUuH8vbjUptNGLFMep21gYOocEGQtSnBmPXkDMOnWvCCy
         XA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730444878; x=1731049678;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S+Ifb642LkdinlwnAChfN9N1WVHKlmNGlParRQonuAM=;
        b=lxasVGW0S/2c5Yf/wyXxgOa6hpDWREY0Pzb4jdcMSaJ22jm3T1pUyKr8JNdW/eu135
         hMqII3sjTVC109pg6KkiJz48Oquut3GqqLTYQdUIQC/tKct9kATq1k1Rx+Qckdn/iWA7
         g00J87ZyCGlAnbli1gtnszrWKXn118zj1QBlEQkZrrH85t5UzZk3o/dFFPNpRuJbvLn+
         vqw6/z5dPvFMqSB8kO3QyV2ghQCGvUAHIF2DChX3I/4ReUqxnn0Q/Pp/F6V7J8ZWLdFh
         oIVBYACE53bJgAl3SDSOKouOBQ1Vk+hr0HplRM8MKtQUjJU+veS2Kj80pOTT+eZI5ULD
         6UyA==
X-Forwarded-Encrypted: i=1; AJvYcCWfK5/IoA2IMnx0VJGHgSLqRdcDe8u8ey+1LBEhNKc9gc8bYSQqTI+CTIo2FREyrlybCQirGen33Nf8dJSPgt4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3Ysew7nuwoz91lM33B6JrAa2utcyXyHaZkC3a8BTqtkiAZOT4
	KWld/e4MFAn4tySsC9ntDzPQAxpCA4lu3lGldmboaDL8y4p2Z2MRXiS4RvWF/TI=
X-Google-Smtp-Source: AGHT+IHZkKwuSaJjnxtpYOWRHPKIO6H6fHtNmW5nRFRDs0p02yK/SaVhAKY0QGc50Lrs/f2CtIFgBQ==
X-Received: by 2002:a05:6000:1f8c:b0:37d:2de3:bf8a with SMTP id ffacd0b85a97d-381c7a6bcb4mr2189000f8f.26.1730444877770;
        Fri, 01 Nov 2024 00:07:57 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bb79429asm77103985e9.1.2024.11.01.00.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2024 00:07:57 -0700 (PDT)
Date: Fri, 1 Nov 2024 10:07:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next 7/7] netfilter: nf_tables: must hold rcu read
 lock while iterating object type list
Message-ID: <b052e0ad-4b89-4f79-855d-5ed9766168e4@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030094053.13118-8-fw@strlen.de>

Hi Florian,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-nf_tables-avoid-false-positive-lockdep-splat-on-rule-deletion/20241030-174657
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20241030094053.13118-8-fw%40strlen.de
patch subject: [PATCH v2 nf-next 7/7] netfilter: nf_tables: must hold rcu read lock while iterating object type list
config: s390-randconfig-r073-20241031 (https://download.01.org/0day-ci/archive/20241101/202411010754.SLk5GvT6-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 14.1.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202411010754.SLk5GvT6-lkp@intel.com/

New smatch warnings:
net/netfilter/nf_tables_api.c:7886 nf_tables_newobj() warn: 'type' is an error pointer or valid

vim +/type +7886 net/netfilter/nf_tables_api.c

7dab8ee3b6e7ec8 Pablo Neira Ayuso          2021-04-23  7879  		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
d62d0ba97b58031 Fernando Fernandez Mancera 2019-08-26  7880  			return -EOPNOTSUPP;
d62d0ba97b58031 Fernando Fernandez Mancera 2019-08-26  7881  
84b1a0c0140a9a9 Pablo Neira Ayuso          2024-03-05  7882  		if (!obj->ops->update)
84b1a0c0140a9a9 Pablo Neira Ayuso          2024-03-05  7883  			return 0;
84b1a0c0140a9a9 Pablo Neira Ayuso          2024-03-05  7884  
2a7dbf052c3b79b Florian Westphal           2024-10-30  7885  		type = nft_obj_type_get(net, objtype, family);
2a7dbf052c3b79b Florian Westphal           2024-10-30 @7886  		if (WARN_ON_ONCE(!type))

s/!type/IS_ERR(type)/

2a7dbf052c3b79b Florian Westphal           2024-10-30  7887  			return -ENOENT;
2a7dbf052c3b79b Florian Westphal           2024-10-30  7888  
7dab8ee3b6e7ec8 Pablo Neira Ayuso          2021-04-23  7889  		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
d62d0ba97b58031 Fernando Fernandez Mancera 2019-08-26  7890  
2a7dbf052c3b79b Florian Westphal           2024-10-30  7891  		/* type->owner reference is put when transaction object is released. */
d62d0ba97b58031 Fernando Fernandez Mancera 2019-08-26  7892  		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
e50092404c1bc7a Pablo Neira Ayuso          2016-11-28  7893  	}
e50092404c1bc7a Pablo Neira Ayuso          2016-11-28  7894  
7dab8ee3b6e7ec8 Pablo Neira Ayuso          2021-04-23  7895  	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
e50092404c1bc7a Pablo Neira Ayuso          2016-11-28  7896  
1689f25924ada8f Pablo Neira Ayuso          2023-06-28  7897  	if (!nft_use_inc(&table->use))
1689f25924ada8f Pablo Neira Ayuso          2023-06-28  7898  		return -EMFILE;

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

