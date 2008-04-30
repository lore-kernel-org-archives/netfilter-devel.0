From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: Conntrackd segfaults
Date: Wed, 30 Apr 2008 15:06:29 +0200
Message-ID: <20080430130629.GA9978@outback.rfc2324.org>
References: <20080428214328.GB17500@outback.rfc2324.org> <4817183F.1090701@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rfc2324.org ([89.149.194.216]:60600 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbYD3NGa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:06:30 -0400
Received: from max by rfc2324.org with local rfc2324.org Mailserver
	id 1JrC0z-0004Ao-9C
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Apr 2008 15:06:29 +0200
Content-Disposition: inline
In-Reply-To: <4817183F.1090701@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am Tuesday, den 29 April hub Pablo Neira Ayuso folgendes in die Tasten:

Hi Pablo!

> Maximilian Wilhelm wrote:
> > The problem seems to be that in

> >  libnetfilter-conntrack /src/conntrack/getter.c

> > in line 225

> >  get_attr get_attr_array[]

> > has no entry for

> >  ATTR_MASTER_IPV4_SRC

> > Maybe anybody who's in this magic can fix it :)

> Fixed in SVN. Thanks for the detailed report.

Thanks for the fast response!

Ciao
Max
-- 
	Follow the white penguin.
