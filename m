From: Pablo Neira <pablo@eurodev.net>
Subject: Re: connection tracking question
Date: Thu, 13 May 2004 00:21:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A2A35B.4010809@eurodev.net>
References: <6A94CF724B046C4FB3434D14A49A58BF1CB7D3@pluto.rovingplanet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Albert <palbert@rovingplanet.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <6A94CF724B046C4FB3434D14A49A58BF1CB7D3@pluto.rovingplanet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Paul,

Paul Albert wrote:

> Specifically, I would like to know when the ESTABLISHED state is set 
> in the kernel.


mmm, i suppose that you are talking about a tcp connection, in that 
case, see file ip_conntrack_proto_tcp.c. If that's not enough, you can 
have a look at tcp-window-tracking patch available in pom-ng which add 
interesting comment to understand tcp tracking.

>   I realize that it is when iptables sees an ACK of a SYN packet, for 
> example, but if I have a firewall rule in the nat/PREROUTING chain 
> that checks to ensure that the connection is ESTABLISHED, will the ACK 
> packet cause the rule to be hit?  Does the connection tracking take 
> place before the mangle/PREROUTING chain?


yes, connection tracking is the first hook in prerouting/output, so it's 
done before mangle. It's also the last in postrouting/input.
 
regards,
Pablo
