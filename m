From: Jesse Peng <jesse@deansoft.com.tw>
Subject: Need pass skb to help!!
Date: Wed, 10 Dec 2003 16:55:53 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD6DF99.4030809@deansoft.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Currently we have a project which need while help routine (run on 
related conntrack)executed, move nfct pointing to its parent's 
conntrack(not that dirty you would mistake). But as you know, currently 
parameters passed to connection help only include iph. So it leaves me 
almost no other choice but patching the help that of course would 
certainly cause nightmare(need patch every helper). How can I do? or the 
helper infrastructure consider any future plan? Please "help" !

Your sincerely
Jesse
