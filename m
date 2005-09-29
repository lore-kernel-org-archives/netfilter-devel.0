From: Nhan Thanh Le <ltnhan@tma.com.vn>
Subject: Receiving Commands From Userspace
Date: Thu, 29 Sep 2005 12:18:01 +0700
Message-ID: <433B7909.4020001@tma.com.vn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

I want to write a Netfilter module which should interact with user 
space.Rusty Russell said in the hacking HOW-TO,this can be done by 
setsockopt mechanism.But I don't have any idea.Can you help me?
  Is there any example?

BTW Anyone give me explain how to use struct nf_sockopt_ops, 
nf_setsockopt(),nf_register_sockopt()

    Thank you very much and appreciate for help.
Nhanle
