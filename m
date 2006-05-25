From: Eric White <eric.white@ionpipe.com>
Subject: Re: "bad argument" trouble with iptables-restore (ipt v.1.3.4 +
 gentoo 2.6.16)
Date: Thu, 25 May 2006 11:39:32 -0500
Message-ID: <4475DDC4.4090008@ionpipe.com>
References: <4474EEC4.4070909@ionpipe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,  netfilter@lists.netfilter.org
In-Reply-To: <4474EEC4.4070909@ionpipe.com>
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

With a little more experimentation, I see that manually poking a new 
chain definition (e.g., "iptables -t filter -N :A:Svc:ABD ") and then 
issuing iptables-save generates a

::A:Svc:ABD - [0:0]

line in the output.  So, I modified the ruleset, replacing all -N 
occurrences with the corresponding ":" prefix and added the "- [0:0]' 
suffix, with the same result; i.e., the COMMIT line generates a "bad 
argument" error.

So, I can poke these things in with the iptables call (which is what the 
current script does at an agonizing rate), but I can't seem to get 
iptables-restore to behave the same.


Eric White wrote:

> I've got ~930 rules with which I'd like to initialize via 
> iptables-restore.  The file includes rules for nat, filter and mangle 
> tables. I've got iptables v1.3.4 running on a Gentoo 2.6.16 kernel, 
> with some of my own, in-progress extensions (hence the '-m devset' 
> specifiers).
>
> At the first COMMIT, I get an error:
>
> Bad argument 'COMMIT'
> Error occurred at line: 209
>
> I've cut the main file into 3 different files (filter, nat, mangle) 
> and get the same results at each file's 'COMMIT'.  I'm including the 
> filter list below (since it's relatively small), hoping someone can 
> give it a quick glance and note my mistakes.
>
> thanks
>
> =======================
>
>
> #Filter table
> *filter
> :INPUT DROP [0:0]
> :FORWARD DROP [0:0]
> :OUTPUT DROP [0:0]
> -N :A:Svc:ABD
> -N :X:Abd:Clients:General:Ulog
> -N :X:Abd:Clients:Darkspace:Ulog
> -N :X:Abd:Clients:PrivAddr:Ulog
> -A :A:Svc:ABD -j :X:Abd:Clients:General:Ulog
> -A :A:Svc:ABD -j :X:Abd:Clients:Darkspace:Ulog
> -A :A:Svc:ABD -j :X:Abd:Clients:PrivAddr:Ulog
> -N :A:Global
> -A :A:Global -p tcp ! --syn -m state --state NEW -j DROP
> -A :A:Global -p tcp --tcp-flags ALL URG,ACK,PSH,RST,SYN,FIN -j DROP
> -A :A:Global -p tcp --tcp-flags ALL NONE -j DROP
> -A :A:Global -s 224.0.0.0/4 -j DROP
> -A :A:Global -s 127.0.0.0/8 -j DROP
> -N :A:Node:Server
> -N :A:Nodes
> -N :M:X:ToServer
> -N :M:Nodes
> -N :M:X:FromServer
> -N :D:Global
> -N :D:Node:Server
> -N :D:Nodes
> -A INPUT -j :A:Global
> -A OUTPUT -j :A:Global
> -A FORWARD -j :A:Global
> -A INPUT -j :A:Nodes
> -A OUTPUT -j :A:Node:Server
> -A FORWARD -j :A:Nodes
> -A INPUT -j :M:X:ToServer
> -A FORWARD -j :M:Nodes
> -A OUTPUT -j :M:X:FromServer
> -A INPUT -j :D:Global
> -A OUTPUT -j :D:Global
> -A FORWARD -j :D:Global
> -A INPUT -j :D:Node:Server
> -A OUTPUT -j :D:Nodes
> -A FORWARD -j :D:Nodes
> -N :A:Q:Clients
> -N :A:Node:Clients
> -A :A:Q:Clients -m devset --set-name 2 --device in -j :A:Node:Clients
> -A :A:Nodes -j :A:Q:Clients
> -N :D:Q:Clients
> -N :D:Node:Clients
> -A :D:Q:Clients -m devset --set-name 2 --device out -j :D:Node:Clients
> -A :D:Nodes -j :D:Q:Clients
> -N :M:Q:Clients
> -N :M:X:Clients
> -A :M:Q:Clients -m devset --set-name 2 --device in -j :M:X:Clients
> -A :M:Nodes -j :M:Q:Clients
> -N :M:Q:Clients:Server
> -N :M:X:Clients:Server
> -A :M:Q:Clients:Server -m devset --set-name 2 --device in -j 
> :M:X:Clients:Server
> -A :M:X:ToServer -j :M:Q:Clients:Server
> -N :M:Q:Clients:Clients
> -N :M:X:Clients:Clients
> -A :M:Q:Clients:Clients -m devset --set-name 2 --device out -j 
> :M:X:Clients:Clients
> -A :M:X:Clients -j :M:Q:Clients:Clients
> -N :M:Q:Server:Clients
> -N :M:X:Server:Clients
> -A :M:Q:Server:Clients -m devset --set-name 2 --device out -j 
> :M:X:Server:Clients
> -A :M:X:FromServer -j :M:Q:Server:Clients
> -A :A:Node:Clients -j :A:Svc:ABD
> -N :A:Q:WAN
> -N :A:Node:WAN
> -A :A:Q:WAN -m devset --set-name 3 --device in -j :A:Node:WAN
> -A :A:Nodes -j :A:Q:WAN
> -N :D:Q:WAN
> -N :D:Node:WAN
> -A :D:Q:WAN -m devset --set-name 3 --device out -j :D:Node:WAN
> -A :D:Nodes -j :D:Q:WAN
> -N :M:Q:WAN
> -N :M:X:WAN
> -A :M:Q:WAN -m devset --set-name 3 --device in -j :M:X:WAN
> -A :M:Nodes -j :M:Q:WAN
> -N :M:Q:WAN:Server
> -N :M:X:WAN:Server
> -A :M:Q:WAN:Server -m devset --set-name 3 --device in -j :M:X:WAN:Server
> -A :M:X:ToServer -j :M:Q:WAN:Server
> -N :M:Q:WAN:Clients
> -N :M:X:WAN:Clients
> -A :M:Q:WAN:Clients -m devset --set-name 2 --device out -j 
> :M:X:WAN:Clients
> -A :M:X:WAN -j :M:Q:WAN:Clients
> -N :M:Q:WAN:WAN
> -N :M:X:WAN:WAN
> -A :M:Q:WAN:WAN -m devset --set-name 3 --device out -j :M:X:WAN:WAN
> -A :M:X:WAN -j :M:Q:WAN:WAN
> -N :M:Q:Server:WAN
> -N :M:X:Server:WAN
> -A :M:Q:Server:WAN -m devset --set-name 3 --device out -j :M:X:Server:WAN
> -A :M:X:FromServer -j :M:Q:Server:WAN
> -N :M:Q:Clients:WAN
> -N :M:X:Clients:WAN
> -A :M:Q:Clients:WAN -m devset --set-name 3 --device out -j 
> :M:X:Clients:WAN
> -A :M:X:Clients -j :M:Q:Clients:WAN
> -N :A:Q:VPN
> -N :A:Node:VPN
> -A :A:Q:VPN -m devset --set-name 4 --device in -j :A:Node:VPN
> -A :A:Nodes -j :A:Q:VPN
> -N :D:Q:VPN
> -N :D:Node:VPN
> -A :D:Q:VPN -m devset --set-name 4 --device out -j :D:Node:VPN
> -A :D:Nodes -j :D:Q:VPN
> -N :M:Q:VPN
> -N :M:X:VPN
> -A :M:Q:VPN -m devset --set-name 4 --device in -j :M:X:VPN
> -A :M:Nodes -j :M:Q:VPN
> -N :M:Q:VPN:Server
> -N :M:X:VPN:Server
> -A :M:Q:VPN:Server -m devset --set-name 4 --device in -j :M:X:VPN:Server
> -A :M:X:ToServer -j :M:Q:VPN:Server
> -N :M:Q:VPN:Clients
> -N :M:X:VPN:Clients
> -A :M:Q:VPN:Clients -m devset --set-name 2 --device out -j 
> :M:X:VPN:Clients
> -A :M:X:VPN -j :M:Q:VPN:Clients
> -N :M:Q:VPN:WAN
> -N :M:X:VPN:WAN
> -A :M:Q:VPN:WAN -m devset --set-name 3 --device out -j :M:X:VPN:WAN
> -A :M:X:VPN -j :M:Q:VPN:WAN
> -N :M:Q:VPN:VPN
> -N :M:X:VPN:VPN
> -A :M:Q:VPN:VPN -m devset --set-name 4 --device out -j :M:X:VPN:VPN
> -A :M:X:VPN -j :M:Q:VPN:VPN
> -N :M:Q:Server:VPN
> -N :M:X:Server:VPN
> -A :M:Q:Server:VPN -m devset --set-name 4 --device out -j :M:X:Server:VPN
> -A :M:X:FromServer -j :M:Q:Server:VPN
> -N :M:Q:Clients:VPN
> -N :M:X:Clients:VPN
> -A :M:Q:Clients:VPN -m devset --set-name 4 --device out -j 
> :M:X:Clients:VPN
> -A :M:X:Clients -j :M:Q:Clients:VPN
> -N :M:Q:WAN:VPN
> -N :M:X:WAN:VPN
> -A :M:Q:WAN:VPN -m devset --set-name 4 --device out -j :M:X:WAN:VPN
> -A :M:X:WAN -j :M:Q:WAN:VPN
> -A :M:X:Server:Clients -j ACCEPT
> -A :M:X:Server:VPN -j ACCEPT
> -A :M:X:Server:WAN -j ACCEPT
> -A :M:X:Clients:Server -m state --state ESTABLISHED,RELATED -j ACCEPT
> -A :M:X:Clients:Server -p udp --dport 29922 -j ACCEPT
> -A :M:X:Clients:Server -p tcp --dport 29922 -j ACCEPT
> -A :M:X:Clients:Server -p tcp --dport 29924 -j ACCEPT
> -A :M:X:Clients:Server -p tcp --dport 29914 -j ACCEPT
> -A :M:X:Clients:Server -p udp --dport 53 -j ACCEPT
> -A :M:X:Clients:Server -p tcp --dport 53 -j ACCEPT
> -A :M:X:Clients:Server -p udp --dport 29923 -j ACCEPT
> -A :M:X:Clients:Server -p tcp --dport 29923 -j ACCEPT
> -A :M:X:Clients:Server -p tcp --dport 29900 -j ACCEPT
> -A :M:X:Clients:Server -p tcp --dport 29901 -j ACCEPT
> -A :M:X:Clients:Server -p tcp --dport 29908 -j ACCEPT
> -A :M:X:Clients:Server -p tcp --dport 29909 -j ACCEPT
> -N :X:DHCP:Accept
> -A :M:X:Clients:Server -p udp --sport bootpc -j :X:DHCP:Accept
> -N :X:Clients:ToServer:Accept
> -A :M:X:Clients:Server -j :X:Clients:ToServer:Accept
> -N :X:Abd:Clients:ToServer:Ulog
> -N :X:Abd:Clients:ToServer:Uni:Pass
> -A :X:Abd:Clients:ToServer:Uni:Pass -d 255.255.255.255 -j RETURN
> -A :X:Abd:Clients:ToServer:Uni:Pass -j :X:Abd:Clients:ToServer:Ulog
> -A :M:X:Clients:Server -j :X:Abd:Clients:ToServer:Uni:Pass
> -N :X:Clients:Clients:Pass
> -A :M:X:Clients:Clients -j :X:Clients:Clients:Pass
> -N :X:VPNSubnet:FromClients:Pass
> -A :X:VPNSubnet:FromClients:Pass -j DROP
> -A :M:X:Clients:VPN -j :X:VPNSubnet:FromClients:Pass
> -N :X:ClientMark:VPN:Accept
> -A :M:X:Clients:VPN -j :X:ClientMark:VPN:Accept
> -A :M:X:Clients:VPN -m state --state ESTABLISHED,RELATED -j ACCEPT
> -N :X:WalledGarden:Accept
> -A :M:X:Clients:WAN -j :X:WalledGarden:Accept
> -N :X:Quarantine:Drop
> -A :M:X:Clients:WAN -j :X:Quarantine:Drop
> -N :X:ClientMark:WAN:Accept
> -A :X:ClientMark:WAN:Accept -m markset --set-name 0 -j ACCEPT
> -A :M:X:Clients:WAN -j :X:ClientMark:WAN:Accept
> -A :M:X:VPN:Server -m state --state ESTABLISHED,RELATED -j ACCEPT
> -A :M:X:VPN:Server -p tcp --dport 29910 -j ACCEPT
> -A :M:X:VPN:Server -p tcp --dport 29918 -j ACCEPT
> -A :M:X:VPN:Server -p udp --dport 161 -j ACCEPT
> -A :M:X:VPN:Server -p udp --dport 162 -j ACCEPT
> -A :M:X:VPN:Server -p tcp --dport 29903 -j ACCEPT
> -A :M:X:VPN:Server -p icmp -j ACCEPT
> -N :X:VPN:ToServer:Accept
> -A :M:X:VPN:Server -j :X:VPN:ToServer:Accept
> -A :M:X:VPN:Clients -m state --state ESTABLISHED,RELATED -j ACCEPT
> -N :X:VPNSubnet:ToClients:Pass
> -A :X:VPNSubnet:ToClients:Pass -j DROP
> -A :M:X:VPN:Clients -j :X:VPNSubnet:ToClients:Pass
> -A :M:X:VPN:Clients -j ACCEPT
> -A :M:X:VPN:WAN -j DROP
> -A :M:X:WAN:Server -p udp --sport 500 --dport 500 -j ACCEPT
> -A :M:X:WAN:Server -p tcp --dport 29903 -j ACCEPT
> -N :X:WAN:ToServer:Accept
> -A :M:X:WAN:Server -j :X:WAN:ToServer:Accept
> -A :M:X:WAN:Server -m state --state ESTABLISHED,RELATED -j ACCEPT
> -N :X:Abd:WAN:Clients:Ulog
> -A :M:X:WAN:Clients -j :X:Abd:WAN:Clients:Ulog
> -A :M:X:WAN:Clients -m state --state ESTABLISHED,RELATED -j ACCEPT
> -N :X:Network:Accept
> -A :M:X:WAN:Clients -j :X:Network:Accept
> -N :X:PortXlation:Accept
> -A :M:X:WAN:Clients -j :X:PortXlation:Accept
> -N :X:PortForwarding:Accept
> -A :M:X:WAN:Clients -j :X:PortForwarding:Accept
> -A :M:X:WAN:VPN -j DROP
> COMMIT  
>
>
