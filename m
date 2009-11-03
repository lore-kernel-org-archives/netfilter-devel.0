From: Eric Branson <bransone@ecs.csus.edu>
Subject: questions regaring ARP, NFQUEUE, and enumerations
Date: Tue, 3 Nov 2009 12:57:34 -0800 (PST)
Message-ID: <31194109.4191257281854408.JavaMail.root@venus.ecs.csus.edu>
References: <16093171.4171257281805745.JavaMail.root@venus.ecs.csus.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.csus.edu ([130.86.90.246]:47627 "EHLO smtp2.csus.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbZKCVHm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:07:42 -0500
Received: from venus.ecs.csus.edu (venus.ecs.csus.edu [130.86.75.241])
	by hera.ecs.csus.edu (8.13.1/8.13.1) with ESMTP id nA3KvZAj002318
	for <netfilter-devel@vger.kernel.org>; Tue, 3 Nov 2009 12:57:40 -0800
Received: from localhost (localhost.localdomain [127.0.0.1])
	by venus.ecs.csus.edu (Postfix) with ESMTP id 1C62C470002
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2009 12:57:35 -0800 (PST)
Received: from venus.ecs.csus.edu ([127.0.0.1])
	by localhost (venus.ecs.csus.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rHj1YVD6mHpV for <netfilter-devel@vger.kernel.org>;
	Tue,  3 Nov 2009 12:57:34 -0800 (PST)
Received: from venus.ecs.csus.edu (venus.ecs.csus.edu [130.86.75.241])
	by venus.ecs.csus.edu (Postfix) with ESMTP id 7AFCA470001
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2009 12:57:34 -0800 (PST)
In-Reply-To: <16093171.4171257281805745.JavaMail.root@venus.ecs.csus.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I want to capture ARP packets on ingress but I am having trouble understanding the current netfilter architecture. I have not been able to receive any ARP packets through NFQUEUE (using `arptables -A INPUT -j QUEUE`) using a modified nfqnl_test and I was wondering if this is currently supported or even possible. If so, what type of modifications must be made to nfqnl_test.c to receive them? Am I going to have to write a kernel module similar to ip_queue.c? (If its more complicated than that just say so; I'm still wrapping my head around the network and netfilter subsystems.)

Following nfqnl_test.c I see that both nfq_open() and nfq_bind_pf() use AF_* enumerations, but nfqnl_recv_config() within the kernel, which I assume ultimately receives the NFQA_CFG_CMD message, indexes queue_handler with the given AF_* but would seem to expect NFPROTO_* enumerations, which are different (such as AF_AX25 and NFPROTO_ARP). Which enumeration is supposed to be used, AF_* or NFPROTO_*?

-- 
Eric Branson
California State University, Sacramento
