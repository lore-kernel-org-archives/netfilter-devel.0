From: Josh Hunt <johunt@akamai.com>
Subject: ipset timeout values corrupt on set resize
Date: Tue, 19 Feb 2013 11:31:35 -0600
Message-ID: <5123B6F7.2050707@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:37254 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758678Ab3BSRkE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:40:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I just ran into this and figured I'd see if anyone else has hit the 
issue. If I create a set with timeouts enabled and then add entries to 
this set which requires a resize, the timeout values become corrupt.

Here's an example of what I'm doing:

ipset create foo hash:ip,port,ip maxelem 16536 timeout 600

Then I add ~16k entries to the set and I see things like this as I'm 
adding entries to the set:

Name: foo
Type: hash:ip,port,ip
Revision: 1
Header: family inet hashsize 2048 maxelem 16536 timeout 600
Size in memory: 268456
References: 0
Members:
2.0.3.233,tcp:9999,172.24.196.41 timeout 1610614
2.0.17.81,tcp:9999,172.24.196.41 timeout 596
2.0.21.190,tcp:9999,172.24.196.41 timeout 598
2.0.4.156,tcp:9999,172.24.196.41 timeout 1610879
2.0.6.132,tcp:9999,172.24.196.41 timeout 1611592

I believe this is resizing related b/c if I force the hashsize to 
something that won't get resized (ex: something >= maxelem) then I don't 
see this problem.

I noticed in the resize code there's a lot of casting from type_pf_elem 
to type_pf_telem, but haven't investigated yet to determine the root 
cause of the problem.

I've reproduced this on kernel 3.2 with the latest ipset userspace utils 
6.16.1.

Thanks for any help
Josh
