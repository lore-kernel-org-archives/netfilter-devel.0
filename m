From: Narendra Choyal <narendrachoyal@gmail.com>
Subject: iptables connlimit not works in RHEL 5.1
Date: Fri, 21 May 2010 00:30:07 +0530
Message-ID: <AANLkTilspYQiScZyBROF-x9nh54ju_KXMH9gHVUKNTQ8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59098 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab0ETTAJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 15:00:09 -0400
Received: by vws9 with SMTP id 9so176540vws.19
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2010 12:00:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

connlimit doesn't work on RHEL 5.1

and same command will works on all versions of Fedora

My command is

#iptables -A INPUT -p tcp --syn --dport -s X.X.X.X -m connlimit !
--connlimit-above 2 -j REJECT --reject-with -tcp-reset
