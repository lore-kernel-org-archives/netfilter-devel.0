From: "Grace Li" <zheyinli@hotmail.com>
Subject: How to get original destination port after REDIRECT of iptables?
Date: Wed, 14 Apr 2004 17:17:28 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY7-F49ht3ZGAua7UV0004d0cb@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: zheyinli@hotmail.com
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

I have know that using REDIRECT option of iptables could redirect traffic to 
a specified remote port to another local port, for example iptables -t nat 
-A PREROUTING -i eth0 -p tcp --dport 1888 -j REDIRECT --to-port 2000 .  The 
original destination IP address is not changed, and could be obtained from 
getsockopt call with specifiying SO_ORIGINAL_DST ( e.g. getsockopt (client, 
SOL_IP, SO_ORIGINAL_DST, (struct sockaddr*)&addr, &len_t );) .

What I want to do is that for every incoming packets to ether net interface, 
I want to direct to one spcific port, instead of dedirecting traffic from 
one port to another port. In another words, I want to do multi-port match 
one port instead of one to one port match.  Could anybody suggest if it is 
doable? If yes, how could the application that listens to the re-directed 
port knows the original destination port?

Thanks a lot!

Grace Li

_________________________________________________________________
MSN Premium helps eliminate e-mail viruses. Get 2 months FREE*  
http://join.msn.com/?pgmarket=en-ca&page=byoa/prem&xAPID=1994&DI=1034&SU=http://hotmail.com/enca&HL=Market_MSNIS_Taglines
