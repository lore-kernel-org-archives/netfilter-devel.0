From: wanghtb@legend.com.cn
Subject: [HELP] what is the semantic meaning of find_appropriate_src()?
Date: Mon, 1 Mar 2004 09:50:06 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <OF7E32BEEA.71DFB54B-ON48256E4A.0009FB21@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

I have studied the netfilter/iptables code for serval months, but I can 
not understand the
semantic meaning of function find_appropriate_src(), which is called by 
get_unique_tuple().

I can not figure in what situation it can return TRUE( a proper manip) and 
 I think even in the situation it can return TRUE, it is still 
meaningless. I designed and tried some DNAT/SNAT examples, but none of 
them can make find_appropriate_src() return TRUE.

So, I wonder what is the object of designing the find_appropriate_src()? 
