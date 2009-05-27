From: sachin sanap <sachin.sanap.1gb@gmail.com>
Subject: BRIDGE_NF_EBTABLES dependency on BRIDGE_NETFILTER
Date: Wed, 27 May 2009 14:58:02 +0530
Message-ID: <17923cc80905270228s4e5591e4ja03ad433dbf61c8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: buytenh@wantstofly.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:40337 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670AbZE0J2B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 05:28:01 -0400
Received: by gxk10 with SMTP id 10so7600845gxk.13
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2009 02:28:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Iam using 2.6.29.2 kernel and I dont understand why is
BRIDGE_NF_EBTABLES dependent on BRIDGE_NETFILTER in
net/bridge/netfilter/Kconfig ? I can remove the dependency and
successfully compile the kernel with BRIDGE_NF_EBTABLES on and
BRIDGE_NETFILTER off.
Does net/bridge/netfilter/Kconfig need an update or iam missing
something obvious?

Thanks
-Sachin
