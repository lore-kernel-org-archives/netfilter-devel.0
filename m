From: Ned Ren <nedren@yahoo.com>
Subject: Newbie Question: Locking in Netfilter hook module?
Date: Fri, 11 Jul 2003 01:58:49 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030711085849.10325.qmail@web10902.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nedren@yahoo.com
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

Hi, 

This maybe a silly question. I'm wondering for hook modules that I write for netfilter, is it
necessary to do locking (critical section) when accessing my own global structures? This is
regarding SINGLE CPU systems, is there anything that would preempt my module while it's at it such
as interrupt etc?

Thank you!

please reply to my email addr as well: nedren@yahoo.com


__________________________________
Do you Yahoo!?
SBC Yahoo! DSL - Now only $29.95 per month!
http://sbc.yahoo.com
