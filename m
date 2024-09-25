Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7571D5AA5;
	Wed, 25 Sep 2024 12:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266724; cv=none; b=UXBAYArw0ZEddM936LknKdJSvOvl5nxvbHz4bV8Th/YmcLeet2uDIB+NYY9ZXWE2h09Y+UgF+GFsao+AllVKIv29yQru0Wv7GxtLt3iCfkga+RDCUUP6g2u5E6ZnXY/EOt0cgCwlErQJifKl/aU8oA2YLMqOUKdxfvXonkpwjrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266724; c=relaxed/simple;
	bh=s3YSUa2IiULzJiw6XSiOlweurXkEkKS09tKVZbzxjAI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FA1dWCPizvrr6uOaactPj8nVuWhyflHgpBpIALwHO885EssDvp3WQYNpq3dz97daq6KszLi2b9f9sUcxohdjuTyM70JnJJhhBHOrP43Klyd7EToF1S/3zuE3+IFpQW76M2OZZDoFKCV/DLSF8NjL4EmO2KQp+R7yMIIF/IS/6B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=57572 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stQyX-0006n8-DN; Wed, 25 Sep 2024 14:18:35 +0200
Date: Wed, 25 Sep 2024 14:18:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	lwn@lwn.net
Subject: [ANNOUNCE] libnetfilter_conntrack 1.1.0 release
Message-ID: <ZvP_mG-yKnnNOlkB@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LUh22oYdKkjy2MC5"
Content-Disposition: inline
X-Spam-Score: -1.9 (-)


--LUh22oYdKkjy2MC5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project presents:

        libnetfilter_conntrack 1.1.0

This release includes:

- Enhancements for filtering dump and flush commands,
  see struct nfct_filter_dump and nfct_nlmsg_build_filter().
- ctnetlink event BPF fixes (endianness issue, IPv6 matching) and
  enhancements (zone matching).
- fix for musl compilation.

See ChangeLog that comes attached to this email for more details.

You can download it from:

https://www.netfilter.org/projects/libnetfilter_conntrack/downloads.html

NB: This release has switched to tar.xz files.

--LUh22oYdKkjy2MC5
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="changes-libnetfilter_conntrack-1.1.0.txt"

Felix Huettner (2):
      dump: support filtering by zone
      conntrack: support flush filtering

Jeremy Sowden (5):
      conntrack: fix BPF code for filtering on big-endian architectures
      conntrack: simplify calculation of `struct sock_fprog` length
      conntrack: increase the length of `l4proto_map`
      Ignore `configure~`
      conntrack: fix BPF for filtering IPv6 addresses

Pablo Neira Ayuso (7):
      conntrack: add sanity check to netlink socket filter API
      src: reverse calloc() invocation
      conntrack: api: bail out if setting up filter for flush/dump fails
      conntrack: mnl: clean up check for mismatching l3num and tuple filter
      conntrack: update link to git repository
      src: remove unused parameter from build functions
      libnetfilter_conntrack: bump version to 1.1.0

Peter Fordham (1):
      configure: C99 compatibility issues

Phil Sutter (3):
      expect/conntrack: Avoid spurious covscan overrun warning
      Makefile: Create LZMA-compressed dist-files
      conntrack: bsf: Do not return -1 on failure

Priyankar Jain (1):
      conntrack: Add zone filtering for conntrack events

Robert Marko (1):
      conntrack: fix build with kernel 5.15 and musl

Romain Bellan (2):
      Adding NFCT_FILTER_DUMP_TUPLE in filter_dump_attr, using kernel CTA_FILTER API
      utils: add NFCT_FILTER_DUMP_TUPLE example


--LUh22oYdKkjy2MC5--
