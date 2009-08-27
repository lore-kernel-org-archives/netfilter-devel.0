From: Edward Faulkner <ef@alum.mit.edu>
Subject: Failure to check array bounds in nethash
Date: Thu, 27 Aug 2009 12:59:52 -0400
Message-ID: <9044cb320908270959o5d531c8at7f54cd6f6bbdf1db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:1795 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZH0Q7u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:59:50 -0400
Received: by an-out-0708.google.com with SMTP id d40so1632636and.1
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2009 09:59:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I think I've found a bug in ip_set_nethash.c.  Within nethash_add(), we have:

	if (map->elements >= limit || map->nets[cidr-1] == UINT16_MAX)
		return -ERANGE;	
	if (cidr <= 0 || cidr >= 32)
		return -EINVAL;

First, this does bounds checking on "cidr" only after we have already
used "cidr" to do a lookup in "nets".

Second, the bounds check itself is insufficient, because "nets" has length 30:

struct ip_set_nethash {
        ...
	uint16_t nets[30];		/* nr of nets by CIDR sizes */
        ...
}

Therefore, any block of size /31 causes us to read off the end of the
array.  Later in the function, we write to this location too, causing
undefined behavior.  I went looking for bugs here because I was seeing
inconsistent behavior when adding /31 blocks to a nethash.  Sometimes
I can add them, and sometimes they fail with ERANGE.

-Ed
