From: spid spid <deadat1148@yahoo.com>
Subject: Changing netfilter rules from a kernel module
Date: Wed, 22 Sep 2004 11:53:26 -0700 (PDT)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040922185326.26099.qmail@web50004.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I've written a netfilter match for port knocking.  I
need a way of modifying rules from a kernel module. 
Currently, what I have is a server that reads from
/proc/net/portknock to see which knocks are open and
which knocks are closed.

Is changing [a] rule(s) from a kernel module currently
possible?

If so, is there any reason not do to it this way?

it's not a port knocking question, but you may visit
www.portknocking.org to view information about this
idea.

Thanks.



		
_______________________________
Do you Yahoo!?
Declare Yourself - Register online to vote today!
http://vote.yahoo.com
