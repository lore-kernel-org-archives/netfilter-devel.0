From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: conntrack-tools: fscanf() call usage
Date: Mon, 29 Aug 2011 10:00:36 +0200
Message-ID: <201108291000.36197.thomas.jarosch@intra2net.com>
References: <201108251422.59027.thomas.jarosch@intra2net.com> <CAFpsybkfNj9DctsBkpEpOXd5Y0vGMVSC7nxKU7hWhNKZTNrTSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Philip Craig <philipjcraig@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs04.intra2net.com ([85.214.66.2]:56551 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1H2IAj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:00:39 -0400
In-Reply-To: <CAFpsybkfNj9DctsBkpEpOXd5Y0vGMVSC7nxKU7hWhNKZTNrTSQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday, 26. August 2011 03:45:29 Philip Craig wrote:
> > Simple PoC can be found here:
> > http://marc.info/?l=gimp-developer&m=129567990905823&w=2
> 
> This looks like a bug in scanf, I suggest fixing it there. I don't know
> why the cppcheck authors decided that all the users needed fixing.
>
> ...
>
> Working around the problem in every program that uses scanf is not the
> right thing to do.

Right. I'll contact the glibc maintainers this week, it looks like an issue
with scanf(). One guy from cppcheck tried the same scanf() code
on another platform and there was no crash detectable.

Best regards,
Thomas
