From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 0/5] nf conntrack protos pernet functionality v3
Date: Sun, 29 Mar 2009 01:33:29 +0300
Message-ID: <20090328223329.377542393@openvz.org>
Cc: netfilter-devel@vger.kernel.org, xemul@openvz.org,
	daniel.lezcano@free.fr
To: kaber@trash.net, adobriyan@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50021 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZC1WiI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:38:08 -0400
Received: by fxm2 with SMTP id 2so1478469fxm.37
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Mar 2009 15:38:06 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

here is a new attempt of bringing in per-net functionality
into nf conntrack protos. Please review and test if possible.

It's quite far from ideal solution Alexey proposed (to try to
shrink sysctl's manipulation in one place with all #ifdef
guardians we need) but I didn't manage to implement it right
way yet. So mostly at moment it looks like a code _bloat_ so
rejecting this series would be acceptable solution :)

ICMP v6 is not covered yet as well. Will be done.

Cyrill
