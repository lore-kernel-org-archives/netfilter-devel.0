From: Laszlo Attila Toth <panther@balabit.hu>
Subject: unique function names in modules
Date: Sat, 20 Oct 2007 11:38:10 +0200
Message-ID: <4719CC82.6020205@balabit.hu>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:57773 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbXJTJiP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 05:38:15 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 452F2C12FF
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Oct 2007 11:38:13 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

In kernel v2.6.23 the function names in the netfilter modules are not 
unique. Is it changed anywhere later? If not, I'll send patches for this 
(currently I'm working on it).

--
Attila
