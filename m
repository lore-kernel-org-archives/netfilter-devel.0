From: "Ricky Foo" <blue_pion@hotmail.com>
Subject: Conntrack Entries
Date: Thu, 12 Jun 2003 08:45:01 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Sea2-F465SpDz9vUkUq0000c036@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

I have written a netbios conntrack module for port 139. However when I 
tested it, it shows several entries because the source port on my side keeps 
changing.....e.g. 32900, then 32901, 32902.... in this case, there will be 3 
lines as if there are 3 different connections are going on. Is this the 
correct expected behaviour or should they just go into 1 line?

What does the "use" field mean?

    Ricky

_________________________________________________________________
Get 10mb of inbox space with MSN Hotmail Extra Storage 
http://join.msn.com/?pgmarket=en-sg
