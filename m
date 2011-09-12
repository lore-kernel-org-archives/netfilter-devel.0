From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: conntrack-tools: fscanf() call usage
Date: Mon, 12 Sep 2011 12:57:38 +0200
Message-ID: <201109121257.38596.thomas.jarosch@intra2net.com>
References: <201108251422.59027.thomas.jarosch@intra2net.com> <CAFpsybkfNj9DctsBkpEpOXd5Y0vGMVSC7nxKU7hWhNKZTNrTSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Philip Craig <philipjcraig@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs04.intra2net.com ([85.214.66.2]:59368 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab1ILK5l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 06:57:41 -0400
In-Reply-To: <CAFpsybkfNj9DctsBkpEpOXd5Y0vGMVSC7nxKU7hWhNKZTNrTSQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday, 26. August 2011 03:45:29 Philip Craig wrote:
> > Proposed change looks like this:
> >     "if (fscanf(fd, "%10d", &count) != 1) {"
> > 
> > Is that a sane thing to do or unnecessary?
> 
> Working around the problem in every program that uses scanf is not the
> right thing to do.

This issue has been resolved upstream in glibc.
(http://sourceware.org/bugzilla/show_bug.cgi?id=13138)

Cheers,
Thomas
