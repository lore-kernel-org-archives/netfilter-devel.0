From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Problem with seq adjustment for NAT over loopback device
Date: Fri, 03 Jun 2011 12:10:04 +0200
Message-ID: <4DE8B2FC.4040601@netfilter.org>
References: <alpine.LFD.2.00.1105292126080.1429@ja.ssi.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51499 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab1FCKKH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jun 2011 06:10:07 -0400
In-Reply-To: <alpine.LFD.2.00.1105292126080.1429@ja.ssi.bg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29/05/11 20:36, Julian Anastasov wrote:
> 
> 	Hello,
> 
> 	I see a problem that nf_nat_seq_adjust is called twice
> for same packet. I saw it while playing with IPVS NAT forwarding
> over loopback device, it happens for iptables -j DNAT too. For example:
> 
> - I'm adding two addresses: 192.168.1.200 (long) and 192.168.1.2 (short)
> 
> - Adding DNAT rule to redirect local clients to different local server:
> 
> iptables -t nat -A OUTPUT -p TCP -d 192.168.1.200 --dport 21 \
> 	-j DNAT --to-destination 192.168.1.2
> 
> 	Trying passive FTP causes address info in PASV response
> to be mangled in reply direction from 192.168.1.2 to 192.168.1.200
> increasing the payload with 2 bytes. Later, in original direction the
> acks are decreased with 2 but the problem is that it happens
> once in POSTROUTING and second time in LOCAL_IN, i.e. the two places
> where seq adjustment happens in ipv4_confirm. The funny effect is
> that the client receives next response with the "\r\n" (remember,
> 2 bytes) from the PASV response copied before the next 150 response:
> 
> RX: 227 Entering Passive Mode (...)\r\n		<<<- \r\n duplicated
> TX: LIST\r\n
> RX: \r\n150 Directory listing	<<<- extra "\r\n" at beginning
> 
> 	I assume the problem happens because same conntrack is
> used in original direction for the outgoing phase (OUTPUT->POSTROUTING)
> and for the incoming phase (PREROUTING->LOCAL_IN). Looking at
> nf_nat_rule_find() I see that checking with nf_nat_initialized()
> allows only one src and/or one dst manipulation. For traffic
> over loopback I assume these NAT manipulations will be scheduled
> in OUTPUT and POSTROUTING (the outgoing phase) and no NAT
> rules will be considered from the incoming phase (PREROUTING and
> LOCAL_IN). In such case NAT does not occur in the incoming
> phase and we do not need any seq adjustments and NAT manips
> in LOCAL_IN for loopback traffic.
> 
> 	I guess that a skb flag is needed that can be set after
> POSTROUTING, so that we should avoid any SEQ and NAT manipulations
> for the incoming phase if this flag is set. All NAT hooks
> can ignore such packets to save some CPU cycles (NF_ACCEPT in
> nf_nat_fn). By this way, even if a single manipulation is possible
> for two hooks, eg. src manip for POSTROUTING and LOCAL_IN,
> and dst manip for PREROUTING and OUTPUT we should do it only
> once for a packet.
> 
> 	Any ideas how to solve this problem? If such solution
> sounds good I can prepare and test some patch...

I haven't missed this report :-), however, I didn't come with a clean
solution for this yet, let give it some spins.
