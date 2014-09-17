From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Conntrack TW->SS in Reply direction
Date: Wed, 17 Sep 2014 13:22:30 -0300
Message-ID: <5419B546.40702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbaIQQWc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:22:32 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8HGMWAw025383
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Sep 2014 12:22:32 -0400
Received: from localhost.localdomain (vpn1-4-148.gru2.redhat.com [10.97.4.148])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s8HGMVE1014403
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Sep 2014 12:22:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Any reason on why we don't allow TW->SS state change in reply direction? It is 
currently marked as (since ever it seems) in a comment:
  *  sTW -> sIV  Reopened connection, but server may not do it.

That is true but just if the server role is never swapped between hosts and I 
don't see it violating any spec by allowing it..

Thing is, there is this application that needs a connection as a callback on a 
specified port range. This application is used between 2 servers, using 
conntrack and only allowing in new connections and its (related) packets. 
There will be a moment that the port that once was server for the callback, 
will now originate a callback to the other server.

As Linux stack uses TIME_WAIT timeout as 1min and conntrack as 2mins, there 
will be a moment on which the port selection allows using a port that, for 
conntrack, is still not allowed...

Reducing conntrack's TIME_WAIT timeout is more complicated because it may 
restrain the compatibility with other implementations, but allowing TW->SS 
imposes no harm?

Thanks,
Marcelo
