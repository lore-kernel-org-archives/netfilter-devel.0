From: Wim Ceulemans <wim.ceulemans@able.be>
Subject: Re: New Version (1.13) of PPTP conntrack/nat helper
Date: Wed, 24 Sep 2003 18:34:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F71C7AA.9050700@able.be>
References: <20030923144924.GM31401@sunbeam.de.gnumonks.org> <3F707404.5080107@able.be> <20030924101329.GW31401@sunbeam.de.gnumonks.org> <3F718312.4020000@able.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1064421286-22334-8"
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wim Ceulemans <wim.ceulemans@able.be>
In-Reply-To: <3F718312.4020000@able.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format...

------------=_1064421286-22334-8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Harald

This is the debug log, with CONFIG_IP_NF_NAT_LOCAL switched on and one 
session trying pptp through the firewall to an internal windows2000 server.

18:26:06 kernel: ip_tables: (C) 2000-2002 Netfilter core team
18:26:06 kernel: ip_conntrack version 2.1 (2048 buckets, 16384 max) - 
324 bytes per conntrack
18:26:06 kernel: ip_conntrack_pptp.c:init: ip_conntrack_pptp.c: 
registering helper
18:26:06 kernel: ip_conntrack_pptp version 1.9 loaded
18:26:32 kernel: ip_nat_pptp.c:init: ip_nat_pptp.c: registering NAT helper
18:26:32 kernel: ip_nat_pptp version 1.5 loaded
18:26:58 kernel: ip_conntrack_pptp.c:conntrack_pptp_help: ctinfo = 2, 
skipping
18:26:58 kernel: ip_nat_pptp.c:tcp_help: entering
18:26:58 kernel: ip_nat_pptp.c:tcp_help: Not touching dir ORIG at hook 
PREROUTING
18:27:01 kernel: ip_conntrack_pptp.c:conntrack_pptp_help: ctinfo = 2, 
skipping
18:27:01 kernel: ip_nat_pptp.c:tcp_help: entering
18:27:01 kernel: ip_nat_pptp.c:tcp_help: Not touching dir ORIG at hook 
PREROUTING
18:27:07 kernel: ip_conntrack_pptp.c:conntrack_pptp_help: ctinfo = 2, 
skipping
18:27:07 kernel: ip_nat_pptp.c:tcp_help: entering
18:27:07 kernel: ip_nat_pptp.c:tcp_help: Not touching dir ORIG at hook 
PREROUTING

Regards
Wim


Wim Ceulemans wrote:

> Harald
>
> Sorry, my mistake, the crashes occur with CONFIG_IP_NF_NAT_LOCAL is 
> switched off.
> I'll produce a debug log when CONFIG_IP_NF_NAT_LOCAL is on of one PPTP 
> session through the firewall.
>
> Regards
> Wim
>
> Harald Welte wrote:
>
>> On Tue, Sep 23, 2003 at 06:25:40PM +0200, Wim Ceulemans wrote:
>>
>>  
>>
>>> If I switch CONFIG_IP_NF_NAT_LOCAL off, the forwarding to a pptp 
>>> server behind the firewall works.
>>> If switch it on, I don't see any gre packet behind the firewall, so 
>>> it does not work.
>>>
>>> However, with CONFIG_IP_NF_NAT_LOCAL on I have had two freezes 
>>> (firewall completely stuck and I had to switch it on and off).
>>>   
>>
>>
>> So to summarize:  It works perfectly of it is OFF, but you have problems
>> with DNAT and crashes, if it is ON.  That is surprising - it seems like
>> the problems have just been reverting :(
>>
>> Did you do anything in particular when the firewall hang happened? (like
>> unloading/loading a module, ...)?
>>
>>  
>>
>>> Regards
>>> Wim
>>>   
>>
>>
>>  
>>
>
>


-- 
Wim Ceulemans
R&D Engineer

Secure Internet Communication with aXs Guard

Able NV
Leuvensesteenweg 282 - B-3190 Boortmeerbeek - Belgium
Phone: + 32 15 50.44.00 - Fax: + 32 15 50.44.09
E-mail: wim.ceulemans@able.be



--
Security check on this e-mail has been done by aXs GUARD
(http://www.axsguard.com)


------------=_1064421286-22334-8--
