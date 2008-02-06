From: Justin McCann <jneilm@yahoo.com>
Subject: Get UID from netlink/conntrack
Date: Wed, 6 Feb 2008 12:30:07 -0800 (PST)
Message-ID: <438194.92391.qm@web30402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web30402.mail.mud.yahoo.com ([68.142.200.105]:24978 "HELO
	web30402.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756277AbYBFUgs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:36:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'd like to use libnetfilter_conntrack to track connections per UID and/or by PID, but AFAICT the nfnetlink conntrack messages don't include the user id, process id, or inode (useful for cross-referencing). I noticed that the nfnetlink_log messages have the uid, but I don't think I want to invoke the filtering & logging subsystem just to track connection changes.

If I were to add the UID and/or pid or inode to the conntrack messages, what's the right way to go about doing that? I realize I'd have to patch the kernel,  libnetfilter_conntrack, and conntrack-tools, but I'd like to do that in a way that won't break the messaging protocol for other applications if possible.

On the kernel side, I think this requires:
- make an additional enum ctattr_type (CTA_UID) 
- include that attribute in the IPCNTL_MSG_CT_{NEW,UPDATE,DELETE} messages
- add a ctnetlink_dump_uid() function, using NFA_PUT with the result of sock_i_uid(skb->sock)
- add the call to ctnetlink_dump_uid() in ctnetlink_fill_info()

With the appropriate mods in libnetfilter_conntrack, and maybe an option to the conntrack command line tool to output that info if requested. 

Is this the right way to go about it, and if so would that break anything in terms of backwards compatibility (e.g. programs using older versions of the libraries)? Any other reason not to do it?

Thanks,
   Justin McCann








      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
