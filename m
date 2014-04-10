From: Jean Delvare <jdelvare@suse.de>
Subject: NETFILTER_XT_TARGET_NOTRACK
Date: Thu, 10 Apr 2014 14:05:11 +0200
Message-ID: <1397131511.25950.97.camel@chaos.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Michal Kubecek <mkubecek@suse.cz>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030282AbaDJMFO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:05:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I have a concern / question / suggestion regarding
NETFILTER_XT_TARGET_NOTRACK.

Currently, NETFILTER_XT_TARGET_NOTRACK merely selects
NETFILTER_XT_TARGET_CT, and does nothing else. This means that selecting
or not selecting NETFILTER_XT_TARGET_NOTRACK makes no difference, as
long as NETFILTER_XT_TARGET_CT itself is set.

I seem to understand that NETFILTER_XT_TARGET_NOTRACK was reintroduced
in kernel 3.8 to help migration to NETFILTER_XT_TARGET_CT. I understand
the logic, but this was 7 kernel versions / over 2 years ago. Wouldn't
it be the right time to finally remove NETFILTER_XT_TARGET_NOTRACK?

Alternatively, I find it curious that the compatibility code is
unconditionally built into xt_CT even when NETFILTER_XT_TARGET_NOTRACK
is not selected. Is it an overlook, or is it by design? I think it would
make sense to only build that compatibility code when
NETFILTER_XT_TARGET_NOTRACK is selected. In that case it would make
sense to keep NETFILTER_XT_TARGET_NOTRACK.

Thanks,
-- 
Jean Delvare
SUSE L3 Support

