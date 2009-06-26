From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: netfilter 01/03: nf_conntrack_tcp: decrease timeouts while data
 in unacknowledged
Date: Fri, 26 Jun 2009 19:31:29 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0906261921480.19267@bizon.gios.gov.pl>
References: <20080731063312.18150.49494.sendpatchset@localhost.localdomain> <20080731063313.18150.27237.sendpatchset@localhost.localdomain> <alpine.LNX.1.10.0906261627500.2240@bizon.gios.gov.pl> <4A44E5DB.8000304@trash.net> <alpine.LNX.1.10.0906261827540.2240@bizon.gios.gov.pl>
 <4A44FF44.5030006@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1962599256-1246037489=:19267"
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:38307 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbZFZRbf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:31:35 -0400
In-Reply-To: <4A44FF44.5030006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1962599256-1246037489=:19267
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Fri, 26 Jun 2009, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> On Fri, 26 Jun 2009, Patrick McHardy wrote:
>> 
>>> Krzysztof Oledzki wrote:
>>>> This patch kills long living ftp transfers from one of my hosts. I'm not 
>>>> able to transfer large files if it takes more than 
>>>> net.netfilter.nf_conntrack_tcp_timeout_unacknowledged seconds.
>>>> 
>>>> After logging to the remote host and issuing any FTP command (ls or 
>>>> put/get for example) tuple's timeout is reduced. Additional commands are 
>>>> able to bump it but only upto 
>>>> net.netfilter.nf_conntrack_tcp_timeout_unacknowledged.
>>>> 
>>>> It seems that IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED flag is never cleard.
>>>> 
>>>> Tested on 2.6.28.10.
>>> 
>>> Interesting, are you using the FTP NAT helper?
>> 
>> Actually, yes :)
>> 
>>> I'm guessing there is some bad interaction between sequence number
>>> adjustments when changing the packet sizes and sequence number
>>> tracking in conntrack.
>> 
>> Very likely, src ip and nat ip have different lengths.
>
> I think I know what the problem is. We update the highest seen
> sequence number when adjusting packet lengths in NAT, but only
> upwards:
>
> void nf_conntrack_tcp_update(const struct sk_buff *skb,
> 			     unsigned int dataoff,
> 			     struct nf_conn *ct,
> 			     int dir)
> {
> ...
> 	if (after(end, ct->proto.tcp.seen[dir].td_end))
> 		ct->proto.tcp.seen[dir].td_end = end;
>
> So I'm guessing in your case, the NAT address is shorter than
> the original one.

Exactly. Just checked and this problem does not exist when
strlen(src_ip) <= strlen(nat_ip)

> This patch changes TCP conntrack to update the highest sequence
> number when the old number matches the new one + the size offset,
> so it should effectively update it after NAT whenever the packet
> caused an update before NAT.
>
> Please test whether this patch fixes the problem.

The patch fixes my problem. Thank you.

Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>


Best regards,

 			Krzysztof Olêdzki
---1144830174-1962599256-1246037489=:19267--
