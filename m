From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Sequence number translation explanations.
Date: Sat, 27 Mar 2004 18:00:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4065A500.8060107@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Hi!

I need to translate sequence numbers between the two networks that are 
separated by the firewall. In fact, I just need to translate on of them 
(so tcph->ack_seq in one direction, and tcph->seq in the opposite 
direction).
I found the ip_nat_seq stucture and the ip_nat_seq_adjust function but I 
do not understand them. Particularly this "correction_pos", what is it?

Could someone provide me with some explanations?

             Emmanuel
