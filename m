From: Ignatich <ignatich@gmail.com>
Subject: owner based routing
Date: Mon, 10 Oct 2005 00:50:11 +0400
Message-ID: <226310304.20051010005011@gmail.com>
Reply-To: Ignatich <ignatich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello netfilter developers,

I have a following problem. My linux server has two interfaces: the first
connected to internet and the second connected to LAN. In LAN I have
another hardware ADSL router connected to another (much slower) ISP.

I want LAN users to use linux server as internet gateway and
still be able to use ADSL link to download files via http/ftp/bt on
my server in background.

At first glance I thought that ipt_owner is all I need, but
unfortunately it only works in OUTPUT chain (and in INPUT and
POSTROUTING chain if I apply owner-socketlookup patch from
patch-o-matic, but that doesn't help here).

Is it possible to configure owner-based routing via some other way? If
not then how much work required to make ipt_owner work in PREROUTING
table? Does netfilter team plan to add such functionality? I'm no
linux kernel programmer but experienced with C so I might be able to
help if that's not very complicated.

-- 
 Ignatich                          mailto:ignatich@gmail.com
