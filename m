From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [RFC} handling closed sockets from netfilter
Date: Thu, 6 Jun 2002 10:51:11 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020606085111.GA17615@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Yet another request for comments. I promise I'll stop with these soon. :)

So I've mentioned that I need a notification when a socket is closed. As
there are other parts in netfilter which might assign state to sockets
through setsockopt/getsockopt, I wanted to make the close callback as
general as possible.

I'm thinking about putting a close() function pointer into struct
nf_sockopt_ops, and call it from nf_sock_release (new function), which is
called from inet_release() when CONFIG_NETFILTER is defined.

This way any parts of netfilter might register a close callback. (even
conntrack might use it to deregister local sockets from the conntrack table)

Opinions?

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
