From: "dimitri borjac" <dimitri_borjac@hotmail.com>
Subject: RE: iptables and SPI...
Date: Fri, 31 Oct 2003 18:07:08 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Law10-F5700goZolmRB000000bb@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: hno@marasystems.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


>  -----Message d'origine-----
>  De : Henrik Nordstrom [mailto:hno@marasystems.com]
>  Envoyé : vendredi 31 octobre 2003 18:42
>  À : dimitri borjac
>  Cc : laforge@netfilter.org; netfilter-devel@lists.netfilter.org
>  Objet : RE: iptables and SPI...
>    On Fri, 31 Oct 2003, dimitri borjac wrote:
>   > what i'm trying to do is to perform NAT based on 
>IP_addresses/Ports/SPIs.
>   Why not simply using a IP-Sec implementation supporting the  
>NAT-Transversal standard?
>   IP-Sec is generally not very happy about being NAT:ed. For examle AH is
>  totally incompatible with NAT (unless using the NAT-Transversal 
>standard).
>   Regards
>  Henrik

Just because I don't want to be compelled to use NAT-Traversal :)

And the only solution in this case is to NAT using the SPI... indeed by 
default AH is not compatible with NAT, and neither is ESP in transport mode, 
but ESP in tunnel mode supports the NAT (since the whole encrypted IP packet 
is encapsulated in a new IP header).

The only problem then (with ESP in tunnel mode) is for the local gateway : 
it has to know who the encrypted packet coming back to the local network is 
destinated to... that's where the SPI is helpful.

So the problem is still there... is it possible to extend the NAT functions 
of iptables in order to make the local gateway read and use the SPI for 
NATting packets ?

Regards,
dimo

_________________________________________________________________
Trouvez l'âme soeur sur MSN Rencontres ! http://g.msn.fr/FR1000/9551
