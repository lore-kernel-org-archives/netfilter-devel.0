From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack/NAT module
Date: Sun, 9 Jun 2002 19:30:23 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020609173023.GD3305@naboo.de.gnumonks.org>
References: <02060510364800.10075@luoqiang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: luoqiang <luoqiang@ict.ac.cn>
Content-Disposition: inline
In-Reply-To: <02060510364800.10075@luoqiang>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 05, 2002 at 10:36:48AM +0800, luoqiang wrote:
> Hi,Harald
> 
>    Thanks for your answers.
>    I am afraid that the conntrack module for DNAT is not correct now.my 
> purpose of the two module is to achieve the rule  which is "iptables -A 
> PREROUTING -t nat -p udp -d 159.226.1.1 --dport 5001 -j DNAT --to 
> 192.168.1.2:8888".

well. from having a short view at your code, i'm unable to determine the
reason of it's malfunction.

it might be worth trying to see what verdict ip_nat_setup_info is
actually returning, since that particular (hardcoded) ip_address /
portnumber range could be already in use.

Another issue could be endianness... 

> > luoqiang

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
