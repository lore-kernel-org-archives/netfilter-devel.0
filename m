From: David Hinkle <hinkle@cipafilter.com>
Subject: How to set connmark on a socket descriptor from userspace?
Date: Tue, 25 Aug 2015 14:14:36 -0500
Message-ID: <CACw4T0oawcgHdVkORUm9ONP2S8N+8_95ZCpDTMzHWmfKPZ5bQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:34798 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbbHYTOg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Aug 2015 15:14:36 -0400
Received: by ykdt205 with SMTP id t205so166346297ykd.1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2015 12:14:36 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I want to be able to set the connmark on a socket controlled by my
application from user space.  Is there an API to do that already?

I have been reviewing the kernel code and I can't seem to find one.
If there isn't, what would be your recommendation on the path to take
to implement such an option?  It looks like setsockopt shouldn't be
too hard to extend.  I guess extending ioctl or fcntl would be my
other options?  But I see at least one place where getsockopt already
interacts with conntrack data, handling SO_ORIGINAL_DST.

Advice, docs, and suggestions greatly appreciated.  Thank you for your time.

- David
