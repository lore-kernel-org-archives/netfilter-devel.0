From: Eicke Friedrich <tady@gmx.net>
Subject: marking connections
Date: Tue, 25 Feb 2003 00:25:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E5AA9E8.3060208@gmx.net>
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

Hello,

I'm running a linux box as bridge and firewall using iptables. In my understanding 
iptables decides for the first packet of a stream if it's accepted or not and treats the 
rest in the same way. In my setup the problem seems to be that I can't decide if I want to 
accept or drop the packet until the first PSH packet containing data arrives.
Is there a way to solve this problem? Sorry for the question but I'm kind of new to 
writing iptables extensions!
I hope you can give me a piece of advice howto solve this problem. Thanks a lot!

Eicke

---------------
Linux is like a whigwham: no windows, no gates but an apache inside! :)
