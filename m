From: "andre achternaam" <andreiscmeel@hotmail.com>
Subject: DNS ALG
Date: Mon, 10 Jun 2002 07:54:06 +0000
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <F67eOz8E9lEEsTmImmz000147c4@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day'

I have set-up a gateway that separates my (private ipv4) LAN from the 
Internet. The hosts on my LAN are DHCP enabled and using private addresses. 
Also set-up an authorive DNS server for the hosts with a domain. Since the 
gateway performs NA(P)T it is not allowed to do queries from the Internet 
because it get a private address. However I found a RFC (2694 DNS extensions 
to NAT) that covers this part as far as I understand.  (I don’t want to use 
it for ipv6).

Is there any developer who has looked into a DNS ALG in combination with 
NA(P)T for ipv4? When yes, what is the status and what are the difficulties 
he/she/you encounters up till now.

All information is appreciated,
regards,

Andre



_________________________________________________________________
Send and receive Hotmail on your mobile device: http://mobile.msn.com
