Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55961078F;
	Thu,  6 Jun 2024 05:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717652822; cv=none; b=ryaLrbQjdgmf274DGGsk0yJXUVTkvX3Zkl+avn19juQepnLvJaZhwLwfgnnJEu/UuLr8PB75uw6fxRY+STRruf+BCYkZoPwrP2+zfVAL5mcmx2zzr4T9plWZfZ1a8KbX+h2KgOb2ztNRofTb13ekLVZ8nYu512Pu/ausVKD402Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717652822; c=relaxed/simple;
	bh=SfCDJ1okbikEn/zgezFk+5rGI1NJPy+aymoZWXlPCGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPGzNft56FmOijv+p4Ai+cnO1QxDnUBNKzUwA37e1qVioXaSCfk4o9XkpjaQ6XlaSnMBIosmFE9K6edPtOrA5TbyI+q99LeW0XcRL+loiHXXjXjZW84eQ6VEv92DSaxlA3hHcitMonXH5lK01XhmUR6J2nO8EYnxFCg01NUxC2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [31.221.188.228] (port=12096 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sF5xb-00BiWO-9Z; Thu, 06 Jun 2024 07:46:53 +0200
Date: Thu, 6 Jun 2024 07:46:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Hangbin Liu <liuhangbin@gmail.com>, Jianguo Wu <wujianguo106@163.com>,
	wujianguo <wujianguo@chinatelecom.cn>, netdev@vger.kernel.org,
	edumazet@google.com, contact@proelbtn.com, dsahern@kernel.org,
	pabeni@redhat.com, netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH net v2 2/3] selftests: add selftest for the SRv6 End.DX4
 behavior with netfilter
Message-ID: <ZmFNSbHqOF96LtVO@calendula>
References: <20240604144949.22729-1-wujianguo@chinatelecom.cn>
 <20240604144949.22729-3-wujianguo@chinatelecom.cn>
 <Zl_OWcrrEipnN_VP@Laptop-X1>
 <eaf06c77-2457-46fc-aaf1-fb5ae0080072@163.com>
 <20240605173532.304798bd@kernel.org>
 <ZmEapORjk3v3FYke@Laptop-X1>
 <20240605192309.591dfedb@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240605192309.591dfedb@kernel.org>
X-Spam-Score: -1.9 (-)

Hi,

On Wed, Jun 05, 2024 at 07:23:09PM -0700, Jakub Kicinski wrote:
> On Thu, 6 Jun 2024 10:10:44 +0800 Hangbin Liu wrote:
> > > Please follow the instructions from here:
> > > https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style
> > > the kernel we build for testing is minimal.
> > > 
> > > We see this output:
> > > 
> > > # ################################################################################
> > > # TEST SECTION: SRv6 VPN connectivity test with netfilter enabled in routers
> > > # ################################################################################  
> > 
> > If I run the test specifically, I also got error:
> > sysctl: cannot stat /proc/sys/net/netfilter/nf_hooks_lwtunnel: No such file or directory
> > 
> > This is because CONFIG_NF_CONNTRACK is build as module. The test need to load
> > nf_conntrack specifically. I guest the reason you don't have this error is
> > because you have run the netfilter tests first? Which has loaded this module.

Hm, this dependency with conntrack does not look good. This sysctl
nf_hooks_lwtunnel should be in the netfilter core. The connection
tracking gets loaded on demand, the availability of this sysctl is
fragile.

> Ah, quite possibly, good catch! We don't reboot between tests,
> and the VM must have run 10 or so other tests before.
> 
> > > # Warning: Extension rpfilter revision 0 not supported, missing kernel module?
> > > # iptables v1.8.8 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING
> > > # Warning: Extension rpfilter revision 0 not supported, missing kernel module?
> > > # iptables v1.8.8 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING  
> > 
> > Just checked, we need CONFIG_IP_NF_MATCH_RPFILTER=m in config file.
> 
> :( Must be lack of compat support then? I CCed netfilter, perhaps they
> can advise. I wonder if there is a iptables-nftables compatibility list
> somewhere.

iptables-nft potentially requires all CONFIG_IP_NF_MATCH_* and
CONFIG_IP_NF_TARGET_* extensions, in this new testcase it uses
rpfilter which seems not to be used in any of the existing tests so
far, that is why CONFIG_IP_NF_MATCH_RPFILTER=m is required.
