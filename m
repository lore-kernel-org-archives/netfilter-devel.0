From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables --log-uid patch for 2.6
Date: Wed, 08 Dec 2004 18:07:25 +0100
Message-ID: <41B734CD.6010903@trash.net>
References: <1101668109.2922.1618.camel@ws102.darkcore.net>	
	<41B6840C.1030706@trash.net>
	<1102486259.2214.2276.camel@ws102.darkcore.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: John Lange <john.lange@open-it.ca>
In-Reply-To: <1102486259.2214.2276.camel@ws102.darkcore.net>
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

John Lange wrote:

>Thanks for response Patrick.
>
>One small note... 
>
>I believe there is a limitation to this approach that makes it tricky
>for blocking outbound packets. I hope you have a work-around.
>
>Specifically, there is no way to allow packets that have no UID set such
>as packets generated directly by the kernel.
>
>The following rules were designed to block users from (accidentally)
>installing spam relays on their web accounts (bad CGI scripts for
>example).
>
>I hope this example makes some sense:
>
>e.g.
>
># first allow root (this allows root, but NOT the kernel!)
>iptables -A OUTPUT -p ALL -m owner --uid-owner 0 -j ACCEPT
>
># allow anyone in the mail group
>iptables -A OUTPUT -p tcp -m owner --gid-owner 102 --dport 25 -j ACCEPT
>
>iptables -A OUTPUT -p tcp --dport 25 -j LOG --log-uid
>iptables -A OUTPUT -p tcp --dport 25 -j DROP
>
>----
>
>Packets generated directly by the kernel (like RST packets) have no UID
>set and therefore get blocked....
>  
>
I have a patch that lets you match "--owner" or "! --owner", this
should be enough. I'm going to merge it some time soon. You can
also use connection tracking, this should catch packets generated
by the kernel.

Regards
Patrick
