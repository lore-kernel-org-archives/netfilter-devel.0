From: =?iso-8859-2?Q?Jaros=B3aw?= Pyszny <arghil@tlen.pl>
Subject: [Q] problem(?) w/ owner_supgids patch
Date: 08 Nov 2003 13:52:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1068295928.18243.24.camel@lx.siec>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
I try build kernel from Fedora Core 1 (2.4.22-1.2115.nptl) with
p-o-m(CVS).

In ipt_owner.c (after patched) is call for_each_task macro, but this
kernel haven't it. Any suggestion? 

Best regards
Jarek
-- 
8  \\|||//  Jaroslaw J. Pyszny <arghil@tlen.pl>
b   (o|o)    AUROX Linux developer ("Vitae,non scholae,discimus")
i  --\_/--   Linux user: #96704    (http://counter.li.org)
t =-> 8-bit. komputer(y) - daj znac jesli chcesz sie pozbyc <-=
