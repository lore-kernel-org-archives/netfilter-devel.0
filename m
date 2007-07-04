From: Elie Roux <elie.roux@orange-ftgroup.com>
Subject: connmark and conntrack_ftp
Date: Wed, 04 Jul 2007 13:46:55 +0200
Message-ID: <468B88AF.3040707@orange-ftgroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hello,

I'm working with Netfilter to build a system making QoS according to the
mark of a connection. It works well with filters on the port and the ip,
but I'd like to build something more efficient based on conntrack-*
(ftp, irc, etc.). The problem is that I don't think it is possible right
now. For example I have a ftp connection that have mark 2, and I'd like
related connections to get mark 2 too.

Am I wrong when I say it is impossible ? Would it be possible to add it ?

Thank you in advance,
-- 
Elie
