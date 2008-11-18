From: "Frank Bulk" <frnkblk@iname.com>
Subject: RE: conntrack ftp fails to handle PORT (and PASV?) command when split over multiple TCP packets
Date: Mon, 17 Nov 2008 20:36:11 -0600
Message-ID: <!&!AAAAAAAAAAAuAAAAAAAAAKTyXRN5/+lGvU59a+P7CFMBAN6gY+ZG84BMpVQcAbDh1IQAAAATbSgAABAAAADCtTUdIJ84Q59fOlKySo0wAQAAAAA=@iname.com>
References: <!&!AAAAAAAAAAAuAAAAAAAAAKTyXRN5/+lGvU59a+P7CFMBAN6gY+ZG84BMpVQcAbDh1IQAAAATbSgAABAAAACjGmKcXUZtSrl15MejBLj+AQAAAAA=@iname.com> <49220C89.4040801@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Philip Craig'" <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.mtcnet.net ([199.120.69.26]:60658 "EHLO smtp1.mtcnet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYKRCg3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 21:36:29 -0500
In-Reply-To: <49220C89.4040801@snapgear.com>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip:

Thanks for the pointer to frox.

I'm not sure if the DSL modem vendor would add in this piece of opensource
software to their box, but we'll see.

Regards,

Frank

-----Original Message-----
From: Philip Craig [mailto:philipc@snapgear.com] 
Sent: Monday, November 17, 2008 6:30 PM
To: Frank Bulk
Cc: netfilter-devel@vger.kernel.org
Subject: Re: conntrack ftp fails to handle PORT (and PASV?) command when
split over multiple TCP packets

Frank Bulk wrote:
> Can anyone confirm that iptables still behaves this way, and if so, code a
> fix so that no matter how many packets a PORT or PASV command are split
over
> (in other words, no matter how small the client's MTU) that iptables ACKs
> each packet received on the LAN side and the ALG properly reassembles the
> command and sends it out the WAN interface?

iptables is a packet filter, not an ALG.  You could add more state to the
helper, but it would be hard to get right, and I don't think it is worth
the effort.  Try using a userspace ftp proxy instead.  (eg I've used frox
with no problems.)


