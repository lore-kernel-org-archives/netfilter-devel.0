Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BA32744C;
	Mon, 12 Feb 2024 12:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707741031; cv=none; b=J5/DdWNB/YYYyxHh1gamMNdPUGj43u5xsX79La0zNSW89UV64EBrysDe21l4Rvw/I/v01h49xA1wvPrLHDyCctvGk5XsIR7HdI1Qo44ll/mpBlXYbVoywZOCOAzVHIAgTitfiGB6ld0nRPArdCK9d/LFItzJqZfStM7O9essbvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707741031; c=relaxed/simple;
	bh=zBAmlnEOWopuf+hOGUPdZufMds3Hr73nWWL1NCGH2Mw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=GiasZcQXtJ4BTQ0VDIFFPp4RnESq5BR0STKf0wTF4MIJVVHjatgBq9SU65Bo0B22g5xUzwkPnIXbttjYgDSemOxks7VkJmktGADk2S7HOcqnXiMJVGAF1xnWob72HMTwpMMAJUXww3Z3NdMe5C1P9miAN9A93okRvK/oIypqiBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id C8541CC02C5;
	Mon, 12 Feb 2024 13:21:38 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Mon, 12 Feb 2024 13:21:36 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 9FCBFCC02C3;
	Mon, 12 Feb 2024 13:21:36 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 82AD1343167; Mon, 12 Feb 2024 13:21:36 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 80EFB343166;
	Mon, 12 Feb 2024 13:21:36 +0100 (CET)
Date: Mon, 12 Feb 2024 13:21:36 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.21 released
Message-ID: <1ba45a29-609f-96b2-a8ce-184cd14e3879@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi,

I'm happy to announce ipset 7.21. The new release fixes bugs introduced 
unfortunately in 7.20: in the kernel part, one of the new stages of 
the destroy operation was not added to the module remove and set create 
error paths and in the userspace tool the "list" mode overrode the "save" 
mode. Here follows the full list of the changes between the two releases:

Userspace changes:
  - The patch "Fix hex literals in json output" broke save mode,
    restore it
  - Fix -Werror=format-extra-args warning
  - Workaround misleading -Wstringop-truncation warning

Kernel part changes:
  - netfilter: ipset: Suppress false sparse warnings
  - tests: Verify module unload when sets with timeout were just 
    destroyed
  - netfilter: ipset: remove set destroy at ip_set module removal
  - netfilter: ipset: Cleanup the code of destroy operation and explain
    the two stages in comments
  - netfilter: ipset: Missing gc cancellations fixed

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
