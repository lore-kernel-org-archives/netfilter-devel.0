From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: Re: New extension: CRYPT target
Date: Mon, 22 May 2006 20:36:00 -0300
Message-ID: <44724AE0.5040708@speedy.com.ar>
References: <44708E68.9080508@speedy.com.ar> <44709CFC.7050007@gmx.net>
	<4470D859.7000706@speedy.com.ar>
	<10007.1148252261@sandelman.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <10007.1148252261@sandelman.ottawa.on.ca>
To: netfilter-devel@lists.netfilter.org
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

Michael Richardson wrote:
> 
> 
>>>>>>>"Gervasio" == Gervasio Bernal <gervasiobernal@speedy.com.ar> writes:
> 
>     Gervasio> Carl-Daniel Hailfinger wrote:
>     >> Gervasio Bernal wrote:
>     >> 
>     >>> (on host A, 1.2.3.4, FTP client) # iptables -t mangle -A
>     >>> POSTROUTING -d 1.2.3.5 -p tcp --dport 20:21 -j CRYPT --cipher
>     >>> blowfish --key topsecret --mode ecb --direction encrypt
>     >> 
>     >> 
>     >> Ouch. If anybody runs ps while this iptables command is running,
>     >> he has your top secret key.
>     >> 
>     >> Does this provide any benefit over IPSEC?
>     Gervasio> IPSEC/OpenSwan is complicated to use and quite heavy.
>   
>   Have you tried?
>   It is not heavy. Your solution is generally rather incomplete, since
> it seems to lack any configuration file, policy system, or automatic key
> management. 

The idea behind CRYPT extension is not to replace IPSEC absolutely, but
to be a simple alternative of use for encryption/decryption and packet
authentication using Iptables. It could be useful for somebody.

We have also developed a module in Python that use the CRYPT extension,
configuration files, has automatic key management and user
authentication using certificates. But we need that someone else can
test first the extension alone, and comments its experience to us.

> 
>   It is only complicated if you have been mislead into assuming that you
> need a certificate. (ipsec-tools' racoon is guilty in that regard)
> 
>     Gervasio> CRYPT is truely peer-to-peer. It is compatible with
>     Gervasio> routing daemons. It allows you to encrypt all the traffic
>     Gervasio> between two endpoints or only certain type of traffic (ej:
>     Gervasio> only TCP connections). It is extremely easy to use for an
> 
>   I do exactly that regularly.
> 
>     Gervasio> administrator familiarized with Linux firewalling since it
>     Gervasio> uses Iptables and it does not make any modification to the
>     Gervasio> normal routing behavior. CRYPT is considerably light and
> 
>   We have patches that permit you to decide what to encrypt using
> iptables. 
> 
