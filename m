From: nicho <fessboy@tom.com>
Subject: how to parse options?
Date: Fri, 21 Nov 2003 22:37:43 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBE2337.8090901@tom.com>
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

hi:
     #iptables -t nat -A POSTROUTING -o eth1 -s xxxxx/24 -j SNAT
--to-source yyyyy
    As we know, in kernel there is a structure called multi_range. When
we do nat, we choose a proper IP from the multi_range, and a proper port
if necessory. My question is, how multi_range is set into kernel, and
how option '--to-source' is parsed?
    By the way, I'm confused at getsockopt(... SO_GET_ENTRY...) . As the
name implies, we want to get entry info from kernel, but why it dose
copy data from user level to kernel level indeed. What does it do at all?
