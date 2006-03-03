From: Chinh Nguyen <cnguyen@certicom.com>
Subject: Re: Table NAT and MANGLE
Date: Fri, 03 Mar 2006 11:04:11 -0500
Message-ID: <440868FB.2080703@certicom.com>
References: <44075594.3000608@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44075594.3000608@speedy.com.ar>
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


Gervasio Bernal wrote:
> Hi all!!
> 
> Suppose I have this 2 rules, one in mangle and the other one in NAT table:
> 
> #iptables -t mangle -A POSTROUTING -o eth0 -j TTL --ttl-set 64
> #iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
> 
> So, every time a packet goes out through eth0 first it sets the TTL to
> 64 and then do the masquerade. Is there any way to do this but in
> opposite order? First masquerade and the TTL.
> Maybe this example is not very clear, but I'm developing a module that
> needs to match a packet after masquerade.
> 
> Thanks.
> 

>From the manual for SNAT "... and rules should cease being examined". You can't
do anything after SNAT. Since MASQUERADE is kind of a special case of SNAT, IMO,
you can't use another rule after MASQUERADE either.

It should be noted that there seems to be at least 1 exception, although I don't
know if there are others.

For example, with the latest iptables & kernel (2.6.16-rc4 as of this writing),
you can SNAT (probably MASQUERADE) or DNAT before encrypting a packet with
IPsec. This is accomplished by using the -m policy module.

iptables -A POSTROUTING -t nat -m policy ... -j SNAT.

In other words, any packet that matches an IPSec policy can then be SNAT/DNAT
before encryption/decryption. Practically, there is an action (encryption) that
is applied after the NAT. Functionally though, it's still only 1 SNAT/DNAT rule
 after which no other will apply.

But perhaps there are other "2 rules in 1" exceptions. I don't know myself.

Regards.
