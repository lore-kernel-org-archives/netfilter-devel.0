From: "王海涛 " <wanght@tsinghua.org.cn>
Subject: [HELP] what is the semantic meaning of find_appropriate_src()
Date: Fri, 27 Feb 2004 11:02:47 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <OVMBAPODMFAXSRGRYXMHSJSHCZKP.wanght@tsinghua.org.cn>
Reply-To: "王海涛 " <wanght@tsinghua.org.cn>
Content-Type: text/plain
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

I have studied the netfilter/iptables code for serval months, but I can not
understand the
semantic meaning of function find_appropriate_src(), which is called by
get_unique_tuple().

I can not figure in what situation it can return TRUE and  I think even in the
situation it can return TRUE, it is still meaningless. I designed and tried some
DNAT/SNAT examples, but none of them can make find_appropriate_src() return TRUE.

So, I wonder what is the object of designing the find_appropriate_src()? 

Thx!
