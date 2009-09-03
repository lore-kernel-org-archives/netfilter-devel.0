From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/3] Add new input plugin UNIXSOCK
Date: Fri, 4 Sep 2009 01:54:42 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909040147210.29902@obet.zrqbmnf.qr>
References: <alpine.LSU.2.00.0908240031330.30556@fbirervta.pbzchgretzou.qr> <1252013004-9029-2-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39990 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbZIDADf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Sep 2009 20:03:35 -0400
In-Reply-To: <1252013004-9029-2-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-09-03 23:23, Pierre Chifflier wrote:
>+#include <ulogd/ulogd.h>
>+
>+/* Default size of the receive buffer for the unix socket
>+   0 means that ulogd will use getsockopt(SO_RCVBUF) to determine it
>+   at runtime */
>+#define UNIXSOCK_BUFSIZE_DEFAULT	0
>+
>+/* Default unix socket path */
>+#define UNIXSOCK_UNIXPATH_DEFAULT	"/tmp/ulogd2.sock"

That does not look like a good default path, though it might be
configurable at runtime. It seems that, because sockets are
world-connectable by default, random users could spam your socket.

Subsequently, there also seems to be an easy DoS whereby a user process 
only needs to connect to block a legitimate program from sending packets 
to the module.

Finally, but this is not so much of a problem, a user could also create 
ulogd2.sock first and then receive potentially interesting packets from 
a legitimate program that thought it would connect to ulogd2.

I would just move it out to, for example, /var/run/ulogd/ulogd2.sock
so one can set restrictions on /var/run/ulogd as needed.

What are your thoughts?
