From: Wim Ceulemans <wim.ceulemans@able.be>
Subject: Re: New Version (1.13) of PPTP conntrack/nat helper
Date: Tue, 23 Sep 2003 15:38:15 +0200
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <3F704CC7.7060508@able.be>
References: <20030922203033.GD31401@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1064324292-26429-68"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030922203033.GD31401@sunbeam.de.gnumonks.org>
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

------------=_1064324292-26429-68
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Harald

Thanks for the patch.

I tried patch-o-matic-20030922 with kernel 2.4.22 and connection to the 
PPTP server seems to work reliable now. Before this patch, connecting 
from a winxp machine did  succeed one out of 2 times, now it always 
succeeds.

However, I also tried forwarding port 1723 and gre to a pptp server 
(win2000) behind the firewall. And there seems to be a problem with 
forwarding of the gre protocol. The connection to port 1723 behind the 
firewall succeeeds, but I don't see gre packets pass the firewall. I 
added these rules:

iptables -t nat -A  PREROUTING -p TCP -d <wanip> --dport 1723 -j DNAT 
--to <winip>:1723
iptables -t nat -A  PREROUTING -p GRE -d <wanip> -j DNAT --to <winip>
iptables -A FORWARD -p TCP -d <winip> --dport 1723 -j ACCEPT
iptables -A FORWARD -p GRE -d <winip> -j ACCEPT

The following modules are loaded:

ppp_mppe               20152   0  (autoclean)
ppp_async               6368   0  (autoclean)
ip_nat_proto_gre        1284   0  (unused)
ip_nat_pptp             1836   0  (unused)
ip_nat_irc              2384   0  (unused)
ip_nat_h323             2604   0  (unused)
ip_nat_ftp              3024   0  (unused)
ipsec_aes              31880   0  (unused)
ipsec                 252608   2  [ipsec_aes]
ipt_REDIRECT             824   1  (autoclean)
ipt_MASQUERADE          1240   1  (autoclean)
ipt_TCPMSS              2424   1  (autoclean)
ipt_unclean             6776   2  (autoclean)
ipt_limit                952   2  (autoclean)
ipt_LOG                 3224   5  (autoclean)
ipt_state                600   8  (autoclean)
ipt_multiport            632  11  (autoclean)
ip_conntrack_pptp       2320   1
ip_conntrack_proto_gre    2004   0  [ip_nat_pptp ip_conntrack_pptp]
ip_conntrack_irc        3120   1
ip_conntrack_h323       2320   1
ip_conntrack_ftp        3824   1
iptable_mangle          2192   1
iptable_nat            14424   6  [ip_nat_proto_gre ip_nat_pptp 
ip_nat_irc ip_nat_h323 ip_nat_ftp ipt_REDIRECT ipt_MASQUERADE]
ip_conntrack           16352   7  [ip_nat_pptp ip_nat_irc ip_nat_h323 
ip_nat_ftp ipt_REDIRECT ipt_MASQUERADE ipt_state ip_conntrack_pptp 
ip_conntrack_proto_gre ip_conntrack_irc ip_conntrack_h323 
ip_conntrack_ftp iptable_nat]
iptable_filter          1700   1
ip_tables              10968  13  [ipt_REDIRECT ipt_MASQUERADE 
ipt_TCPMSS ipt_unclean ipt_limit ipt_LOG ipt_state ipt_multiport 
iptable_mangle iptable_nat iptable_filter]
ppp_deflate             2936   0
zlib_inflate           18308   0  [ppp_deflate]
zlib_deflate           17624   0  [ppp_deflate]
bsd_comp                4024   0
ppp_generic            19168   0  [ppp_mppe ppp_async ppp_deflate bsd_comp]
slhc                    4480   0  [ppp_generic]
8139too                13448   3
mii                     2224   0  [8139too]


Regards
Wim

Harald Welte wrote:

>Hi!
>
>I've just released the long-awaited new version of the PPTP
>conntrack/NAT helper.  It can be found in the current patch-o-matic CVS,
>or in the CVS snapshot that is going to be created tonight
>(patch-o-matic-20030922).
>
>It has been working in my test network with four PPTP clients, in mixed
>DNAT, SNAT and local (i.e. terminated on a PPTPD on the NAT gw itself)
>connection setup - both with and without CONFIG_IP_NF_NAT_LOCAL.
>
>Please feel free to test this new patch and report any bugs/errors back
>to me.
>
>Thanks to everybody who has contibuted to the PPTP helper in the past,
>and thanks for your patience in waiting for this release.
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


------------=_1064324292-26429-68--
