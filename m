Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FEE14AB8;
	Thu,  6 Jun 2024 02:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717639854; cv=none; b=uxtC6wiZDqgVUXJelwQAXRzrMW6j4AQOdi+vLCX1A+v541Qgb24zfFtAMcJWNPJpAIKjpyaxU9iH8GUS0k7FgAdaGbrVNUox7VgioELvejywB2eKj8Hv9TEUm3rnNf75LnEi8snVQ+LvOakaOuzYHEqDkA/lBFQDanEOWgLIYow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717639854; c=relaxed/simple;
	bh=pvbRGZ9lWGQhvfPLgqQ2rsd01i2xWchlkHCWNwoi67w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qc6cHzcSWW/kMKKGWL7+qfJgN5S04G8eP2lEEWTv/FZJWctBbspS5EEogCLbWi/I2w1bjvtPxdmxvoYYsBeCZil2y134yFpQbOP78iRNRqHHgb3xo3H+OCMZJZKcxu5B4QqW9qHd75+JsyGobQnWwJdPdIRbSMgnaDMdtw8i328=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hvgM6s/+; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvgM6s/+"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1f68834bfdfso3971605ad.3;
        Wed, 05 Jun 2024 19:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717639852; x=1718244652; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/lQ0BtcLqRYPijPjELgs/dGd5qA6wIUM0sIqX5CqmgA=;
        b=hvgM6s/+YB+vU1VO+KgleLzOEVoTm0MpQGez1aSAHisO+FZ4fjY7btEvAtp5NwneBF
         iNDIdig2wQGr6U8LL/wdGHIgghP+Sj/4crw+yg9X9nj7AiK46ZiHHmB4Z/qiuF2eF47b
         hou4dt4bhWH8qwEMe9r9GwKublulQtdtS9A1eZhE8lKmpqQT7WZ6oY/t/IdAMefviGdc
         a6YEVtljErD0Ypw2ng//RQkasswJmrv2VpRjCc7J0B7naMkhv9FX4GASc360QV1TQxtf
         Q6dhKU+XzVnxd85iQbAlt6DRQvRqMweYd5X6kXWBxj7l7Ruaca4+ECZC4kmCr6bqMiHi
         4PlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717639852; x=1718244652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/lQ0BtcLqRYPijPjELgs/dGd5qA6wIUM0sIqX5CqmgA=;
        b=iCTtbXZLcSgnL6eD1dlnHYprftvgMtjZBtN3WcO71E/OqIKMFWTdYjQqqRCE82U1oV
         ruBocXIPM9i/Dlo/fYZTvLR1GCtYGdfzo/VueLgswHLMRWPt9nUftHRNArAFVxxV9yik
         LvVh1RfXRqKMLW59eSwd3EwM25O4wrBfw/AL2f+Z+58Y8Z+T5eBhLujb3tUgC2WkDRaB
         X/RR95aFbC7Ydypk6KorY/bK2XfTuCV43vtSzCIMjJPEk2pXybILWuffj5B9/anb6vq6
         3KSmvWqaCym6HjzZnxqwKrzS5GlZ0yMYEk5uu7YT4OoruZJGNlpuxTYRP1e5eP3xueFS
         p/mg==
X-Forwarded-Encrypted: i=1; AJvYcCVTSeeqgEHiRMheoFPUGASbF+VIbSAeKzkMNgLBEQKQIqIJ+4q256tuWjHRuKR3LjuF/PxxfylD93DKd1mVUI+rpyDdczrUx2H33BHCq+N4sNcLz0A45NNrEG9fJmaBUdXuHbqEsEy+
X-Gm-Message-State: AOJu0YzoYAz9tOAH5YXDpW8+NRRLzoyUMeUwU1O088it45mnMRjjgDQV
	u2eSCX4CBqlBHw+H3o+OEpDggT+isZ7N+3HOPhWzwM3pNptLLZwo
X-Google-Smtp-Source: AGHT+IEu4Jc3hrTMlO4BYQwCE/M6Qh0vjDFf1WxIvmx7KQ3DzSX5hgy/h2z15qjf2jk+VY+tkC2IrA==
X-Received: by 2002:a17:903:187:b0:1f6:a506:4eb with SMTP id d9443c01a7336-1f6a5a86af6mr52503395ad.60.1717639852405;
        Wed, 05 Jun 2024 19:10:52 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd7ed6desm2189245ad.243.2024.06.05.19.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 19:10:51 -0700 (PDT)
Date: Thu, 6 Jun 2024 10:10:44 +0800
From: Hangbin Liu <liuhangbin@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jianguo Wu <wujianguo106@163.com>,
	wujianguo <wujianguo@chinatelecom.cn>, netdev@vger.kernel.org,
	edumazet@google.com, contact@proelbtn.com, pablo@netfilter.org,
	dsahern@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH net v2 2/3] selftests: add selftest for the SRv6 End.DX4
 behavior with netfilter
Message-ID: <ZmEapORjk3v3FYke@Laptop-X1>
References: <20240604144949.22729-1-wujianguo@chinatelecom.cn>
 <20240604144949.22729-3-wujianguo@chinatelecom.cn>
 <Zl_OWcrrEipnN_VP@Laptop-X1>
 <eaf06c77-2457-46fc-aaf1-fb5ae0080072@163.com>
 <20240605173532.304798bd@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605173532.304798bd@kernel.org>

On Wed, Jun 05, 2024 at 05:35:32PM -0700, Jakub Kicinski wrote:
> On Wed, 5 Jun 2024 11:28:17 +0800 Jianguo Wu wrote:
> > > sysctl: cannot stat /proc/sys/net/netfilter/nf_hooks_lwtunnel: No such file or directory
> > > Warning: Extension rpfilter revision 0 not supported, missing kernel module?
> > > iptables v1.8.9 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING
> > >   
> > 
> > What is your kernel version? The file was introduced from v5.15-rc1
> > 
> > > Looks we are missing some config in selftest net/config.
> > >   
> > 
> > Sorry, I can't find what config to add, please tell me.
> 
> Please follow the instructions from here:
> https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style
> the kernel we build for testing is minimal.
> 
> We see this output:
> 
> # ################################################################################
> # TEST SECTION: SRv6 VPN connectivity test with netfilter enabled in routers
> # ################################################################################

If I run the test specifically, I also got error:
sysctl: cannot stat /proc/sys/net/netfilter/nf_hooks_lwtunnel: No such file or directory

This is because CONFIG_NF_CONNTRACK is build as module. The test need to load
nf_conntrack specifically. I guest the reason you don't have this error is
because you have run the netfilter tests first? Which has loaded this module.

> # Warning: Extension rpfilter revision 0 not supported, missing kernel module?
> # iptables v1.8.8 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING
> # Warning: Extension rpfilter revision 0 not supported, missing kernel module?
> # iptables v1.8.8 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING

Just checked, we need CONFIG_IP_NF_MATCH_RPFILTER=m in config file.

Thanks
Hangbin
