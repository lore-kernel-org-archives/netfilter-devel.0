From: Tom Marshall <tommy@home.tig-grr.com>
Subject: Re: DNS ALG
Date: Mon, 10 Jun 2002 09:33:28 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020610093328.A12947@home.tig-grr.com>
References: <F67eOz8E9lEEsTmImmz000147c4@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: andre achternaam <andreiscmeel@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F67eOz8E9lEEsTmImmz000147c4@hotmail.com>; from andreiscmeel@hotmail.com on Mon, Jun 10, 2002 at 07:54:06AM +0000
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I would think that you can masq the DNS queries and responses using
connection tracking, but I have not tried recently.  I have found that
running a DNS cache on the masq machine is nicer.  It provides much faster
responses and reduces traffic.  There are several available.  I think
'dnsmasq' is probably one of the best.  If you are running Debian Woody or
Sid, use "apt-get install dnsmasq", else look here:

http://www.thekelleys.org.uk/dnsmasq/doc.html

On Mon, Jun 10, 2002 at 07:54:06AM +0000, andre achternaam wrote:
> Good day'
> 
> I have set-up a gateway that separates my (private ipv4) LAN from the 
> Internet. The hosts on my LAN are DHCP enabled and using private addresses. 
> Also set-up an authorive DNS server for the hosts with a domain. Since the 
> gateway performs NA(P)T it is not allowed to do queries from the Internet 
> because it get a private address. However I found a RFC (2694 DNS extensions 
> to NAT) that covers this part as far as I understand.  (I don’t want to use 
> it for ipv6).
> 
> Is there any developer who has looked into a DNS ALG in combination with 
> NA(P)T for ipv4? When yes, what is the status and what are the difficulties 
> he/she/you encounters up till now.
