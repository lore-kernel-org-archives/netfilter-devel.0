From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: ip_conntrack_tuple and marks
Date: Fri, 22 Sep 2006 22:33:45 +0200
Message-ID: <451448A9.6000407@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi,

is it possible to add a nfmark field to ip_conntrack_tuple
so that only packets with a certain mark set are matched to
a connection? I'm trying to filter/nat multiple independent
connections with same ip/proto/port tuples on both sides
and the only distinguishing property of the different
connections is their nfmark. Using NOTRACK doesn't help
because it can only exclude packets from tracking, not
match packets to different expectations.

At first sight, it seems possible to only change a few lines
of code (expectation comparison and setup), but I fear there
might be a lot more to consider.

Any pointers to docs/patches/etc. are appreciated.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
