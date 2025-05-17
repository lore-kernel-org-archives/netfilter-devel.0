Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A5E36124;
	Sat, 17 May 2025 14:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747491503; cv=none; b=ddWbKSV/zNmjtIKuToKkAh6CUpFvOo/zqLrWlErAyYnzeCiGnFz65Z2NUuUHa4Q4JRdrUTuOyfw/6l1zgd4JCWghYsfORQSu6Gmyrl/WEkjhd2XsKi9v6Ko4SRsPxqnRmuBTElT+WSBEiJNTAvnJkDu3aWlHKfQFqQdl7TIu/Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747491503; c=relaxed/simple;
	bh=3Ms3uQ9OkmCBdcUOft7hQ+dcKpJ2PP0n6BeOTq8OA1s=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=cPO9udgdJ5kIIncWilob642/rSQcvOgsWvbNuevqnlQ4B99HWgGUz4edIDj8/upXHofO12jVCk1cgFNsB8OARkt8crKFyw4Te7VeWrWVMHM7gKsaV3brbeyezdwQixczzATgeK8FdJ6ld/d4uU42zrLUkpCC2VmUTRdImTtF57E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 93C2C19201B6;
	Sat, 17 May 2025 16:08:30 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id bwj59q2Nblcb; Sat, 17 May 2025 16:08:28 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (92-249-141-197.pool.digikabel.hu [92.249.141.197])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 556C6192019E;
	Sat, 17 May 2025 16:08:28 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 1296D14209B; Sat, 17 May 2025 16:08:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 0F65B1419A1;
	Sat, 17 May 2025 16:08:28 +0200 (CEST)
Date: Sat, 17 May 2025 16:08:28 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.24 released
Message-ID: <9a47a1a8-7ae4-53fd-cca7-044a78da4c7b@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: dunno 71%

Hi,

I'm happy to announce ipset 7.24 with brings a couple of json related 
output fixes and an important kernel side region locking fix for all hash 
types when timeouts are used.

Userspace changes:
  - Improve fixing commas in sorted json output
  - Fix extra quotes around elements in json output
    (bugzilla #1793, issue 3.)
  - Fix commas in sorted json output (bugzilla #1793, issue 4)
  - Fix unquoted port range in json output (bugzilla #1793, issue 1)
  - Fix extraneous comma in terse list json output (Joachim,
    bugzilla #1793, issue 2)
  - bash-completion: restore fix for syntax error (Jeremy Sowden)
  - Correct typo in man-page (Jeremy Sowden)

Kernel part changes:
  - netfilter: ipset: fix region locking in hash types
  - Handle "netfilter: ipset: Fix for recursive locking warning"
    patch for backward compatibility
  - netfilter: ipset: Fix for recursive locking warning

You can download the source code of ipset from:
        https://ipset.netfilter.org
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, 
         kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
