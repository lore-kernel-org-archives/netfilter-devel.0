From: Marcus Sundberg <marcus@ingate.com>
Subject: Dealing with shared/cloned skbs?
Date: Tue, 23 Aug 2005 17:07:00 +0200
Message-ID: <430B3B94.8060902@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
To: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

in the 2.4 net/ipv4/netfilter directory various ways are used to
check whether an skb needs to be copied before it is modified. At
least three ways are used:

if (skb_shared(skb) || skb_cloned(skb))

if (skb_cloned(skb) && !skb->sk)

if (skb_cloned(skb))

And at the places where the skb is actually copied some of them do:

	if ((oldskb)->sk)
		skb_set_owner_w(newskb, oldskb->sk);

while some of them do not.

What is the correct way to know if an skb needs to be copied before
modified, and what should be done after a copy takes place?

//Marcus
-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/
