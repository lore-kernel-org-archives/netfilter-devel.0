From: Rodrigo Severo <rodrigo.lists@fabricadeideias.com>
Subject: Re: iptables target conflict?  ROUTE and MASQUERADE
Date: Tue, 16 Dec 2003 10:13:29 -0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FDEF6E9.8060401@fabricadeideias.com>
References: <BAY13-F105p0oKHV3SF000296b7@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <BAY13-F105p0oKHV3SF000296b7@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Wu Nick wrote:

> That is, I'd like to send packets out from different ppp interfaces
> and their source IP addresses needed to be changed to the IP addess of
> the specific ppp interface. Do you have any idea about how to do?

I have been doing this kind of thing for 2 pppoe connections with the
following setup:

In PREROUTING, table mangle, I mark the packets for each ppp:
iptables -A PREROUTING -t mangle -j MARK --set-mark 0x1 -p tcp --dport 80-82
iptables -A PREROUTING -t mangle -j MARK --set-mark 0x2 -p tcp --dport 25

I create routing rules (not routing entries) that will effectivelly
separate the packets for each pppoe connection:
ip rule add fwmark 1 pref 110 table adsl1
ip rule add fwmark 2 pref 120 table adsl2

Finally, in the POSTROUTING, table nat, I SNAT the packets for each
ppppoe connection:
iptables -A POSTROUTING -t nat -o ppp0 -j SNAT --to-source
<ppp0_valid_address>
iptables -A POSTROUTING -t nat -o ppp1 -j SNAT --to-source
<ppp1_valid_address>

A few comments:

I created this setup more than 2 years ago, before the CONFIG_IP_NF_TARGET_ROUTE and the CONFIG_IP_NF_NAT_LOCAL existed. I'm not sure that nowadays this is the best approach. It surelly was the only one that worked for me in 2000.

Using SNAT instead of MASQUERADE means that I have to recreate the nat rules each time a pppoe connection goes up. I had to do this because MASQUERADE wouldn't work on locally generated connections, only SNAT.


I hope all this is of any help,

Rodrigo Severo

-- 
----------------------------------------------------
Rodrigo Severo
Fa'brica de Ide'ias
Fone: +55(61)321 1357
Fax: +55(61)223 1712
SBS - Quadra 2 - Ed. Empire Center - Sala 1301
Brasi'lia/DF - Brasil
CEP: 70.070-904
----------------------------------------------------
