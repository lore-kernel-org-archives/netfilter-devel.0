From: Michael Guntsche <mike@it-loops.com>
Subject: RTSP support for 2.6.23
Date: Sun, 5 Aug 2007 10:38:22 +0200
Message-ID: <A96BBBA4-8FD8-4DE4-8389-439E0DFB1546@it-loops.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Good morning,

I did a quick check to see if the RTSP module still compiles with the  
upcoming 2.6.23.
But as I thought there were some changes needed.
I had no problem with the renamed functions nf_conntrack_... ->  
nf_ct_... but there was one other change I was not able to solve.
The rtsp code uses the following code in certain places.

struct nf_conntrack_expect
exp->mask.dst.u.udp.port

nf_conntrack_helper
hlpr->mask.src.u.tcp.port
hlpr->mask.dst.protonum

The new structs have no mask members and I am not sure how I can  
achieve the same results with the new code. I looked at several other  
modules but could not figure out how to do it correctly.
Maybe someone can give me a hint on how to fix this.

Kind regards,
Michael
