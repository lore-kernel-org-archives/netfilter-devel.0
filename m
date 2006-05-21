From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: New extension: CRYPT target
Date: Mon, 22 May 2006 00:17:58 +0200
Message-ID: <4470E716.1090001@gmx.net>
References: <44708E68.9080508@speedy.com.ar> <44709CFC.7050007@gmx.net>
	<4470D859.7000706@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
In-Reply-To: <4470D859.7000706@speedy.com.ar>
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
> Carl-Daniel Hailfinger wrote:
>> Gervasio Bernal wrote:
>>
>>> (on host A, 1.2.3.4, FTP client)
>>> # iptables -t mangle -A POSTROUTING -d 1.2.3.5 -p tcp --dport 20:21 -j
>>> CRYPT --cipher blowfish --key topsecret --mode ecb --direction encrypt
>>
>> Ouch. If anybody runs ps while this iptables command is running, he has
>> your top secret key.

How are you going to prevent that?


>> Does this provide any benefit over IPSEC?

> IPSEC/OpenSwan is complicated to use and quite heavy.

I admit IPSEC is complicated to use, but it has lightweight modes.

> CRYPT is truely peer-to-peer.

IPSEC also has peer-to-peer modes.

> It is compatible with routing daemons.

Same for IPSEC to a certain extent (depends on how you use IPSEC)

> It allows you to encrypt all the traffic between two endpoints or
> only certain type of traffic (ej: only TCP connections).

Same for IPSEC.

> It is extremely easy to use for an administrator familiarized
> with Linux firewalling since it uses Iptables and it

Unfortunately, IPSEC is not so easy to use.

> does not make any modification to the normal routing behavior.

IPSEC can do that in some modes.

> CRYPT is considerably light and does all the
> encryption/decryption process at kernel space (contrary to OpenVPN).

OK, but does it have any advantages over an encryption library loaded
with LD_PRELOAD which replaces all networking functions for a given
application with its own encrypted variant? I consider "all in kernel"
to be a disadvantage.


What happens if a router on the way decides to fragment the packets?


I think your approach to encrypted communication is interesting, but
wouldn't an iptables interface to IPSEC in transport mode achieve
similar results?


Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
