From: Dale Floer <dfloer@gmail.com>
Subject: Does ip_conntrack_tcp_be_liberal have security or other issues when used?
Date: Thu, 16 Jun 2011 15:32:36 -0700
Message-ID: <BANLkTikuk870X_yBAvVez4_4qPo63su9HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39797 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab1FPWch (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 18:32:37 -0400
Received: by gxk21 with SMTP id 21so1010725gxk.19
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2011 15:32:36 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A simple question (I hope), but I can't seem to find any official
guidance on it while scouring the web.
What I'm wondering is if there are any issues associated with enabling
ip_conntrack_tcp_be_liberal, such as security (this is probably the
biggest one for me), stability performance or other issues related to
its usage. And if there currently aren't any issues, have there been
issues in the past with older versions?

Thanks, and I hope that this was the correct list,
-Dale Floer
