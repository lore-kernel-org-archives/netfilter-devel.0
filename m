From: Philip Craig <philipc@snapgear.com>
Subject: Re: conntrack ftp fails to handle PORT (and PASV?) command when split
 over multiple TCP packets
Date: Tue, 18 Nov 2008 10:30:01 +1000
Message-ID: <49220C89.4040801@snapgear.com>
References: <!&!AAAAAAAAAAAuAAAAAAAAAKTyXRN5/+lGvU59a+P7CFMBAN6gY+ZG84BMpVQcAbDh1IQAAAATbSgAABAAAACjGmKcXUZtSrl15MejBLj+AQAAAAA=@iname.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Frank Bulk <frnkblk@iname.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:47595 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750893AbYKRAaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:30:04 -0500
In-Reply-To: <!&!AAAAAAAAAAAuAAAAAAAAAKTyXRN5/+lGvU59a+P7CFMBAN6gY+ZG84BMpVQcAbDh1IQAAAATbSgAABAAAACjGmKcXUZtSrl15MejBLj+AQAAAAA=@iname.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Frank Bulk wrote:
> Can anyone confirm that iptables still behaves this way, and if so, code a
> fix so that no matter how many packets a PORT or PASV command are split over
> (in other words, no matter how small the client's MTU) that iptables ACKs
> each packet received on the LAN side and the ALG properly reassembles the
> command and sends it out the WAN interface?

iptables is a packet filter, not an ALG.  You could add more state to the
helper, but it would be hard to get right, and I don't think it is worth
the effort.  Try using a userspace ftp proxy instead.  (eg I've used frox
with no problems.)

