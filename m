From: Nils Ohlmeier <lists@ohlmeier.de>
Subject: Re: SIP Passthru
Date: Mon, 19 Jul 2004 14:12:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407191412.42935.lists@ohlmeier.de>
References: <04EA35F7-D780-11D8-9F58-000D93280A20@kenati.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andy Chinmulgund <andy@kenati.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <04EA35F7-D780-11D8-9F58-000D93280A20@kenati.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Andy,

the described behavior is completely SIP compliant, because if MC1 does not 
give a specific port number in its Via header it expects the reply implicitly 
on port 5060. I see two options to fix your problem:
- both clients use the rport extension (RFC 3581), thus the sending clients 
say "please reply on the port where my request came from and discard any port 
number from my Via header"
- you simply also re-write the port in the Via header to the port which you 
used to send the request. (Beware that you also insert your gateway port even 
if no port was present in the Via header)

Alternative two has the big advantage, that it will also works with clients 
which do not support RFC 3581, or are broken in any other way.

Greetings
  Nils

On Saturday 17 July 2004 01:29, Andy Chinmulgund wrote:
> Hi All,
>
> I am interested in SIP Conntrack and NAT module. I looked on the
> mailing list but could not find any. Hence I started developing it.
> I used 2.2 ip_masq_sip.c code as reference for mangling the Data inside
> the packet.
> I am at a stage where, I can successfully mangle the data in the
> packet. And when the other end receives the data, The SIP Msg body part
> contains Ext IP address of the firewall. Hence ringing at destination.
> Here is a snapshot of my network
>
> MC1==========>INT [ Gateway with SIP ALG] EXT===========>MC2
> 192.168.22.151      192.x.41
> 64.164.108.85               64.164.108.15
>
>
> Here is the flow of my SIP Session
> MC1 ========================>GW===================>MC2
> SRC:192.168.22.151: 1254
>                        SRC:64.164.108.85:1254
> DST:64.164.108.15:5060
>                           DST:64.164.108.15:5060
>
> This will make "Ring" on MC2. When MC2 sends ringing or OK status back
> the reply packet looks like:
>
> MC2======================>GW
> SRC:64.164.108.15:1300
> DST:64.164.108.85:5060
>
> Now, the Gateway receives this packet and tries to look for the
> matching tuple. But since the expected tuple is waiting to get reply on
> port 1254 and not 5060, the tuple does not match, and the packet is
> sent to Gateway Local stack(since the packet had Gateway IP address as
> DST IP). And Since Gateway is not listening on 5060, it sends an ICMP
> unreachable (PORT Unreachable) to 64.164.108.15(MC2)  and hence I could
> never get the call set-up.
>
> Note:
> This behavior is due to the fact that SIP is a Bizarre protocol. The
> SIP agent (I am using Ubiquity from SIP_CENTER) does not reply back to
> the port he received packet from but always sends his reply to port
> 5060 and that too with src port=xxx instead of 5060 (the one he recived
> on) Thus failing netfilter expected tuple match.
>
>
> Can anyone shed some light on how to proceed on this particular problem.
>
> Thanks in advance.
>
> -Andy
>
> Kenati Technologies
> 5150 El Camino Real Ste #D-20
> Los Altos, CA-94022
> Ph:650-210-9104
> Fax:650-210-9105
> www.kenati.com
