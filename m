From: Ozgur AKAN <akan@aiqa.com>
Subject: Re: Can iptables REDIRECT traffic to a range of ports in one command?
Date: Tue, 20 Apr 2004 15:29:47 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408517BB.7030703@aiqa.com>
References: <BAY7-F619fiD0yzNrUD0005c8b5@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grace Li <zheyinli@hotmail.com>
In-Reply-To: <BAY7-F619fiD0yzNrUD0005c8b5@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

this is what you look for;

10.0.0.1 is the ip of destination machine

iptables -t nat -A PREROUTING -p tcp -d 10.0.0.1 --dport 2000:3000 -j 
DNAT --to 10.0.0.1:3333

-- 
Ozgur Akan
