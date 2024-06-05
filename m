Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0F01922C4;
	Wed,  5 Jun 2024 07:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717572237; cv=none; b=CoEAOSRcYTlx29BUCz6ePUdWVhv651uRMJfYF/uJbCzTrtJDAQUPH2nwFU6fs62qA7YlFidlyN6tC0LXZbq1cyEG7zuuJJX7MyioFQpjde3i5NheLEwFapInsAt49SfC1psMGLStvUXVODxbsPvbAHznNF0Z30iL7gMWFiaL/oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717572237; c=relaxed/simple;
	bh=uzVX+85G30jpYfmvNpHScHtFMu96CLs0J8lGcPyao5k=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=k/in+A2PwlvxUxMwuoy++aNt7sGeu8bzEKPdwA7JK2ChuTVwElBh8Fq53MvG4Nl6syV0Kp58gig1EYtdLN2gZO9Zi1bPkOBKhs9Ctfcyx4rRLzB1FB1InSdnbrahVzvSK5ki8s89CWUAyBRZNgy+68jT4unX5LcxEYjDlBV2UvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id A7C9FCC0108;
	Wed,  5 Jun 2024 09:23:51 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Wed,  5 Jun 2024 09:23:49 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 6E131CC00F5;
	Wed,  5 Jun 2024 09:23:49 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 5897734316B; Wed,  5 Jun 2024 09:23:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 56D0E34316A;
	Wed,  5 Jun 2024 09:23:49 +0200 (CEST)
Date: Wed, 5 Jun 2024 09:23:49 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.22 released
Message-ID: <e438feea-1d3a-391c-2a89-6840fe6a3efe@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi,

I'm happy to announce ipset 7.22, which fixes a bug in the 7.21 package 
and a race condition between namespace cleanup and the garbage collector 
of the list:set type. Also, it corrects the json output format for IP 
address ranges.

If you installed the kernel part of the 7.21 package, please upgrade: the 
last patch in that series caused a memory leak due to not removing 
existing sets in namespace setups.

Userspace changes:
  - ipset: fix json output format for IPSET_OPT_IP (Z. Liu)
  - tests: add namespace test and take into account delayed
    set removal at module remove
  - Update autoconfig tools to build cleanly on Debian bookworm

Kernel part changes:
  - netfilter: ipset: Fix race between namespace cleanup and gc
    in the list:set type
  - netfilter: ipset: Add list flush to cancel_gc (Alexander Maltsev)
  - Kill sched.h dependency on rcupdate.h (Kent Overstreet)
  - Handle "netfilter: propagate net to nf_bridge_get_physindev" patch
  - netfilter: propagate net to nf_bridge_get_physindev (Pavel Tikhomirov)
  - Revert "netfilter: ipset: remove set destroy at ip_set module removal"

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
