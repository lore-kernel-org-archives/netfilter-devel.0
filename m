From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: ICMP unreachable (DF) does not report the NATed IP
Date: 24 Apr 2003 21:31:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051212664.5944.47.camel@tux.rsn.bth.se>
References: <4F9AFAF72B246745B6847C7EECD8FF69024C8D5D@EXCHANGE1.charite.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Hillmann, Oliver" <Oliver.Hillmann@charite.de>
In-Reply-To: <4F9AFAF72B246745B6847C7EECD8FF69024C8D5D@EXCHANGE1.charite.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-04-24 at 17:37, Hillmann, Oliver wrote:
> Hi,

Hi

I'm moving this to the correct list.

I see the "10.0.1.2 reports that a packet didn't reach 10.0.1.2 due to
MTU and DF contraints" problem here (GRE tunnels between networks).

I havn't investigated it much yet but please go ahead :)

(you need to be subscribed to netfilter-devel@lists.netfilter.org to be
able to post without your messages beeing held for approval)

> I came across a problem with ICMP Unreachable Don't Fragment packages during the Path MTU discovery process on a linux software router which SNATs a small-MTU connected host to a larger-MTU network:
> 
> 
> host A |--link A--| linux router |--link B--| host B
> 10.0.0.1       10.0.0.2       10.0.1.2     10.0.1.1
> 
> 
> Link A has an MTU of 1400 (being a tunnel running PPP over L2TP over IP, that's why), Link B has an MTU of 1500. The router SNATs host A to its own interface address on link B, so that all connections to host B are seen as originating from the router.
> 
> When host B sends a return packet towards host A (like a response to a HTTP request), it can be up to 1500 bytes, which is too big for link A, it gets discarded by the router because the Dont Fragment flag is set. The router then informs host B of this by sending an ICMP Unreachable (Dont Fragment) packet and includes part of the dropped packet in this ICMP message, thus informing host B which packet has been dropped.
> 
> Unfortunataly, this part of the original packet shows the real IP of host A (10.0.0.1) and not the SNATed one (10.0.1.2) to which the original package has been sent. Obviously, the netfilter code un-SNATs the packet, so that it gets the 'real' IP of host A in order to be forwarded, then tries to send it, which fails, and now sends back the _un-SNATed_ packet portion. Consequently, host B discards this packet because it has never sent a package to the IP 10.0.0.1 reported in the ICMP error message.
> 
> SNATing in my setting is done via the usual POSTROUTING rule on the link B-interface of the router. Removing SNATing rules lets this setting work as expected, because the ICMP error messages now represent the actual network layout. Any TCPMSS tricks won't help either, simply because host A does not announce its MSS, and in fact announcing its MSS and discovering its MTU are two different things...
> 
> In order to have this kind of PMTU discovery working, the ICMP unreachable packets must represent the IP address of the SNAT-source interface. This could be either done a) by testing if a packet would have to be dropped due to DF contraints *before* mangling NAT IP addresses (which probably would break routing sementics), or b) by having some kind of ICMP NAT helper which mangles the reported IP addresses in the internet header payload of these packets.
> 
> Of course, this mangling would cause ICMP messages telling that you cannot send a packet to a host with this particular host's source address ("10.0.1.2 reports that a packet didn't reach 10.0.1.2 due to MTU and DF contraints"), which is kinda braindead and reflects the same dilemma as mentioned in ip_core_nat.c (having other host unreachable errors originating from the host reported unreachable), but then, NAT still is and always has been a hack and is partially braindead in itself...
> 
> Can anybody verify or falsify my observations? What do I miss? Is there a simple magic command line switch that makes this work and makes me look like an idiot? What can I do to solve this? Except writing some NAT helper for this? (Actually, I might try this if some networking jedis agree with me on the description of the problem... :)
> 
> Thanks for any comments!
> 
> Regards,
> 
> Oliver
> P.S.: Oh, and please forgive me for using this broken mail client. If you cannot forgive, at least feel some amount of pity that I am forced to this stupid bloat thing instead of decent pine... Or mutt... Or elm... :)

-- 
/Martin
