Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10428CA7D;
	Wed, 31 Jan 2024 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706719163; cv=none; b=d3TlVLRnuymfwbFk+LEoim79J+VLWkzHliF5cSzQc/Tf/AX4+QH5eBJhgRm/4dvq2HEcrIhGdCMzaxHzo5ZPS0C77/wRDREkHAr0199J1mwtWnaamsDxDrjs4Jli5859P8+eqi6wLUKp3g5RMWAxrWb5EGR2XUUhXNpWA1JWvck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706719163; c=relaxed/simple;
	bh=0ZR+TbB36aALBLX5GB1koBWKe8S5jdoE+JEMDrBjjDg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=N8JA5HKt573D9aP2YpNhTrbgMbKGU0zW0UsGwh+Ug6DpkAzsYSanJSob5Uy4bDfrz3YA1rMFXNAOG3jERW9TmjNP1oe06H67h+7JbezRcl8uHHhU+prFgVchJJTtnntFE+Hx5d7BTBW6vBsBjFOTRntbYe8ZaGADTd2V7UzxZIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id E8344CC02C1;
	Wed, 31 Jan 2024 17:39:09 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Wed, 31 Jan 2024 17:39:07 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id AC5BDCC02BF;
	Wed, 31 Jan 2024 17:39:06 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id CE639343167; Wed, 31 Jan 2024 17:39:06 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id CCDFE343166;
	Wed, 31 Jan 2024 17:39:06 +0100 (CET)
Date: Wed, 31 Jan 2024 17:39:06 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.20 released
Message-ID: <ab3a7d4c-7082-bd06-fb68-6cb62b3831ee@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi,

I'm happy to announce ipset 7.20: besides two json output corrections, it 
contains an important race condition fix between swap/destroy and kernel 
side add/del/test operation. In order to find the best solution to fix the 
issue without slowing down any operations and keeping the internal rules 
where execution may wait for concurrent operations to complete, there were 
several iterations of the patch.

Userspace changes:
  - Ignore *.order.cmd and *.symvers.cmd files in kernel builds
  - Bash completion utility updated
  - Fix json output for -name option (Mark)
  - Fix hex literals in json output
  - tests: increase timeout to cope with slow virtual test machine

Kernel part changes:
  - treewide: Convert del_timer*() to timer_shutdown*() (Steven Rostedt)
  - Use timer_shutdown_sync() when available, instead of del_timer_sync()
  - netfilter: ipset: fix race condition between swap/destroy and kernel
    side add/del/test v4
  - netfilter: ipset: fix race condition between swap/destroy and kernel
    side add/del/test v3
  - netfilter: ipset: fix race condition between swap/destroy and kernel
    side add/del/test v2
  - netfilter: ipset: fix race condition between swap/destroy and kernel
    side add/del/test

You can download the source code of ipset from:
        https://ipset.netfilter.org
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
