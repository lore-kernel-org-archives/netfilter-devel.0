From: Scott MacKay <scottmackay@yahoo.com>
Subject: Need for ether level in userspace
Date: Mon, 19 Jan 2004 10:03:22 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040119180322.31887.qmail@web13908.mail.yahoo.com>
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
   I need to get access to a packet's ethernet packet
from a QUEUE userspace application.  It looks like
only the payload is provided, though there is a
hw_addr field from the message (which I think is
empty, looking at the ip_queue.c source code.

Is there any way to get the source/dst ether address
other than mangling the userspace message?

__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
