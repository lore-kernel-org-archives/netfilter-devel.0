From: Scott MacKay <scottmackay@yahoo.com>
Subject: Augmenting conntrack
Date: Tue, 14 Oct 2003 04:50:26 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031014115026.61399.qmail@web13905.mail.yahoo.com>
References: <3F8350CA.6040904@vialink.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <3F8350CA.6040904@vialink.com.br>
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

I have been playing around with the QUEUE target of
iptables, mainly looking at simple packet mangling.  I
have been able to hunt thru code thanks to help from
the list, but think I may still have a issue to
resolve.

I want to perform some simple packet content
manipulation for TCP data, using the QUEUE interface
(since I so far have not done any kernel level
programming).  From a simple approach, I want to
mangle traffic going out a specific port on machine A
and de-mangle it when it comes in a specific port on
machine B.  My mangling only occurs on the payload of
TCP packets, not on the header so all the routing and
stuff should be OK.  I was planning to insert it into
PREROUTING (to catch it coming in) and POSTROUTING (to
catch it going out) on the interface.  
My current concern is connection tracking, mainly
because I believe NAT uses conntrack information. 
Looking at NF_IP_PRI values, it looks like CONNTRACK
may be called before I can de-mangle which I would
think can cause problems.
The only things I can think of which might work would
be to change the NF_IP_PRI_CONNTRACK value to be
higher than MANGLE (ugly, doubt it would work), alter
the conntrack module to de-mangle what it sees so it
can establish connection tracking OK (also ugly and
not sure where I would start), or maybe a conntrack
helper module (saw amanda did this, was not sure if I
could specify a fairly wide criterea).  
I was wondering, are there any thoughts on how to best
proceed or even on documentation that would help me
understand the netfilter & conntrack mechanism better?















__________________________________
Do you Yahoo!?
The New Yahoo! Shopping - with improved product search
http://shopping.yahoo.com
