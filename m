From: Filip Sneppe <filip.sneppe@gmail.com>
Subject: Re: Iptables Match on Direction (IP_CT_IS_REPLY)
Date: Sun, 27 Feb 2005 21:37:38 +0100
Message-ID: <9151ac2a05022712376c099fb4@mail.gmail.com>
References: <20050226124304.13105.qmail@web90010.mail.scd.yahoo.com>
Reply-To: Filip Sneppe <filip.sneppe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Peter Lenci <peterlenci@yahoo.ca>
In-Reply-To: <20050226124304.13105.qmail@web90010.mail.scd.yahoo.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Peter,

On Sat, 26 Feb 2005 07:43:03 -0500 (EST), Peter Lenci
<peterlenci@yahoo.ca> wrote:
> Hi there
> 
> Is there a possibility to access flag IP_CT_IS_REPLY from an iptables
> command?
> 
> I have only spotted the "--direction original|reply|both" option from
> the connbytes patch
> (http://www.netfilter.org/patch-o-matic/pom-extra.html#pom-extra-connbytes)
> but then I would prefer not to waste memory by counting bytes.
> 

The "conntrack" match should do what you are looking for. From the help
option:

conntrack match v1.2.11 options:
 [!] --ctstate [INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED|SNAT|DNAT][,...]
				State(s) to match
 [!] --ctproto	proto		Protocol to match; by number or name, eg. `tcp'
     --ctorigsrc  [!] address[/mask]
				Original source specification
     --ctorigdst  [!] address[/mask]
				Original destination specification
     --ctreplsrc  [!] address[/mask]
				Reply source specification
     --ctrepldst  [!] address[/mask]
				Reply destination specification
 [!] --ctstatus [NONE|EXPECTED|SEEN_REPLY|ASSURED|CONFIRMED][,...]
				Status(es) to match
 [!] --ctexpire time[:time]	Match remaining lifetime in seconds against
				value or range of values (inclusive)

Regards,
Filip
