From: Weiguang Shi <wgshi2002@yahoo.ca>
Subject: TCP's response to NF_STOLEN
Date: Mon, 14 Jun 2004 00:31:49 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040614043149.39553.qmail@web90003.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi,

My netfilter NF_IP_OUTPUT_HOOK function matches a TCP
connection and returns NF_STOLEN now and then when 
certain conditions are satisfied.

I'm wondering how the local TCP code responses. 
Specifically, I was wondering whether this can cause
sk_buff leak or anything. I known after receiving 
enough dup-ACK's, TCP will retransmit? How is the 
stolen packet reserved before that? Will it be the 
exactly the one retransmitted (I didn't do any 
kfree_skb(), shall I do it?)? Or will TCP re-alloc a
skb header in retransmitting, leaving the stolen one
floating in the memory?

Thank you,
Wei



______________________________________________________________________ 
Post your free ad now! http://personals.yahoo.ca
