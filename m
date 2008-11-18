From: Philip Craig <philipc@snapgear.com>
Subject: Re: conntrack ftp fails to handle PORT (and PASV?) command when split
 over multiple TCP packets
Date: Tue, 18 Nov 2008 13:32:11 +1000
Message-ID: <4922373B.9070605@snapgear.com>
References: <!&!AAAAAAAAAAAuAAAAAAAAAKTyXRN5/+lGvU59a+P7CFMBAN6gY+ZG84BMpVQcAbDh1IQAAAATbSgAABAAAACjGmKcXUZtSrl15MejBLj+AQAAAAA=@iname.com> <49220C89.4040801@snapgear.com> <!&!AAAAAAAAAAAuAAAAAAAAAKTyXRN5/+lGvU59a+P7CFMBAN6gY+ZG84BMpVQcAbDh1IQAAAATbSgAABAAAADCtTUdIJ84Q59fOlKySo0wAQAAAAA=@iname.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Frank Bulk <frnkblk@iname.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:57896 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751657AbYKRDcN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:32:13 -0500
In-Reply-To: <!&!AAAAAAAAAAAuAAAAAAAAAKTyXRN5/+lGvU59a+P7CFMBAN6gY+ZG84BMpVQcAbDh1IQAAAATbSgAABAAAADCtTUdIJ84Q59fOlKySo0wAQAAAAA=@iname.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Frank Bulk wrote:
> Thanks for the pointer to frox.
> 
> I'm not sure if the DSL modem vendor would add in this piece of opensource
> software to their box, but we'll see.

If you can insert the proxy between the DSLAM and the DSL modem, then
that would work too.  The proxy will rewrite the packets so that the
DSL modem doesn't see the split command.

Note that in either case, you'll have to avoid loading the ftp conntrack
helper on the proxy machine for this to work, which may mean you'll need
to use the TransparentData option for frox (but try without it first).
