Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A0E19F13B
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2024 12:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732105771; cv=none; b=EnYSdPxljmIRWF3WCMnAs/Gd7M0r43CUh5uIZ4HqVxe8fIcdAnnjVybqyF2IMPRuJWf5xupi6m2MzeMCLECFc88uVSZc4xDf0ZY0A5LleB10VcGbfRptDpgDA4c2NGPCS2ovzFpmtGLCcvXrhXZGtKDXQDHNpqHYg6akqumsBs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732105771; c=relaxed/simple;
	bh=UZLjCc6wQTrsn0QehLNb1hBAWHPZMJDCvJBJDw/UJ/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/JwfKYZFVVL+EXHCpRTmwBORjXQwI0DzwcmRVVlYG+kCKK8nrkwWyXHsFzajaINcbg0ivX0wc4AJoUdJyZubhJw+WPYyv0Yqa+ADrL6d9TM1nehYwb0Co8DuIFXp6PzvQmmsQAru5lGKJHI2TpGDTdF3enXt13RTEtoiAcDbzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pykw7tfW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pykw7tfW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I8S27H/VA8V6KXo/T4DkPfmdv7XB5RSFXKA7+/ZuryA=; b=pykw7tfWeNjB264ubzznRnNDLb
	VfH8lP4iZxZgJH6XmE78bJ+X05gW0IdlEJM+cZNEx5C1/TOYIU+VOrQ+8TbZPRB8phWCEIF1TtP5z
	k+ZvUVcgkKkArFIBvRzSW7cxvGznmcypy0BpNv/ynBK6IaBhG08odSgr5SGUvezPoTCtlYYqCkP52
	YwXn2MCMYcNJL0qdvlumIT5FnLBzABc9KEKpFjHF02iPG+TzSwfq+2zOjj68nbTf8NsKN4P+n9euh
	1/KN0YXVo6tv05gh38tonidWabf+JnCWwhBZMdyCSzxUEncDGnKHox0BlXkKZz0PHPrnJYWFKjq7q
	kh0Msltg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tDjpl-000000007OO-2MC7;
	Wed, 20 Nov 2024 13:29:25 +0100
Date: Wed, 20 Nov 2024 13:29:25 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: iptables & nftables secmark unit-tests
Message-ID: <Zz3WJSUIW0ds-5W9@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20241119224608.GD3017153@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119224608.GD3017153@celephais.dreamlands>

Hi Jeremy,

On Tue, Nov 19, 2024 at 10:46:08PM +0000, Jeremy Sowden wrote:
> When running the test-suites for iptables and nftables, the secmark
> tests usually fail 'cause I don't have selinux installed and configured,
> and I ignore them.  However, I want to get the test-suites working with
> Debian's CI, so any pointers for how I need to set up selinux would be
> gratefully received.

That's odd, my VM for testing doesn't run selinux and the testsuites
still pass. The only thing I see is selinux support in the kernel
config:

CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
CONFIG_DEFAULT_SECURITY_SELINUX=y
CONFIG_LSM="yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor"

SELinux-ignorant as I am, I wasn't able to find a place which defines
selinux contexts/policies, no idea how the kernel validates the
'system_u:object_r:firewalld_exec_t:s0' used for iptables SECMARK
testing for instance. All I can tell is that we had to change this for
testing on RHEL.

HTH, Phil
