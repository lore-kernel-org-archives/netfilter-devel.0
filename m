From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: Re: New extension: CRYPT target
Date: Sun, 21 May 2006 18:15:05 -0300
Message-ID: <4470D859.7000706@speedy.com.ar>
References: <44708E68.9080508@speedy.com.ar> <44709CFC.7050007@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <44709CFC.7050007@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Gervasio Bernal wrote:
> 
>>(on host A, 1.2.3.4, FTP client)
>># iptables -t mangle -A POSTROUTING -d 1.2.3.5 -p tcp --dport 20:21 -j
>>CRYPT --cipher blowfish --key topsecret --mode ecb --direction encrypt
> 
> 
> Ouch. If anybody runs ps while this iptables command is running, he has
> your top secret key.
> 
> Does this provide any benefit over IPSEC?
IPSEC/OpenSwan is complicated to use and quite heavy.
CRYPT is truely peer-to-peer. It is compatible with routing daemons. It
allows you to encrypt all the traffic between two endpoints or only
certain type of traffic (ej: only TCP connections). It is extremely easy
to use for an administrator familiarized with Linux firewalling since it
uses Iptables and it does not make any modification to the normal
routing behavior. CRYPT is considerably light and does all the
encryption/decryption process at kernel space (contrary to OpenVPN).

> 
> Regards,
> Carl-Daniel
