From: Ozgur Akan <akan@aiqa.com>
Subject: Re: prohibiting iptables to insert a rule twice
Date: Thu, 06 May 2004 15:56:03 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409A35E3.2080706@aiqa.com>
References: <Pine.LNX.4.44.0405061429200.30809-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405061429200.30809-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



>iptables -m mark --mark 0x01 -d 10.0.0.1 -j ACCEPT
>[number of other rules]
>iptables -j MARK --set-mark 0x01
>[possibly a number of other rules]
>iptables -m mark --mark 0x01 -d 10.0.0.1 -j ACCEPT
>
>  
>
this example clears the situation!

I will work on the rules which are positioned one after another.

thanks for brainstorming...

-- 
Ozgur Akan
