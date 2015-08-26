From: Anton Danilov <littlesmilingcloud@gmail.com>
Subject: Re: How to set connmark on a socket descriptor from userspace?
Date: Wed, 26 Aug 2015 13:16:07 +0300
Message-ID: <CAEzD07+oRuQ=d6ASEU6faFvYoUpMmgS1CG480HcGKhYO+pKASQ@mail.gmail.com>
References: <CACw4T0oawcgHdVkORUm9ONP2S8N+8_95ZCpDTMzHWmfKPZ5bQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: David Hinkle <hinkle@cipafilter.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:33637 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbHZKQH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2015 06:16:07 -0400
Received: by ykll84 with SMTP id l84so181018617ykl.0
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2015 03:16:07 -0700 (PDT)
In-Reply-To: <CACw4T0oawcgHdVkORUm9ONP2S8N+8_95ZCpDTMzHWmfKPZ5bQQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.
Use the SO_MARK option in the your application and -j CONNMARK
--save-mark at mangle/OUTPUT.

2015-08-25 22:14 GMT+03:00 David Hinkle <hinkle@cipafilter.com>:
> I want to be able to set the connmark on a socket controlled by my
> application from user space.  Is there an API to do that already?
>
> I have been reviewing the kernel code and I can't seem to find one.
> If there isn't, what would be your recommendation on the path to take
> to implement such an option?  It looks like setsockopt shouldn't be
> too hard to extend.  I guess extending ioctl or fcntl would be my
> other options?  But I see at least one place where getsockopt already
> interacts with conntrack data, handling SO_ORIGINAL_DST.
>
> Advice, docs, and suggestions greatly appreciated.  Thank you for your time.
>
> - David
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Anton.
