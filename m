From: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Subject: [error] sctp-conntrack-nat [long]
Date: Mon, 19 Apr 2004 12:00:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58L.0404191159240.20894@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter developmnet mailing list <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I try to build this module on 2.6.6-rc1 and got error:
[pom-ng - from CVS date 20040419]

  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_sctp.o
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:117: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:118: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:118: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:121: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:122: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:123: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:124: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:125: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:126: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:127: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:128: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:129: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:130: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:130: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:131: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:131: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:134: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:135: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:136: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:137: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:138: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:139: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:140: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: error: `SCTP_CONNTRACK_SHUTDOWN_ACK_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:141: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: braces around scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: error: initializer element is not constant
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: error: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: error: `SCTP_CONNTRACK_COOKIE_WAIT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: error: `SCTP_CONNTRACK_SHUTDOWN_SENT' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: error: `SCTP_CONNTRACK_SHUTDOWN_RECD' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: error: `SCTP_CONNTRACK_CLOSED' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:142: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:143: warning: excess elements in scalar initializer
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:143: warning: (near initialization for `sctp_conntracks')
net/ipv4/netfilter/ip_conntrack_proto_sctp.c: In function `sctp_print_conntrack':
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:192: error: storage size of `state' isn't known
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:198: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:192: warning: unused variable `state'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c: At top level:
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:254: error: parameter `cur_state' has incomplete type
net/ipv4/netfilter/ip_conntrack_proto_sctp.c: In function `sctp_packet':
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:310: error: storage size of `newconntrack' isn't known
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:310: error: storage size of `oldsctpstate' isn't known
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:331: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:336: error: `SCTP_CONNTRACK_MAX' undeclared (first use in this function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:336: error: (Each undeclared identifier is reported only once
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:336: error: for each function it appears in.)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:349: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:350: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:357: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:358: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:366: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:372: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:395: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:398: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:405: error: `SCTP_CONNTRACK_COOKIE_ECHOED' undeclared (first use in this function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:406: error: `SCTP_CONNTRACK_ESTABLISHED' undeclared (first use in this function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:310: warning: unused variable `newconntrack'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:310: warning: unused variable `oldsctpstate'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c: In function `sctp_new':
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:418: error: storage size of `newconntrack' isn't known
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:440: error: `SCTP_CONNTRACK_MAX' undeclared (first use in this function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:444: error: `SCTP_CONNTRACK_NONE' undeclared (first use in this function)
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:465: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:477: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:480: error: union has no member named `sctp'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:418: warning: unused variable `newconntrack'
net/ipv4/netfilter/ip_conntrack_proto_sctp.c: At top level:
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:117: error: storage size of `sctp_conntracks' isn't known
net/ipv4/netfilter/ip_conntrack_proto_sctp.c:117: warning: `sctp_conntracks' defined but not used
make[3]: *** [net/ipv4/netfilter/ip_conntrack_proto_sctp.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2
