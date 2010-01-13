From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: BUG? a possible race between htable_find_get() and htable_put()
Date: Wed, 13 Jan 2010 11:51:49 +0900
Message-ID: <2014bcab1001121851g28e8e7d3x5ed3604b6854a0ed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:41185 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab0AMCvu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2010 21:51:50 -0500
Received: by pxi4 with SMTP id 4so5145724pxi.33
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2010 18:51:50 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi. I am reporting a suspected race between htable_find_get()
and htable_put() in net/netfilter/xt_hashlimit.c.

I found this issue while I read the code so that it might not realistic.
But, please examine the code to check possibility of race condition.

htable_put() first updates hinfo->use and then unlink the object from the list.
But, htable_find_get() first searches an object from the list,
and then updates hinfo->use.
Therefore, race would be possible for the following situation.

hinfo->use == 1.

htable_put()                                      |  htable_find_get()
--------------------------------------------------------------------------------------------------------------
  atomic_dec_and_test(&hinfo->use) ; |
                                                       |
spin_lock_bh(&hashlimit_lock) ;
                                                       |
hlist_for_each_entry(...) ;
                                                       | ...
                                                       |
atomic_inc(&hinfo->use) ;
                                                       |
spin_unlock_bh(&hashlimit_lock) ;
  spin_lock_bh(&hashlimit_lock) ;       |
  hlist_del(&hinfo->node) ;                  |
