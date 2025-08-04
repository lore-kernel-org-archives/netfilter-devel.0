Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703672309B9
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Aug 2025 08:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754295726; cv=none; b=RzcHPyRjPxW3Iomc/1crGPBNa3Vh4Vf4dPdeUJLYvznIP6lgQh8VWDmQJkQxyv8bOssdNRBtbFkGboPZf6Ookt0BJ+UrWDl5MSFimWOFhMKCKCPii8vbKTLP+u8MygYzU5NuQ5rhchE3cPQzkMYQeKbERqgVBTxzSL5xMa2SceA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754295726; c=relaxed/simple;
	bh=Hgun2bR0/UP8MBo3N3LewUIxvm10oaQnEmCGJxhZ2ds=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RYtjcZez3tXdm7XUFlJGGKqg7AaOaXe8v8RKO+IYbws9LDPihcFhShs2Pc1H1RgfIroIrJan6mrMaAviedHpyv14MA6piwNWpqlCYLboYJTirhL5GNfxdkfeMOGQ8j2aSveY8ozc4roTETthrWIPGnA4qGsdlmApoKNFGHISEto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JnaRrK1V; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JnaRrK1V"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a6cd1a6fecso3598085f8f.3
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2025 01:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754295723; x=1754900523; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oAPWtV0jA8c3aPBgVqSkjn3h2PvOAAFQI34zZekmr1M=;
        b=JnaRrK1Vs8NySRkBalqdAZVyItW5PuuU7bokA/lFsOOOmckA9+KDRNwGPbaDc3RvzA
         kqzy4GRMZW4JvmiCPsx+UGRVbcVupIn4Tm0zXWaaPuF4Aqmac1ZOzhS+e9auKayfvUoc
         VQCcPZG509R8ITAQqV0ml4hXRrDTnjMsbWS3816EDRGgtfVDDcunpa30jJUQ7eBhG+t/
         Hk0rSTIbIJQL4N5n820HaOI2K88UedsA8hxWW9LjGTaSi5DIEvstJMEZREInhE68NYNe
         SQ682wagsAZlbA8SFPxYDXpQfG6wN4IEhJzjO5TNOTrE4RL/IA5Ktjz4UffRrZCc8P/a
         +uRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754295723; x=1754900523;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oAPWtV0jA8c3aPBgVqSkjn3h2PvOAAFQI34zZekmr1M=;
        b=O8CPY3XO8jCYsKJ8yIgqQTg0G8aUc96XggiXDIBjMr2R8J9AyHndE/7auhTryQtM2O
         eZWQBwb3Qxf6OBcNSjBtdUo5pD3yWtlpa4oO3cMZe5R9tRrQ6RpdnlYba6ULyCglDvK1
         ZVhXnVVtXExM3H23cqBDj3dT3tLX6ahifQ8Rc0vaC3ZlZw4cPdzGv8efH3X5NujpQ/Q4
         eVii0wp2LafzWK4DeB+WKl7qCYAALQSbnTpELgx5DHjFq0lY6JcIz7X/bUJ9kpWQDWiV
         zE1UhsA+F2tFxPtTScU9o1hwvE8Jnolt6mlb7ttW785Qlm6TnCwkT7cdAW72/93VmYoO
         ph3Q==
X-Gm-Message-State: AOJu0YxC8eDBBbkc7VuDO0wlv1tLJVvra/7eamw53eCio4WJTsM99vum
	HQRf3vU04L4IpksxG1a+jxRr/wMPB7+XvdewEDbDs2qnlxaeY2gKZpIiRGGaBYmEKGc=
X-Gm-Gg: ASbGncu6J6nv5w1me1GgdxiAlJjFN8Y09WIl1uXdVZZU2xBk4PXyQe//K585b7GrYyC
	nR4DMh54nXpxI1Q3dIBH74y+wf2iOQCw164uY2WZLKztCJ+XUb5uqPsX4jffnx4xwSsM/oKUh6g
	krSvThuv21d+mCngZInbu4vZCXu3yZMx0VVTHXr4dz7cfq4VN3AhipKaV7SZ07vFSvjGMmUqoK9
	bxzLBcZDLJoa5HFCh/bWSgbd5RUfPYbqzZ4fEzIVnGbyv0kbNsOyWKUw3Z+fbWJFfMVrhiTeGUY
	LQR4i9YYOe0a120NFNEL3PvfFCO2yaMOHiuWlEl3F0RL0d0vEIM9HS9Dd6mh3D8ddROwnO9fB6x
	1yXIvfnTO15Tn4NQwXc/1v/X1fohEHet+vM5+kkebLoQ=
X-Google-Smtp-Source: AGHT+IE8LT2XHSpD9Y5ANt8sAHe7UfZncDq1iFJbkEkeREwLdYp9cyRXo8QAv3atjokRC/D7LHCyuw==
X-Received: by 2002:a05:6000:2906:b0:3b7:bedd:d268 with SMTP id ffacd0b85a97d-3b8d94ce5b8mr6191003f8f.53.1754295722613;
        Mon, 04 Aug 2025 01:22:02 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3abedesm14822743f8f.3.2025.08.04.01.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 01:22:02 -0700 (PDT)
Date: Mon, 4 Aug 2025 11:21:58 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: netfilter-devel@vger.kernel.org
Subject: [bug report] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <aJBtpniVz8dIRDYf@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Lance Yang,

Commit e89a68046687 ("netfilter: load nf_log_syslog on enabling
nf_conntrack_log_invalid") from May 26, 2025 (linux-next), leads to
the following Smatch static checker warning:

	net/netfilter/nf_conntrack_standalone.c:575 nf_conntrack_log_invalid_sysctl()
	warn: missing error code? 'ret'

net/netfilter/nf_conntrack_standalone.c
    559 static int
    560 nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
    561                                 void *buffer, size_t *lenp, loff_t *ppos)
    562 {
    563         int ret, i;
    564 
    565         ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
    566         if (ret < 0 || !write)
    567                 return ret;
    568 
    569         if (*(u8 *)table->data == 0)
    570                 return ret;

return 0?

    571 
    572         /* Load nf_log_syslog only if no logger is currently registered */
    573         for (i = 0; i < NFPROTO_NUMPROTO; i++) {
    574                 if (nf_log_is_registered(i))
--> 575                         return ret;

This feels like it should be return -EBUSY?  Or potentially return 0.

    576         }
    577         request_module("%s", "nf_log_syslog");
    578 
    579         return ret;

return 0.

    580 }

regards,
dan carpenter
