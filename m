From: Patrick McHardy <kaber@trash.net>
Subject: Re: Message for local interface lo for "icmp error responses" is
 invalid ?
Date: Tue, 22 Feb 2005 13:11:24 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0502221308080.18441@kaber.coreworks.de>
References: <01b401c517a8$dfa5d960$6401a8c0@stopen1>
	<4219736E.7090702@trash.net> <4219D112.80204@artech.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Jan Holmberg <jan@artech.se>
In-Reply-To: <4219D112.80204@artech.se>
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

On Mon, 21 Feb 2005, Jan Holmberg wrote:
>>> Feb 21 00:23:45 rb3 kernel: 213.115.224.241 sent an invalid ICMP type 3, 
>>> code 1 error to a broadcast: 0.0.0.0 on lo

> unknown 2 539 src=0.0.0.0 dst=224.0.0.1 packets=439 bytes=12292 [UNREPLIED] 
> src=224.0.0.1 dst=0.0.0.0 packets=0 bytes=0 mark=0 use=1

Apparently something is sending packets with 0.0.0.0 as source. The ICMP
message is correct if the destination can't be reached.

Regards
Patrick
