From: Tobias Koeck <tobias.koeck@gmail.com>
Subject: netfilter kernel modules question
Date: Mon, 14 Dec 2009 16:20:23 +0100
Message-ID: <4B2657B7.5070405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:11144 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbZLNPU0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2009 10:20:26 -0500
Received: by fg-out-1718.google.com with SMTP id e21so30437fga.4
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2009 07:20:25 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have two netfilter kernel modules (xt_RQS.c, xt_RQD.c, both include 
a header file with a data structure in it).

Does both kernel modules use the same datastructures or do they use 
seperate ones (in normal C programming I know that but I'm not sure 
about the kernel scopes).

If I want to use one datastructure how can I do that (export? - 
concurrency issues left aside)?

Greetings and thanks
