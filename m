From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: ulogd - long living connections
Date: Tue, 31 Jul 2012 20:27:29 -0700
Message-ID: <CAAJpzgYSo5_sXunijxBBdWrJET1hLJ8gPw0WLZod-m4jxZHosw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41475 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab2HAD1u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Jul 2012 23:27:50 -0400
Received: by obbuo13 with SMTP id uo13so11571678obb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Jul 2012 20:27:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I feel current ulogd based accounting has some issues. It provides the
account usage during the destroy event. This is an issue for long
living connections, like alerting the user when he exceeds the quota.
I read the solution from the pdf published by Herald, 2005.

Snippet is given below

To overcome limitation number one, the accounting process can use a
combined event and polling scheme. The granularity of accounting can
therefore be configured by the polling interval,
and a compromise between performance and accuracy can be made.

Current ulogd2 has not yet have the functionality. The reason is,
polling based accounting does not provide any unique id for a
particular connection. So even if we generate polling based data and
event based data, there is no way to combine the data. If you guys
already thought about solution for this problem, can you share it? I
would like to work on. Otherwise I will come with my solution and I
will get advice from you guys.

Thanks & Regards,
