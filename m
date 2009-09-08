From: Pierre Chifflier <pchifflier@edenwall.com>
Subject: Re: [PATCH 2/3] Add new input plugin UNIXSOCK
Date: Tue, 8 Sep 2009 11:35:35 +0200
Message-ID: <20090908093534.GA17095@piche.inl.fr>
References: <alpine.LSU.2.00.0908240031330.30556@fbirervta.pbzchgretzou.qr>
 <1252013004-9029-2-git-send-email-chifflier@inl.fr>
 <alpine.LSU.2.00.0909040147210.29902@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pierre Chifflier <chifflier@inl.fr>,
	netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:50838 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbZIHJfr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2009 05:35:47 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0909040147210.29902@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 04, 2009 at 01:54:42AM +0200, Jan Engelhardt wrote:
> >+/* Default unix socket path */
> >+#define UNIXSOCK_UNIXPATH_DEFAULT	"/tmp/ulogd2.sock"
> 
> That does not look like a good default path, though it might be
> configurable at runtime. It seems that, because sockets are
> world-connectable by default, random users could spam your socket.
> 
> Subsequently, there also seems to be an easy DoS whereby a user process 
> only needs to connect to block a legitimate program from sending packets 
> to the module.


True, when using unix socket you always have to set path, permissions
and chown it  ...

Maybe this could even be an option of ulogd.conf: unixsock_perms and
unixsock_owner ?

> 
> Finally, but this is not so much of a problem, a user could also create 
> ulogd2.sock first and then receive potentially interesting packets from 
> a legitimate program that thought it would connect to ulogd2.
> 
> I would just move it out to, for example, /var/run/ulogd/ulogd2.sock
> so one can set restrictions on /var/run/ulogd as needed.

Indeed, the only drawback is that the plugin will fail if the parent
directory does not exist.

Pierre
