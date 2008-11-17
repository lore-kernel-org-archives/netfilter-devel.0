From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack ftp fails to handle PORT (and PASV?) command when
 split over multiple TCP packets
Date: Mon, 17 Nov 2008 12:08:33 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0811171152450.15405@blackhole.kfki.hu>
References: <!&!AAAAAAAAAAAuAAAAAAAAAKTyXRN5/+lGvU59a+P7CFMBAN6gY+ZG84BMpVQcAbDh1IQAAAATbSgAABAAAACjGmKcXUZtSrl15MejBLj+AQAAAAA=@iname.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Frank Bulk <frnkblk@iname.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:42038 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYKQLIf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 06:08:35 -0500
In-Reply-To: <!&!AAAAAAAAAAAuAAAAAAAAAKTyXRN5/+lGvU59a+P7CFMBAN6gY+ZG84BMpVQcAbDh1IQAAAATbSgAABAAAACjGmKcXUZtSrl15MejBLj+AQAAAAA=@iname.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 15 Nov 2008, Frank Bulk wrote:

> I'm working with the tech support of a residential DSL modem vendor on a NAT
> issue.  The vendor says they use open source in their products and the logs
> show all the typical iptables entries.  
> 
> We're using a DSL modem for OOB management of our DSLAMs.  We access the
> DSLAM from the internet via the DSL modem's public IP which has been
> configured with a DMZ to hit the DSLAM on its private IP.  We can access the
> DSLAM via telnet and http, there's no problem there.
> 
> The problem occurs when we perform a configuration backup of the DSLAM.  The
> DSLAM has a built-in (DSLAM vendor written?) FTP client that uploads the
> configuration to our FTP server.  What's unique is that the DSLAM vendor's
> FTP client issues each FTP command separately from the closing CRLF
> ("\r\n").  For example, when the DSLAM logs in it first issues "LOGIN
> username" in one packet, and then "\r\n" in the next packet.  Attached to
> this post is a trace (I removed the login section to protect the user
> credentials) where you can see this happening in packets #1 and #3.
> According to the DSLAM vendor it shouldn't matter if the FTP client sends
> the command character-by-character in separate packets or in one packet.
> That's no problem for non-NATed DSLAMs because the FTP server is supposed to
> wait for the closing CRLF, but it appears that iptables doesn't handle the
> situation well.

Yes, the FTP connection tracking module expects to receive the FTP 
commands and the terminating CR character in one packet. If that's not 
true, then FTP connection tracking won't work.
 
> Can anyone confirm that iptables still behaves this way, and if so, code a
> fix so that no matter how many packets a PORT or PASV command are split over
> (in other words, no matter how small the client's MTU) that iptables ACKs
> each packet received on the LAN side and the ALG properly reassembles the
> command and sends it out the WAN interface?

Anybody is free to improve netfilter/iptables. But I strongly doubt that 
this case could be fixed easily.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
