From: "dimitri borjac" <dimitri_borjac@hotmail.com>
Subject: iptables and SPI...
Date: Wed, 22 Oct 2003 16:44:51 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Law10-F124Y6YHkidcD0000000d@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
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

Hi!
i sent this question to the user list but maybe you would have more precise 
answers ...

I'd like to know if it's possible to use the current version of iptables in 
order to NAT different VPN established between different NATted hosts and 1 
remote gateway (the same gateway for all of them) ?  Such a NAT would be 
made by watching both addresses, ports and SPIs...

In other words :  is it possible for iptables to go and check the SPI field
in the ESP Header of the IPsec packet in ESP tunnel mode ?

Hope i make me clear enough :)
Thanks in advance !

Dimo

_________________________________________________________________
MSN Messenger 6  http://g.msn.fr/FR1001/866 : ajoutez une image à votre 
pseudo pour dialoguer avec vos amis
