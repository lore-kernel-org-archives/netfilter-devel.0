From: Chris Rankin <cj.rankin@ntlworld.com>
Subject: Connection tracking problem in 2.4.21-UP?
Date: Wed, 18 Jun 2003 22:56:21 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306182156.h5ILuLqK001640@twopit.underworld>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Ever since switching to 2.4.21, I am noticing that my firewall has
started to reject packets from

http://news.bbc.co.uk

I have the following rules in my firewall (among others):

--match state --state RELATED,ESTABLISHED --jump ACCEPT
--protocol tcp --jump LOG --log-level info

and under 2.4.20, these worked OK. The rejected packets start being
logged after a few minutes of surfing, and have "ACK SYN" flags set
as if they should be part of an existing connection.

Does anyone else see this?
Cheers,
Chris
