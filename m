From: Willy Tarreau <willy@w.ods.org>
Subject: Re: -m physdev iptables: Invalid Argument
Date: Sat, 25 Oct 2003 11:21:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031025092117.GA17255@alpha.home.local>
References: <3F996BBA.5070106@metavize.com> <3F99B88D.1060000@trash.net> <3F99BD97.2080409@metavize.com> <3F99BFDA.6030506@trash.net> <3F99C340.2070202@metavize.com> <3F99C692.90703@trash.net> <3F99CB83.1020405@metavize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dirk Morris <dmorris@metavize.com>
Content-Disposition: inline
In-Reply-To: <3F99CB83.1020405@metavize.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Oct 24, 2003 at 06:01:55PM -0700, Dirk Morris wrote:
> ~/iptables-1.2.9rc1 # ./iptables 
> --version                                                         
> iptables v1.2.9rc1
> ~/iptables-1.2.9rc1 # uname 
> -a                                                                     
> Linux timmy 2.6.0-test8 #2 Wed Oct 22 15:14:09 PDT 2003 i686 GNU/Linux
> 
> I don't know what else to try at this point.
> 
> ~/iptables-1.2.9rc1 # sudo ./iptables -t nat -A PREROUTING -m physdev 
> --physdev-in eth0 -j REJECT
> iptables: Invalid argument
> ~/iptables-1.2.9rc1 # sudo ./iptables -t nat -A PREROUTING -j REJECT -m 
> physdev --physdev-in eth0
> iptables: Invalid argument

Just out of curiosity, are you sure it's not the REJECT which causes the
invalid argument ?

could you try :
 - iptables -t nat -A PREROUTING -m physdev --physdev-in eth0 -j DROP
 - iptables -t nat -A PREROUTING -j REJECT

and check which one returns an error ?

Was your iptables-1.2.9rc1 compiled with 2.6.0test8 headers or with 2.4
headers ? it might make a difference.

Regards,
Willy
