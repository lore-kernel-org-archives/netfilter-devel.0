From: Patrick McHardy <kaber@trash.net>
Subject: Re: Message for local interface lo for "icmp error responses" is
 invalid ?
Date: Mon, 21 Feb 2005 06:36:46 +0100
Message-ID: <4219736E.7090702@trash.net>
References: <01b401c517a8$dfa5d960$6401a8c0@stopen1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jan Holmberg <jan@artech.se>
In-Reply-To: <01b401c517a8$dfa5d960$6401a8c0@stopen1>
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

Jan Holmberg wrote:

> Feb 21 00:23:45 rb3 kernel: 213.115.224.241 sent an invalid ICMP type 3, code 1 error to a broadcast: 0.0.0.0 on lo

Are you using NAT ? Is so, please grep for the address in
/proc/net/ip_conntrack and post that and your NAT rules.

Thanks
Patrick
