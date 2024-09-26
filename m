Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1A418E055;
	Thu, 26 Sep 2024 11:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727349108; cv=none; b=B8xgZfvIZPRuSJIoEAjru9RI6F3r2cH6QQQ8n1qe0dd4s6ek70uib3FAyZE0rtPhYCy60OBRSGhBOsflFX6t2uGDaV4RXaUC0eFjzKZjYPU6eST9eSTwamTzRf6uHCeBm7nJFeuR4WFXfQxTSJallQuf1/6ClAdtU4JSMgcfGI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727349108; c=relaxed/simple;
	bh=Hd9a3YTS/I0rjpWafWWmSUySKg4xgR6JddF/GR/fOH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LsCae0Evd1f1DgSEIVEyDzKo7Y0m9lWjMScNjeR2dljJuKBBUswWqYpfdpcV1uplw5yKsM2lOeOhJLNcXIaR7Wk1r1p386t8PGeOKqVTnIPrRhegrK+Y28NrEN+5KEUEjd7Z052Lz0VM0RLbrrW5a9ICACUy/gZwoe5Rsxn6PWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a93b2070e0cso98611566b.3;
        Thu, 26 Sep 2024 04:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727349105; x=1727953905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1lRKI+pMP8/1iPjpPpuSGYtG3NXW4g9chZgHhLGA+hg=;
        b=gHDp1Y/SPVm46n84tzpkAHH7LQQs2ifDFsmaSFz4sqM5XIvRvgHV4Lr0HCULoAqqYU
         vAdWsAvA0nCxLJTUbHrDEbZckrWPLz2OaTouN0cW8HMONUMJ4tjYJK9RVR/8g4+cX8UL
         ajr3qmO4l42ilXrSqMQyZvXpOGcV/ed3TLKwDDPH0q8Z1lJ2Hf9iJGnDd4Ev/vDKKPpL
         VlbAnQDuKRXYsQ889VUmXrwYZXL99bTcuDn06YS0CpYXrcGop8nVo4H11RmX9EWwm3CW
         tcWByc+pBFykq92+jJUhbcV1CzDJtn0sQYM9hHR9sEfSLY0YbNofSJkECbwB4laS9He3
         4CDw==
X-Forwarded-Encrypted: i=1; AJvYcCUgq695AY03JeREFy2msVVLpLsdv/iRK9bfQfYZr4QnczsnmXIDkZgPKnJx/0VDCHKYTvDks8nZakEXfdY=@vger.kernel.org, AJvYcCVNMt0Dd61u1Enm0JrN0bRIuhJq5xfcWI9WHkTYqFQdkjzt9Sw2wGBl+IA0xLDHO3MNJX+7BgqkGgmQ2T/gdGqo@vger.kernel.org, AJvYcCVmRctemfWS7mOjCp3a2eFP8sCzN8FI4yE5m9tvoYkKFFFCFJvIwLF6lpNb3DT7Mzzbu0BcYMja@vger.kernel.org
X-Gm-Message-State: AOJu0YwKupl431bGsZD6XgAWxay5GrVdR+Je4l9Ni/z5x9MlbpPCtx47
	4vB3Giog6zDyNUOy4DpR9oBvUehPy89g/MSvZpS8l3fm/adnm4YB
X-Google-Smtp-Source: AGHT+IHMfg/9pXGuI7BChFCF2ECTzROaHwkEc2utfCrOp9ZEoeQuUrgQ0MBai8iYTAnqLJTd0pBN3w==
X-Received: by 2002:a17:907:9606:b0:a8d:483f:5199 with SMTP id a640c23a62f3a-a93a066d8f8mr519263166b.58.1727349104876;
        Thu, 26 Sep 2024 04:11:44 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-009.fbsv.net. [2a03:2880:30ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9393134bc5sm334566766b.208.2024.09.26.04.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 04:11:44 -0700 (PDT)
Date: Thu, 26 Sep 2024 04:11:39 -0700
From: Breno Leitao <leitao@debian.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, rbc@meta.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <ZvVBawvMot9nu2jE@gmail.com>
References: <20240909084620.3155679-1-leitao@debian.org>
 <Zuq12avxPonafdvv@calendula>
 <Zuq3ns-Ai05Hcooj@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zuq3ns-Ai05Hcooj@calendula>

Hello Pablo,

On Wed, Sep 18, 2024 at 01:21:02PM +0200, Pablo Neira Ayuso wrote:
> Single patch to update them all should be fine.

I am planning to send the following patch, please let me know if you
have any concern before I send it:

Author: Breno Leitao <leitao@debian.org>
Date:   Thu Aug 29 02:51:02 2024 -0700

    netfilter: Make legacy configs user selectable
    
    This option makes legacy Netfilter Kconfig user selectable, giving users
    the option to configure iptables without enabling any other config.
    
    Make the following KConfig entries user selectable:
     * BRIDGE_NF_EBTABLES_LEGACY
     * IP_NF_ARPTABLES
     * IP_NF_IPTABLES_LEGACY
     * IP6_NF_IPTABLES_LEGACY
    
    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 104c0125e32e..b7bdb094f708 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -41,7 +41,13 @@ config NF_CONNTRACK_BRIDGE
 
 # old sockopt interface and eval loop
 config BRIDGE_NF_EBTABLES_LEGACY
-	tristate
+	tristate "Legacy EBTABLES support"
+	depends on BRIDGE && NETFILTER_XTABLES
+	default n
+	help
+	 Legacy ebtable packet/frame classifier.
+	 This is not needed if you are using ebtables over nftables
+	 (iptables-nft).
 
 menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1b991b889506..2c4d42b5bed1 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -12,7 +12,13 @@ config NF_DEFRAG_IPV4
 
 # old sockopt interface and eval loop
 config IP_NF_IPTABLES_LEGACY
-	tristate
+	tristate "Legacy IP tables support"
+	default	n
+	select NETFILTER_XTABLES
+	help
+	  iptables is a legacy packet classifier.
+	  This is not needed if you are using iptables over nftables
+	  (iptables-nft).
 
 config NF_SOCKET_IPV4
 	tristate "IPv4 socket lookup support"
@@ -318,7 +324,13 @@ endif # IP_NF_IPTABLES
 
 # ARP tables
 config IP_NF_ARPTABLES
-	tristate
+	tristate "Legacy ARPTABLE support"
+	depends on NETFILTER_XTABLES
+	default n
+	help
+	  arptables is a legacy packet classifier.
+	  This is not needed if you are using arptables over nftables
+	  (iptables-nft).
 
 config NFT_COMPAT_ARP
 	tristate
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index f3c8e2d918e1..e087a8e97ba7 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -8,7 +8,14 @@ menu "IPv6: Netfilter Configuration"
 
 # old sockopt interface and eval loop
 config IP6_NF_IPTABLES_LEGACY
-	tristate
+	tristate "Legacy IP6 tables support"
+	depends on INET && IPV6
+	select NETFILTER_XTABLES
+	default n
+	help
+	  ip6tables is a legacy packet classifier.
+	  This is not needed if you are using iptables over nftables
+	  (iptables-nft).
 
 config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
