From: Aaron Eppert <eppertan@cs.rose-hulman.edu>
Subject: libipq and reinjecting packets
Date: Thu, 2 Jan 2003 15:22:49 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030102202249.GA9354@cs.rose-hulman.edu>
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


The application I am currently writing is experiencing a few oddities
that I am hoping someone may clear up.  

Program's basic layout:

1) ipq_read()
2) ipq_set_verdict()
3) accept()

Somewhere between ipq_set_verdict() and accept() a packet gets lossed,
which is why it leads me to believe it is in the netfilter kernel
code.  When the reinjected packet gets lossed, accept() will hang 
indefinitely.  Now, a potential solution is using select() around
the accept() call, but select() also causes rather painful issues.

Bottom line, ipq_set_verdict() and then immediately going to an
accept() should not cause a problem.

Any insight would be greatly appreciated.

Aaron
