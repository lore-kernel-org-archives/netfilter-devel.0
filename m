From: "Mordechai T. Abzug" <morty@frakir.org>
Subject: netfilter as ACL for SOCK_RAW, binding, netadmin
Date: Wed, 17 Dec 2003 22:00:59 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031218030059.GA15627@red-sonja.frakir.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I am aware of at least one kernel patch to introduce some type of ACLs
into port binding, making raw sockets, and doing assorted
administrative work.  Ie:

http://killa.net/infosec/acls/
http://folk.sourceforge.net/

However, this mechanism is clunky and inflexible.

Linux capabilities theoretically allow administrators to do similar
things.  But this approach requires FS support and login hooks that
either don't exist or are not in mainstream kernels.

Suggestion: it would make a lot of sense if there were a netfilter
hook that allowed the existing flexible netfilter/iptables policy
mechanisms to make these decisions.  

For example, the following sort of command might allow httpd to be run
without root:

iptables -t ACL -A BIND -m owner --uid-owner www -p tcp --sport 80 -j ACCEPT

And something like this might give all users the ability to run ping
without SUID:

iptable -t ACL -A SOCK_RAW -m owner --exec-owner /bin/ping -j ACCEPT

It would be great for Linux security to be able to remove SUID and
SGID from a bunch (or all!) of the networking commands, and it would
be great to be able to use tcpdump and ethereal under Linux without
root.  Performance for such calls is rarely critical.

- Morty
