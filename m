From: John Heffner <jheffner@psc.edu>
Subject: What to do with malformed l4proto packets? (resend)
Date: Fri, 06 Apr 2007 13:36:48 -0400
Message-ID: <46168530.9070604@psc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

(Apologies if this is a duplicate, but my original message didn't seem 
to get through.)


We have someone on the end of a DSL line that seems to be
non-deterministically corrupting some of his packets (a rate of ~1e-5)
in a way that causes the TCP checksum to fail.  While he hopes to get
this situation remedied, the immediate problem is that his connections
that go through our firewall are getting reset every time a corrupted
segment is received.

AFAICT, what's happening is that tcp_error() finds the TCP checksum
wrong, returning -NF_ACCEPT back up to nf_conntrack_in(), which quits
and sends NF_ACCEPT back up.  So we have a TCP packet not associated
with a connection, so our firewall rules send back a RST.

So, the question is: is there any reason to ACCEPT TCP segments with
known bad checksums?

Thanks,
   -John
