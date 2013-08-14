From: Iain Fraser <iainkfraser@gmail.com>
Subject: Reset connection state to NEW
Date: Wed, 14 Aug 2013 02:38:06 +0100
Message-ID: <CA+bLfK6VUyV+Mteu6UmUzPzCQVVqWWY6uEVmqc-779-HTUoUBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47946 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708Ab3HNBiH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 21:38:07 -0400
Received: by mail-ob0-f170.google.com with SMTP id eh20so9481904obb.15
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2013 18:38:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Is it possible to reset conntrack connection back to the initial state
so it thinks the next packet is the first from userspace? I did a
google and noticed conntrack-tools
has a delete option but i'm not sure if this resets it in the
aforementioned manner.

Thanks in advance
Iain
