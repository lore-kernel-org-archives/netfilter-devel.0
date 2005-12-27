From: Willy Tarreau <willy@w.ods.org>
Subject: Re: Linux 2.6.14.5
Date: Tue, 27 Dec 2005 06:45:19 +0100
Message-ID: <20051227054519.GA14609@alpha.home.local>
References: <20051227005327.GA21786@kroah.com>
	<32b1r156pu7much2m94ajva2bmcs4mpcag@4ax.com>
	<20051227051729.GR15993@alpha.home.local>
	<3ok1r15khvs8gka6qhhvt3u302mafkkr2r@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, torvalds@osdl.org,
	Willy Tarreau <willy@w.ods.org>, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: gcoady@gmail.com
Content-Disposition: inline
In-Reply-To: <3ok1r15khvs8gka6qhhvt3u302mafkkr2r@4ax.com>
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

On Tue, Dec 27, 2005 at 04:42:00PM +1100, Grant Coady wrote:
> On Tue, 27 Dec 2005 06:17:29 +0100, Willy Tarreau <willy@w.ods.org> wrote:
> 
> >On Tue, Dec 27, 2005 at 02:06:03PM +1100, Grant Coady wrote:
> >> On Mon, 26 Dec 2005 16:53:27 -0800, Greg KH <gregkh@suse.de> wrote:
> >> 
> >> >We (the -stable team) are announcing the release of the 2.6.14.5 kernel.
> >> >
> >> >The diffstat and short summary of the fixes are below.
> >> >
> >> >I'll also be replying to this message with a copy of the patch between
> >> >2.6.14.4 and 2.6.14.5, as it is small enough to do so.
> >> 
> >> netfilter is broken compared to 2.6.15-rc7 (first 2.6 kernel tested 
> >> on this box) or 2.4.32 :(  Same ruleset as used for months.
> >> 
> >> Fails to recognise named chains with a useless error message:
> >> 
> >> "iptables: No chain/target/match by that name"
> >
> >Grant, please put a "set -x" at the top of your script so that you
> >can tell what rule causes this error.
> 
> + iptables -A INPUT -p all --match state --state ESTABLISHED,RELATED -j ACCEPT
> iptables: No chain/target/match by that name

So it's not only the NEW state, it's every "--match state".

> + iptables -A INPUT -p tcp --match state --state NEW --dport ftp --match limit --limit 3/min -j ACCEPT
> iptables: No chain/target/match by that name
> + iptables -A INPUT -p tcp --match state --state NEW --dport ftp -j DROP
> iptables: No chain/target/match by that name
> + iptables -A INPUT -p tcp --match state --state NEW --dport http --match limit --limit 12/min -j ACCEPT
> iptables: No chain/target/match by that name
> + iptables -A INPUT -p tcp --match state --state NEW --dport http -j DROP
> iptables: No chain/target/match by that name
>   FORWARD + iptables -A FORWARD -p all --match state --state ESTABLISHED,RELATED -j ACCEPT
> iptables: No chain/target/match by that name
> + iptables -A egress -p tcp --match state --state NEW --match multiport --dports ftp,http,pop3,nntp,pop3s -j ACCEPT
> iptables: No chain/target/match by that name
> + iptables -A egress -p tcp --match state --state NEW --match multiport --dports https,rsync -j ACCEPT
> iptables: No chain/target/match by that name
> + iptables -A egress -p all --match state --state NEW --match limit --limit 12/min -j ACCEPT
> iptables: No chain/target/match by that name

Thanks,
Willy
