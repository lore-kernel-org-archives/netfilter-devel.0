From: Eicke Friedrich <tady@gmx.net>
Subject: conntrack and connmark
Date: Wed, 07 May 2003 11:14:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EB8CE6D.1030809@gmx.net>
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

Hi folks,

I've a very simple question about connmark. I hope you can help me 
here. I'm running a linux ethernet bridge with netfilter support. 
There are two ports in this bridge (eth0 and eth1).
If I mark a packet with connmark that leaves the bridge at eth0 for 
example will a packet belonging to the same connection but in the 
other direction (so leaving th bridge ar eth1) also be marked with the 
same mark?
Or to put in short words: will connmark just work for one direction or 
for both?

Thanks for any comments!
Eicke.
