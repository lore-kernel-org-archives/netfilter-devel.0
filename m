From: qhou <qhou_acornsoft@sohu.com>
Subject: Re:Re: Q: Any other way on handling "conntrack DESTROY" without ip_conntrack_destroyed()
Date: Tue, 9 Jul 2002 15:23:31 +0800 (CST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <2244491.1026199411988.JavaMail.postfix@mailsrv10.mail.sohu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


> What are you implementing? A layer four helper (like
> ip_conntrack_proto_tcp.c?)

I previously implemented one Match module,
and the trouble is: I need to release my own data when the conn_track is released.
For I don't want to use timeout to judge the conn_track's release.

> In CVS is a patch which adds a proto->destroy function to the l4 proto
> helpers (ip_conntrack_protocol_destroy.patch)

Now I implement one netfilter hook to trace the connection (TCP/UDP/*ICMP),
and use ioctl(), to get the UI operation. Feel silly I am :(



Thanks, Harald Welte.

Regards,
HouQing
