From: Adrian Bularca <abularca@yahoo.com>
Subject: netfilter router extension
Date: Thu, 26 Jun 2003 03:16:35 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030626101635.11034.qmail@web11207.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,

I want to develop a netfilter extension capable of
filtering and also of routing of specific 
multicast packets, which are also modified. The main
idea is to intercept the incoming multicast packets on
one 
network card, processing/changing and sending them on
another network card. The first 
part, the filtering function raises no problems. The
changing and the routing of the 
multicast packets is the part that we didn't manage to
handle.
I am using the NF_IP_PREROUTING hook to process the
incoming packets and the NF_IP_LOCAL_OUT hook
to sent them as they are originating from the host.
Sending the packet to the LOCAL_OUT hook, using 
the NF_HOOK or event ip_send() function crashes the
system.
I would appreciate your ideas and suggestions on this
issue.

Thank you,
Adrian Bularca


__________________________________
Do you Yahoo!?
SBC Yahoo! DSL - Now only $29.95 per month!
http://sbc.yahoo.com
