From: jamal <hadi@cyberus.ca>
Subject: tc filtering vs iptables
Date: 27 Aug 2004 09:46:29 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093614389.1068.20.camel@jzny.localdomain>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Harald or anyone from the netfilter devel cabal: 

I am trying to do a performance comparison for basic stateless
firewalling using tc and iptables. I want to provide a fair analysis
but dont know how well to optimize iptables. I know you can use chains
but not sure what the best way to approach it in this case. I will
describe what i am trying to do in English and someone please help
provide it in iptables-speak:

I want to be able to have many hosts[1] accessing a web server at
TCP port 80. The return path is asymetric so wont go via same box.
In this case clearly the ephemeral src port will vary as will the src IP
but nothing else.
Anything that doesnt match gets dropped i.e thats the default rule.

Let me know how to create proper chains for a range of hosts
{1,2,8, 64,256,4096,8192,16384,32768,64K} 

cheers,
jamal
