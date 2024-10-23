Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78266211C
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 17:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729703791; cv=none; b=JTuwhDop6RgZYgec4PlsMfyZEDXG4hPfLpaATpLLU2SaDz0/HIrRp/JPAc8FzdupDtF7ZbbRVqFpviSpmIzNU/OKb2p6ewlxrdGQw1YscNIF6cJfFAFb/+EvDId9bcO0uAOdPBTfMTi/J2zPgqx+Knjooxv4oTvSAeYHHQlG3/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729703791; c=relaxed/simple;
	bh=Uv3hkCr5Ps2yRPW2MYv7ATs5YRMkTHa0nqeF+L4acfE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=YS5p5vPwdblLcy2ql3SyQR3hSZUkNpJqOA+D4gaPiC/pQvO4rWRsAocZGABEaP5AYsQgi7IAIrHRNPaJTOKxQSUHZuB3k/mer5IiuEQg/md8dg4YxDnmkoza8zCRXXS+QIHpfxQ4+OS6hMNw91xvt5CyBIpIt4wLjqtyA9M5UlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RDslFYwX; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RDslFYwX"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37d43a9bc03so4976460f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 10:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729703788; x=1730308588; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OljP4PdWV2R3StPPy5+/cJKVw4Vph1NJkS5of3TSma0=;
        b=RDslFYwXpLpysTPGDY8UayI6rpoyHJ3Nrt5ZTa+vBY0IUYn64ShjkpQ26BWxGCg+qj
         EGeA8eOcGuP1yBaNgaZHhrHrNwI5Ho4V6/9g6BUljvyfHvL8/oxn2JiuZNRRkBJpcIAK
         vcRd7Pi1X666BrPTJwF+r7EKbfWZd9Pw0aH/NB9H/nMjDA5WE7A11LtqTgCw35D/5+P8
         dqljaRvwCwgIEgSb2PUU+M3MpLQ57oDm9uoIrXn1C15sNRvARF1UCsaqsm8vH3vs0dLc
         jR/gRi6JwsVGygznrk+6lIylQ7gBW+TQZX2dEhtzCGWS6vBc7mydrL3BXqyBAdBF5HJV
         astQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729703788; x=1730308588;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OljP4PdWV2R3StPPy5+/cJKVw4Vph1NJkS5of3TSma0=;
        b=iSmEOCHIGNjCchaMJjwtBDfG1dFiU/G54+ZQfctqlx0F54w6ULEukQ77Gu4QN9GzRa
         cLuTWpBw2TsBEcF25FxgdjqjPVVn5cnHkiAyF8YYkYec72pSckC/IMySVA9Gy5Vfnlvh
         dxa7tq/KGsxPvM4wO7NBbod/Di4spF3nIdkeKkA+eVpuMeovQyLM+Tx0fLqIy1QVYQuu
         gsXCQf4Ik3zj2BnAABUVO5JtLoVwE5+XMArzJE0yz+QGYwnEDKPX5BbGCNmsnldGJSmC
         YqD8x+ZDN1V0IcB1wUQhKNJByCHz4akGfvpZzH0WHDZu8bFC1XF1482kMT9YHscg+RG5
         /exQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2/Ax39jBVB+T/HzhsflQkEs0PDJXpOJSMg8pKma9Gx2/147D/nFd6xJeL05ct9T8j9wZbOctDtG9IdDl50DY=@vger.kernel.org
X-Gm-Message-State: AOJu0YymttY65gn4mTWXnCZD6K0n1ULQQFMWIIrXt2cFmC7s9B8ARVou
	rPvKWH7iSq6BJ11g268/r6Pg4L1Vi1IR5KKpRPNtC7KbfDYUhMBu1xOJiZHEQPI=
X-Google-Smtp-Source: AGHT+IHuawpuTA3FdkKB3grmiiT77MshEcjs2fsxx4eyqV28W03YuXYVz0wzAjnd/bp4vmWf9SSucg==
X-Received: by 2002:a5d:6102:0:b0:37d:509e:8742 with SMTP id ffacd0b85a97d-37efceee7d5mr2251003f8f.1.1729703787648;
        Wed, 23 Oct 2024 10:16:27 -0700 (PDT)
Received: from localhost ([41.210.147.101])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0b9c6b0sm9307877f8f.109.2024.10.23.10.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 10:16:27 -0700 (PDT)
Date: Wed, 23 Oct 2024 20:16:21 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Dong Chenchen <dongchenchen2@huawei.com>,
	pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	fw@strlen.de, kuniyu@amazon.com
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	yuehaibing@huawei.com, Dong Chenchen <dongchenchen2@huawei.com>
Subject: Re: [PATCH net] net: netfilter: Fix use-after-free in get_info()
Message-ID: <01b2bdd1-39f4-43d1-a7e6-f8e8061175a4@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022085753.2069639-1-dongchenchen2@huawei.com>

Hi Dong,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Dong-Chenchen/net-netfilter-Fix-use-after-free-in-get_info/20241022-165936
base:   net/main
patch link:    https://lore.kernel.org/r/20241022085753.2069639-1-dongchenchen2%40huawei.com
patch subject: [PATCH net] net: netfilter: Fix use-after-free in get_info()
config: x86_64-randconfig-161-20241023 (https://download.01.org/0day-ci/archive/20241024/202410240020.Cqi2d68p-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202410240020.Cqi2d68p-lkp@intel.com/

smatch warnings:
net/netfilter/x_tables.c:1280 xt_find_table_lock() warn: passing zero to 'ERR_PTR'

vim +/ERR_PTR +1280 net/netfilter/x_tables.c

03d13b6868a261 Florian Westphal  2017-12-08  1234  /* Find table by name, grabs mutex & ref.  Returns ERR_PTR on error. */
76108cea065cda Jan Engelhardt    2008-10-08  1235  struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
76108cea065cda Jan Engelhardt    2008-10-08  1236  				    const char *name)
2e4e6a17af35be Harald Welte      2006-01-12  1237  {
1d610d4d31a8ed Florian Westphal  2021-04-01  1238  	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
fdacd57c79b79a Florian Westphal  2021-08-03  1239  	struct module *owner = NULL;
fdacd57c79b79a Florian Westphal  2021-08-03  1240  	struct xt_template *tmpl;
fdacd57c79b79a Florian Westphal  2021-08-03  1241  	struct xt_table *t;
f4f502d5a8ea29 Dong Chenchen     2024-10-22  1242  	int err = -ENOENT;
2e4e6a17af35be Harald Welte      2006-01-12  1243  
7926dbfa4bc14e Pablo Neira Ayuso 2014-07-31  1244  	mutex_lock(&xt[af].mutex);
1d610d4d31a8ed Florian Westphal  2021-04-01  1245  	list_for_each_entry(t, &xt_net->tables[af], list)
2e4e6a17af35be Harald Welte      2006-01-12  1246  		if (strcmp(t->name, name) == 0 && try_module_get(t->me))
2e4e6a17af35be Harald Welte      2006-01-12  1247  			return t;
b9e69e12739718 Florian Westphal  2016-02-25  1248  
fdacd57c79b79a Florian Westphal  2021-08-03  1249  	/* Table doesn't exist in this netns, check larval list */
fdacd57c79b79a Florian Westphal  2021-08-03  1250  	list_for_each_entry(tmpl, &xt_templates[af], list) {
fdacd57c79b79a Florian Westphal  2021-08-03  1251  		if (strcmp(tmpl->name, name))
b9e69e12739718 Florian Westphal  2016-02-25  1252  			continue;
fdacd57c79b79a Florian Westphal  2021-08-03  1253  		if (!try_module_get(tmpl->me))
03d13b6868a261 Florian Westphal  2017-12-08  1254  			goto out;
fdacd57c79b79a Florian Westphal  2021-08-03  1255  
fdacd57c79b79a Florian Westphal  2021-08-03  1256  		owner = tmpl->me;
fdacd57c79b79a Florian Westphal  2021-08-03  1257  
b9e69e12739718 Florian Westphal  2016-02-25  1258  		mutex_unlock(&xt[af].mutex);
fdacd57c79b79a Florian Westphal  2021-08-03  1259  		err = tmpl->table_init(net);
03d13b6868a261 Florian Westphal  2017-12-08  1260  		if (err < 0) {
fdacd57c79b79a Florian Westphal  2021-08-03  1261  			module_put(owner);
03d13b6868a261 Florian Westphal  2017-12-08  1262  			return ERR_PTR(err);
b9e69e12739718 Florian Westphal  2016-02-25  1263  		}
b9e69e12739718 Florian Westphal  2016-02-25  1264  
b9e69e12739718 Florian Westphal  2016-02-25  1265  		mutex_lock(&xt[af].mutex);
b9e69e12739718 Florian Westphal  2016-02-25  1266  		break;
b9e69e12739718 Florian Westphal  2016-02-25  1267  	}
b9e69e12739718 Florian Westphal  2016-02-25  1268  
f4f502d5a8ea29 Dong Chenchen     2024-10-22  1269  	if (err < 0)
f4f502d5a8ea29 Dong Chenchen     2024-10-22  1270  		goto out;
f4f502d5a8ea29 Dong Chenchen     2024-10-22  1271  
b9e69e12739718 Florian Westphal  2016-02-25  1272  	/* and once again: */
1d610d4d31a8ed Florian Westphal  2021-04-01  1273  	list_for_each_entry(t, &xt_net->tables[af], list)
b9e69e12739718 Florian Westphal  2016-02-25  1274  		if (strcmp(t->name, name) == 0)
b9e69e12739718 Florian Westphal  2016-02-25  1275  			return t;

ret it zero here, but if we fail to find the name then we should set ret =
-ENOENT;

b9e69e12739718 Florian Westphal  2016-02-25  1276  
fdacd57c79b79a Florian Westphal  2021-08-03  1277  	module_put(owner);
b9e69e12739718 Florian Westphal  2016-02-25  1278   out:
9e19bb6d7a0959 Ingo Molnar       2006-03-25  1279  	mutex_unlock(&xt[af].mutex);
f4f502d5a8ea29 Dong Chenchen     2024-10-22 @1280  	return ERR_PTR(err);
2e4e6a17af35be Harald Welte      2006-01-12  1281  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

