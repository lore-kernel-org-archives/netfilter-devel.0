From: Wim Ceulemans <wim.ceulemans@able.be>
Subject: Re: New Version (1.13) of PPTP conntrack/nat helper
Date: Wed, 24 Sep 2003 13:42:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F718312.4020000@able.be>
References: <20030923144924.GM31401@sunbeam.de.gnumonks.org> <3F707404.5080107@able.be> <20030924101329.GW31401@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1064403727-26536-5"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030924101329.GW31401@sunbeam.de.gnumonks.org>
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

------------=_1064403727-26536-5
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Harald

Sorry, my mistake, the crashes occur with CONFIG_IP_NF_NAT_LOCAL is 
switched off.
I'll produce a debug log when CONFIG_IP_NF_NAT_LOCAL is on of one PPTP 
session through the firewall.

Regards
Wim

Harald Welte wrote:

>On Tue, Sep 23, 2003 at 06:25:40PM +0200, Wim Ceulemans wrote:
> 
>  
>
>>If I switch CONFIG_IP_NF_NAT_LOCAL off, the forwarding to a pptp server 
>>behind the firewall works.
>>If switch it on, I don't see any gre packet behind the firewall, so it 
>>does not work.
>>
>>However, with CONFIG_IP_NF_NAT_LOCAL on I have had two freezes (firewall 
>>completely stuck and I had to switch it on and off).
>>    
>>
>
>So to summarize:  It works perfectly of it is OFF, but you have problems
>with DNAT and crashes, if it is ON.  That is surprising - it seems like
>the problems have just been reverting :(
>
>Did you do anything in particular when the firewall hang happened? (like
>unloading/loading a module, ...)?
>
>  
>
>>Regards
>>Wim
>>    
>>
>
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


------------=_1064403727-26536-5--
