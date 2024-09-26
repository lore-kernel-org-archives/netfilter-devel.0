Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6669E1AB6E3
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344354; cv=none; b=OfE7FVQ6Q6ak0COujp3oqDmBqhO4c2deEx//Gnr2EV8LVf3NlYcJ1z0eCHZvfXoEJA+Oxdm33nsG9P4yK5ZMLc1hcJQNp8/LTg2CFrtS5mN2ZXhxPTKkhFJ/h4vEwgmMERSljdrIIAHUETgoDlQUgcVA+cH+y7CkW8xwh/BY+Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344354; c=relaxed/simple;
	bh=rEt71a7VGdK3jFLlN0hQEI+yd/6pfnqJ6FRIpKaBabA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=k95tW/GbMdP3eLdX+EKIEHIGGzIuXB4ObQ1GbtrnaR4e+/9k4iAEQyqhbgxlvL54PpcMO9FR47hpc1hCF+oCBRX12kTcVbdaKkzwufGIkFKk+VaNbSk+lmC8cHrZpkpVj44cQErUevFUnkfTkoIh8UvcFb4oSS4+tUCTN5gVnH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OdyvicAb; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OdyvicAb"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-37ccf0c0376so368111f8f.3
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 02:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727344350; x=1727949150; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jcok0oH2cdp0w4vhZiVUFGaPK+YCPe3byBql15xoWD4=;
        b=OdyvicAbsdJVCcpWD+Ip1Zuxnv7ESfgLjyMGvxWl/PvenDIU69LhwbevOiuoWkvVtB
         qWRr5evnvdV6tVVaenvhxnbx5nTRewuJkDm9oAc56iaZPyRb0OFb8hZ2oqm77CjL0htb
         YGd4RXjmz/bQkgpT3FHXhCA8Zz4KLjgwv20yAbG2WD826KUvNnrRhkdQp+dZNwVWO8uI
         JbvBaP5zSWaixKjDQE/zzzoAfNHqvaHSiukDr0D8KnVd7Y/3igRRr7OJ8jYYpDLLfHCg
         VjQ18GFrJ84QcLUtw9v7Z1xNbl2RaMFWmtst8THoGv+BBWWtdjAKCgQXL+/AIhWBU9Hv
         qqtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727344350; x=1727949150;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jcok0oH2cdp0w4vhZiVUFGaPK+YCPe3byBql15xoWD4=;
        b=FHymTHknaKbxtrOOAEFma4TmWRBZghWKFIFs4kbNBdr0+8ZgygmywnCfChYUKOj7Oy
         Gi9q/JVYPAUOX6Lzr8bZUJFFr5TPzmE+FeBNfG0sk6u2m0DemDxfzY2rAL973HRnmtBw
         gnRhEpEqqDzOVODrJX33stEp//sdBt6+8ZAu1c15q5rqPC6GqOQ9WL8pm2CWShnJuH4c
         Q6DZpf/H1E2WA/8tLsioHLUINqgBpN19CUW2ccygtTYWkdHWWFTUxrxnF7V1t+wUDyVU
         qEzsvunKGvL1yQtm16YjynMNAGuW6c1QHAenP1cVFxtb9CIUUnhGf9U9BsyX55K1TAF0
         khQA==
X-Gm-Message-State: AOJu0YwmNRT1ASPaLtH2WXab0BQu8nmI0wtwoTjZvTUv4Q9PaK/whbKW
	MVcO+BA97yBe47XfeYhA1GyU85WwMd3jQdTnkBDH8MeK3z95ZPo9ZahaLYf4Hw0=
X-Google-Smtp-Source: AGHT+IGVcPOTJ4ckIfYgbQoaGeqhSJJQQHqUW8LFkxFCzzV6GCHYv/eS5HJEul9zhb8lbfwdqSTqEg==
X-Received: by 2002:a5d:48cb:0:b0:374:c50e:377b with SMTP id ffacd0b85a97d-37cc24d962cmr3054388f8f.57.1727344349627;
        Thu, 26 Sep 2024 02:52:29 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc2a8c98sm5974579f8f.14.2024.09.26.02.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 02:52:28 -0700 (PDT)
Date: Thu, 26 Sep 2024 12:52:25 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [bug report] netfilter: nf_tables: no size estimation if number of
 set elements is unknown
Message-ID: <78b8ef5b-f3b2-4854-bf72-1370171861ef@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Pablo Neira Ayuso,

Commit 080ed636a559 ("netfilter: nf_tables: no size estimation if
number of set elements is unknown") from May 22, 2017 (linux-next),
leads to the following Smatch static checker warning:

	net/netfilter/nft_set_rbtree.c:727 nft_rbtree_estimate()
	warn: potential user controlled sizeof overflow '88 + desc->size * 24'

net/netfilter/nft_set_rbtree.c
    720 static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
    721                                 struct nft_set_estimate *est)
    722 {
    723         if (desc->field_count > 1)
    724                 return false;
    725 
    726         if (desc->size)
--> 727                 est->size = sizeof(struct nft_rbtree) +
    728                             desc->size * sizeof(struct nft_rbtree_elem);
                                    ^^^^^^^^^^
This can only overflow on 32bit systems.  I can't see where est->size is
actually used though.

    729         else
    730                 est->size = ~0;
    731 
    732         est->lookup = NFT_SET_CLASS_O_LOG_N;
    733         est->space  = NFT_SET_CLASS_O_N;
    734 
    735         return true;
    736 }

regards,
dan carpenter
