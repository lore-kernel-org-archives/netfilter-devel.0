From: Miguel Angel Ajo Pelayo <majopela@redhat.com>
Subject: conntrack-tool question for contribution.
Date: Wed, 16 Mar 2016 12:16:12 +0100
Message-ID: <CAC3B9fnKEGUsV_ir+7Y3wyy9C2KYDMbBaj-5emDhSN4V_F46DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36640 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966760AbcCPLQO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2016 07:16:14 -0400
Received: by mail-wm0-f41.google.com with SMTP id l124so44248848wmf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 04:16:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I was considering the possibility of making an small contribution to
conntrack-tool
to allow the batching of commands in a single conntrack-tool call.

Specifically I'm interested in batching delete commands.

In some of the neutron reference implementations we make use of conntrack-tool
to target and kill any active connection when security group rules are removed.

That sometimes expands in thousands of calls due to combinations (worst
scenario is n_port^2 calls for a very common type of rule we have).


So I was considering two options:

1) Adding a mode to accept conntrack-tool actions via stdin
2) Accepting the cmdline notation of separating multiple command lines
with "--" in a single call to conntrack tool.


Any thoughts or recommendations in this regard?


[1] http://git.openstack.org/cgit/openstack/neutron/tree/neutron/agent/linux/ip_conntrack.py#n32
