From: Wim Ceulemans <wim.ceulemans@able.be>
Subject: Re: New Version (1.13) of PPTP conntrack/nat helper
Date: Tue, 23 Sep 2003 18:25:40 +0200
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <3F707404.5080107@able.be>
References: <20030922203033.GD31401@sunbeam.de.gnumonks.org> <3F704CC7.7060508@able.be> <20030923144924.GM31401@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1064334337-13531-58"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030923144924.GM31401@sunbeam.de.gnumonks.org>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format...

------------=_1064334337-13531-58
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Harald

I now just dnatted the 1723/tcp connection.

If I switch CONFIG_IP_NF_NAT_LOCAL off, the forwarding to a pptp server 
behind the firewall works.
If switch it on, I don't see any gre packet behind the firewall, so it 
does not work.

However, with CONFIG_IP_NF_NAT_LOCAL on I have had two freezes (firewall 
completely stuck and I had to switch it on and off).

Regards
Wim

Harald Welte wrote:

>On Tue, Sep 23, 2003 at 03:38:15PM +0200, Wim Ceulemans wrote:
>  
>
>>Hi Harald
>>
>>Thanks for the patch.
>>
>>I tried patch-o-matic-20030922 with kernel 2.4.22 and connection to the 
>>PPTP server seems to work reliable now. Before this patch, connecting 
>>from a winxp machine did  succeed one out of 2 times, now it always 
>>succeeds.
>>
>>However, I also tried forwarding port 1723 and gre to a pptp server 
>>(win2000) behind the firewall. And there seems to be a problem with 
>>forwarding of the gre protocol. The connection to port 1723 behind the 
>>firewall succeeeds, but I don't see gre packets pass the firewall. I 
>>added these rules:
>>
>>iptables -t nat -A  PREROUTING -p TCP -d <wanip> --dport 1723 -j DNAT 
>>--to <winip>:1723
>>iptables -t nat -A  PREROUTING -p GRE -d <wanip> -j DNAT --to <winip>
>>    
>>
>
>This is _not_ how it works.  Please just DNAT the 1723/tcp connection.
>The gre connection is DNAT'ed accordingly (just like with any other nat
>helper).  so please skip the second rule
>
>  
>
>>iptables -A FORWARD -p TCP -d <winip> --dport 1723 -j ACCEPT
>>iptables -A FORWARD -p GRE -d <winip> -j ACCEPT
>>    
>>
>
>Those are not stateful rules.  You should make sure that you only accept 
>ESTABLISHED and RELATED gre.  Otherwise weird problems might occur.
>
>If it still doesn't work, please check if you have enabled
>CONFIG_IP_NF_NAT_LOCAL or not.  (try it with and without).
>
>If it still doesn't work, please enable debugging (set the '#if 0' to
>'#if 1' in ip_conntrack_pptp.c and ip_nat_pptp.c, ignore the compiler
>warnings and send me the syslog excerpt of _one_ failing session.
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


------------=_1064334337-13531-58--
