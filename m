Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD354207677;
	Mon, 16 Dec 2024 19:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734375954; cv=none; b=GkB1SLiKEu+gpa8oiNFlm7Gpy/Gfp9cgNpZtwbJE/rlX+svJ2IR+z0wk9dtHCAOseqMQRE6mCGuNKtZpErgPUzqommMapCV2vKKcRAYLWcn8XTLJHuCDdUflx9j4JFQUjiQDQRvbF7tHvt9U3lcd1tGqWYOZTPYuSC5MV6yUhtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734375954; c=relaxed/simple;
	bh=fcWhGrVEYhPa2x9U0xaIPXHRolHp0CpbmLSRFVZitc8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=j4pv1rv7ClxXQlAvMGrDCvS5pEMQKwppv3UDlWGpLqVlU7vyBInBjT18U8V2EH11jLcwf3ZZmtUL2EuCL7ZDUfDD2g2BfmrQ6A6M3ZYelejjpeyNWktBRFO8QPw2/Nfoc6qHC0eVry6wY1mZT+lAST9PiLdnykiNaqXWjqZUSPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 0D10232E01E4;
	Mon, 16 Dec 2024 20:00:38 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id Y1CBQZqaPO-P; Mon, 16 Dec 2024 20:00:35 +0100 (CET)
Received: from mentat.rmki.kfki.hu (78-131-74-17.pool.digikabel.hu [78.131.74.17])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id D1F1F32E01E3;
	Mon, 16 Dec 2024 20:00:35 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 98FC21424A2; Mon, 16 Dec 2024 20:00:35 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 952421413D1;
	Mon, 16 Dec 2024 20:00:35 +0100 (CET)
Date: Mon, 16 Dec 2024 20:00:35 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.23 released
Message-ID: <38a9d4fa-067f-320c-33e6-9edbb6acafdb@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: maybeham 5%

Hi,

I'm happy to announce ipset 7.23 which includes fixes in the kernel part 
and in the ipset tool and the tests:

Userspace changes:
  - tests: runtest.sh: Keep running, print summary of failed tests
    (Phil Sutter)
  - tests: cidr.sh: Fix for quirks in RHEL's ipcalc (Phil Sutter)
  - tests: cidr.sh: Respect IPSET_BIN env var (Phil Sutter)
  - ipset: Fix implicit declaration of function basename (Mike Pagano)
  - tests: Reduce testsuite run-time (Phil Sutter)
  - lib: ipset: Avoid 'argv' array overstepping (Phil Sutter)
  - lib: data: Fix for global-buffer-overflow warning by ASAN
    (Phil Sutter)

Kernel part changes:
  - netfilter: ipset: Hold module reference while requesting a module
    (Phil Sutter)
  - netfilter: ipset: add missing range check in bitmap_ip_uadt
    (Jeongjun Park)
  - netfilter: ipset: Fix suspicious rcu_dereference_protected()
  - Replace BUG_ON() with WARN_ON_ONCE() according to usage policy.

You can download the source code of ipset from:
        http://ipset.netfilter.org
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu,
         kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
