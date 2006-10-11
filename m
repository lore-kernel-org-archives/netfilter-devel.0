From: robert <rbscott@cadvium.net>
Subject: ipq and nf_queue compatibility
Date: Tue, 10 Oct 2006 19:20:01 -0700
Message-ID: <A204A2FA-BD7D-410F-B6AB-EB61B894DB28@cadvium.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
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

Hello,

I am porting a program that uses IPQ to NF_QUEUE, and the port went  
very smoothly, but I noticed that if I run the nfqueue version once,  
the ipq version stops working.  The NF_QUEUE version always works,  
but the other one simple stops functioning.  Is there a known  
incompatibility between the two?  Or perhaps is there some global  
state that I need to cleanup inside of the NFQUEUE version before I  
execute the IPQ version.  The kernel has both IPQ and NFQUEUE support.

This happens regardless of whether or not I call the function  
nfq_unbind_pf on exit.  Not really sure what that function does, but  
it was inside of nfqnl_test.c, so I tried it out.

any ideas?
--robert
