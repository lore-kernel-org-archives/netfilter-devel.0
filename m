From: qhou <qhou_acornsoft@sohu.com>
Subject: Q: Any other way on handling "conntrack DESTROY" without ip_conntrack_destroyed()
Date: Thu, 27 Jun 2002 14:06:45 +0800 (CST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1458624.1025158005416.JavaMail.postfix@mailsrv10.mail.sohu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
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

I have a requirement:
=====================
1.When a conntrack is created, I'll allocate memory for my private data, if the associated connect is what I am interested on.
2.And as the conntrack is destroyed for the connect is absolutely closed or timeout, I'll then release the memory of my private data.

The note(1) is easy to be done, but note(2) in some way is much more complex.

Currently I have two ideas on note(2):
======================================
1.Register a handle of the "void (*ip_conntrack_destroyed)()" in "ip_conntract_core.c" on my module's init function.
2.I implement the state and timeout tracking of my own in the module.

For idea(1), There'll be in conflict with the NAT, because the NAT uses the hook.(ip_nat_core.c:ip_nat_init()&:ip_nat_cleanup())
For idea(2), I'll repeat the ip_conntrack's alogrithm, ALSO be not a good idea...

Then can I implement it in another way?
Such as: the conntrack support me one safty hook on conntrack destroy...(I think there is no such hooks)
