From: Roberto Jung Drebes <drebes@inf.ufrgs.br>
Subject: Using nfmark
Date: Tue, 30 Nov 2004 18:47:50 -0200
Message-ID: <1992A582-4311-11D9-9302-000A957B2B6C@inf.ufrgs.br>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello again,

Can someone point me to documentation about the nfmark field of the 
sk_buff structure?

My netfilter module creates some traffic using ip_rcv and 
ip_finish_output, and this traffic is also subject to my module, since 
it is registered in the NF_IP_PRE_ROUTING and NF_IP_POST_ROUTING hooks. 
I would like to test in my module if this traffic was created by itself 
(in which case it should be ignored) or not (should be processed), and 
so I am thinking of marking created packets with a magic number. Can I 
use nfmark for that? Are there any other netfilter modules that use it?

Thanks in advance,

-- 
Roberto Jung Drebes <drebes@inf.ufrgs.br>
Porto Alegre, RS - Brasil
http://www.inf.ufrgs.br/~drebes/
