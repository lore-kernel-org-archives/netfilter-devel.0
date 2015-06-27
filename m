From: WaaX <waax@oonux.com>
Subject: IPSet target SET subnet options
Date: Sat, 27 Jun 2015 16:43:59 +0200
Message-ID: <558EB6AF.5090402@oonux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx.oonux.net ([88.186.162.21]:4998 "HELO mx.oonux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751712AbbF0Otb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Jun 2015 10:49:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I hve explored the manual of SETtarget:

      SET target options:
--add-set name flags [--exist] [--timeout n]
--del-set name flags
          add/del src/dst IP/port from/to named sets,
where flags are the comma separated list of
'src' and 'dst' specifications.

I can not find solution for add a subnet mask to a hash:net with the target.

Thanks for reading.

