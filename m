From: Gong Su <gongsu@lightforge.cs.columbia.edu>
Subject: access skb from conntrack helper?
Date: Thu, 27 Feb 2003 18:58:46 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200302272358.h1RNwlq23691@lightforge.cs.columbia.edu>
Reply-To: "Gong Su" <gongsu@cs.columbia.edu>
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

I'd like to be able to track, for each conntrack record satisfying certain
condition, some higher layer info such as the socket from which the packets
are being sent, etc. Unfortunately, only the packet header, not the skb, is
passed to conntrack helpers. Is there any way for a conntrack helper to
get access to the skb when it's called? Thank you.

-- 
/Gong
