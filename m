From: Roberto Jung Drebes <drebes@inf.ufrgs.br>
Subject: Simple sk_buff question
Date: Mon, 29 Nov 2004 10:53:33 -0200
Message-ID: <AD262F6C-4205-11D9-B8CC-000A957B2B6C@inf.ufrgs.br>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
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

Hello there,

I am working in a simple netfilter module, and in some situations it 
has to duplicate received IP packets. It does this with something like:

clone_skb = skb_clone(skb, GFP_ATOMIC);
ip_rcv(clone_skb, clone_skb->dev, NULL);
return NF_ACCEPT;

Should I call kfree_skb(clone_skb) after the ip_rcv(), or will the 
cloned sk_buff be freed when it reaches upper level protocols?

Sorry if the question is really not netfilter specific, but it is 
related to another question I will do next.

Thanks in advance,

-- 
Roberto Jung Drebes <drebes@inf.ufrgs.br>
Porto Alegre, RS - Brasil
http://www.inf.ufrgs.br/~drebes/
