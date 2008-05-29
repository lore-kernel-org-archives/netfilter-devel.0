From: "Sarge Gorden" <metalblade@gmail.com>
Subject: About IPSec ALG
Date: Thu, 29 May 2008 17:31:48 +0800
Message-ID: <182d06220805290231w314e2f16v4f38bfde69055e6f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:54539 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYE2Jbt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2008 05:31:49 -0400
Received: by an-out-0708.google.com with SMTP id d40so48873and.103
        for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2008 02:31:48 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

Now I was using a Linux box as a gateway (Ver: 2.6.18). But without
NAT-T there gona some problems when connecting a L2TP-over-IPSec VPN
server.
I wonder if there's a "IPSec ALG" could port into the kernel. (Just
like ip_conntack_ipsec/ip_nat_ipsec)
Is there is a patch availiable now?

Thanks.
