From: Philip Craig <philipjcraig@gmail.com>
Subject: Re: conntrack-tools: fscanf() call usage
Date: Fri, 26 Aug 2011 11:45:29 +1000
Message-ID: <CAFpsybkfNj9DctsBkpEpOXd5Y0vGMVSC7nxKU7hWhNKZTNrTSQ@mail.gmail.com>
References: <201108251422.59027.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60420 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab1HZBpb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Aug 2011 21:45:31 -0400
Received: by gxk21 with SMTP id 21so2319906gxk.19
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2011 18:45:31 -0700 (PDT)
In-Reply-To: <201108251422.59027.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Sent: Thu 25 Aug 2011 22:22:58 EST

> Hi there,
>
> the conntrack-tools have an fscanf() call without a
> field width limit. There's a small issue with this:
>
> [conntrack-tools/src/conntrack.c:1875]: (warning) scanf
> without field width limits can crash with huge input data
>
> Simple PoC can be found here:
> http://marc.info/?l=gimp-developer&m=129567990905823&w=2

This looks like a bug in scanf, I suggest fixing it there. I don't know
why the cppcheck authors decided that all the users needed fixing.

> The code currently looks like this:
>     "if (fscanf(fd, "%d", &count) != 1) {"
>
>
> A limit to uint32 number of digits should be sane, also on 64bit machines.
> That should still give us enough conntrack entries - even for Jesper.
>
> I goofed around with scanf() some more and discovered that basically any
> field limit should do (even 2000+). Otherwise scanf() seems to use a fixed
> default buffer if the size is not known in advance.

The size limit is 0x200000. It's not clear to me yet what exactly is
causing this.

> Proposed change looks like this:
>     "if (fscanf(fd, "%10d", &count) != 1) {"
>
> Is that a sane thing to do or unnecessary?

Working around the problem in every program that uses scanf is not the
right thing to do.
