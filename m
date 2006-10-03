From: Alan Ezust <alan.ezust@presinet.com>
Subject: testing installation of conntrack command line tool
Date: Tue, 3 Oct 2006 15:18:09 -0700
Message-ID: <200610031518.10097.alan.ezust@presinet.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
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

Hi - i'm trying out the "conntrack" program for my first time. 
It compiles and runs, but when I try to do

conntrack -L conntrack

it shows me nothing.

If I cat /proc/net/ip_conntrack I can see lots of log lines there. Should the 
conntrack -L conntrack show me pretty much the same thing?

What's the best way to test that conntrack is working properly?
