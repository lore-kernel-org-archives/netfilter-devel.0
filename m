From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: none zero check of the classid in xt_cgroup
Date: Sat, 16 Aug 2014 10:11:36 +0400
Message-ID: <53EEF618.6020103@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26140 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaHPGLn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2014 02:11:43 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAD00KV2YJ7UK90@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Sat, 16 Aug 2014 07:11:31 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Daniel,

I have a question regarding xt_cgroup, again )

I'm interesting why did you add check for none zero id into 
cgroup_mt_check. With it, it's impossible
to introduce some rules, like -m cgroup ! --cgroup 0. It could be useful 
for end user, for example, to block
all processes which was under cgroups, but not whole traffic.
Of course it could be made by ROOT_CGROUP with none 0 classid, which 
will contain all processes in the system.
But, I think, in this case OS will be faced with little overhead to mark 
every packet.


-- 
Best regards,
Alexey Perevalov

