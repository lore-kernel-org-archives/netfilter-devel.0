From: "andre achternaam" <andreiscmeel@hotmail.com>
Subject: Re: DNS ALG
Date: Tue, 11 Jun 2002 07:36:03 +0000
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <F17vjkO22ZhCl8aii080001580f@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: tommy@home.tig-grr.com
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Tommy & others,

At my gateway I have already installed DNS together with DHCP (Bind isc) 
when a lease is hand out the DHCP will update the DNS as well. (ad-hoc for 
the people who know i'am talking 'bout). Let's say DHCP adds:
host_foo at address 10.0.0.3 than it should not not result in a (external) 
query like this:
Q] host_foo.mydomain.com
A] 10.0.0.3
However, for an internal query this is oke but I want to resolve the 
external query as well, as specified in RFC2694 (DNS_ALG).

I looked at the DNS-masq project and cannot find/see/read if it solve my 
problem. As far as i can understand its a lightweight DNS server that can be 
used in small natted networks, with caching and DNS resolving for the 
internal side only.

Regards,
Andre Kleibeuker

>I would think that you can masq the DNS queries and responses using
>connection tracking, but I have not tried recently.  I have found that
>running a DNS cache on the masq machine is nicer.  It provides much faster
>responses and reduces traffic.  There are several available.  I think
>'dnsmasq' is probably one of the best.  If you are running Debian Woody or
>Sid, use "apt-get install dnsmasq", else look here:
>
>http://www.thekelleys.org.uk/dnsmasq/doc.html



_________________________________________________________________
Join the world’s largest e-mail service with MSN Hotmail. 
http://www.hotmail.com
