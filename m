From: Sven Schuster <schuster.sven@gmx.de>
Subject: can't access svn repository
Date: Fri, 1 Jul 2005 15:28:43 +0200
Message-ID: <20050701132843.GA20157@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


Hi everybody,

does anybody else also have problems accessing the svn repository??

When I run

svn co https://svn.netfilter.org/netfilter/trunk/iptables

to do a completely new checkout, I get these errors:

svn: REPORT request failed on '/netfilter/!svn/vcc/default'
svn:
Can't find a temporary directory

Is it once again my insufficient subversion knowledge or is there
a problem on the server side??


regards,

Sven

-- 
Linux zion 2.6.12-mm2 #3 Thu Jun 30 21:35:27 CEST 2005 i686 athlon i386 GNU/Linux
 15:26:57 up 17:09,  1 user,  load average: 0.10, 0.24, 0.16
