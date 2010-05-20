From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Any Performance benchmark on a Million conntracks
Date: Thu, 20 May 2010 18:21:45 +0530
Message-ID: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f171.google.com ([209.85.221.171]:52240 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab0ETMvr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 08:51:47 -0400
Received: by qyk1 with SMTP id 1so11987577qyk.5
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2010 05:51:45 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Is there any performance bench mark on conntrack response to 1 million
conntrack entries in the conntrack table.
Since conntrack uses Hashing to lookup the entries i had some doubts
on the scalability. Can someone shed some light please?
Thanks,
Anand
