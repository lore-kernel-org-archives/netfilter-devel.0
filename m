From: John Minnis <jminnis@yahoo.com>
Subject: IPQ Userspace Filtering
Date: Fri, 16 May 2003 09:18:23 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030516161823.31741.qmail@web10705.mail.yahoo.com>
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

Does anyone know of a way to determine if another
userspace application has created an IPQ handler
(NETLINK_FIREWALL socket)?  I understand that the only
one may be used at a time, however currently the
second one is allowed to open, and then all traffic is
directed to this one.  Neither instance receives any
indication that there is a conflict. I am using the
intercept.c example code to test this.  My first
preference would be to prevent the second socket from
being opened until the first program exited.

Any assistance would be appreciated.

Thanks,
John

__________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo.
http://search.yahoo.com
