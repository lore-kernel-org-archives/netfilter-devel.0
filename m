From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Question about nf_hookfn
Date: Fri, 10 Oct 2003 17:14:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1065798842.17392.38.camel@rade7.s.cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain
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

Hi all,

I would like to know more about the last argument of the function
nf_hookfn defined in /usr/src/linux/include/linux/netfilter.h.

Basically, you have:

typedef unsigned int nf_hookfn(unsigned int hooknum,
                               struct sk_buff **skb,
                               const struct net_device *in,
                               const struct net_device *out,
                               int (*okfn)(struct sk_buff *));

I got all the other arguments but the last one...

What is it for ???

Regards
-- 
Emmanuel

Modern technology just makes people try to do everything at once.
  -- Calvin & Hobbes (Bill Waterson)
