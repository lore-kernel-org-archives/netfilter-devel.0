From: Deti Fliegl <deti@fliegl.de>
Subject: iptables & new CONNMARK 32bit marks
Date: Mon, 24 Oct 2005 17:57:10 +0200
Message-ID: <435D0456.60405@fliegl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hello *,

when using kernel 2.6.14rc5 the mark values have become 32bit but latest 
iptables code still uses 64bit values. This causes the kernel module to 
say "CONNMARK: Only supports 32bit mark" - it seems that the iptables 
svn repository needs to be updated.
I've made some patch that works for me but if there's an official 
version please let me know...

Deti
