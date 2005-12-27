From: Willy Tarreau <willy@w.ods.org>
Subject: Re: Linux 2.6.14.5
Date: Tue, 27 Dec 2005 07:58:44 +0100
Message-ID: <20051227065844.GA14828@alpha.home.local>
References: <3ok1r15khvs8gka6qhhvt3u302mafkkr2r@4ax.com>
	<20051227054519.GA14609@alpha.home.local>
	<20051227060714.GA1053@linuxace.com>
	<200512270641.jBR6f6vt024777@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gregkh@suse.de, gcoady@gmail.com, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, torvalds@osdl.org, willy@w.ods.org,
	kernel@linuxace.com, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200512270641.jBR6f6vt024777@toshiba.co.jp>
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

On Tue, Dec 27, 2005 at 03:41:05PM +0900, Yasuyuki KOZAKAI wrote:
> 
> Hi,
> 
> From: Phil Oester <kernel@linuxace.com>
> Date: Mon, 26 Dec 2005 22:07:14 -0800
> 
> > On Tue, Dec 27, 2005 at 06:45:19AM +0100, Willy Tarreau wrote:
> > > On Tue, Dec 27, 2005 at 04:42:00PM +1100, Grant Coady wrote:
> > > > + iptables -A INPUT -p all --match state --state ESTABLISHED,RELATED -j ACCEPT
> > > > iptables: No chain/target/match by that name
> > > 
> > > So it's not only the NEW state, it's every "--match state".
> > 
> > Odd...works fine here
> 
> Willy, which version of iptables is ?
> And kernel config around netfilter would be helpful.

Hey, it's Grant who has the problem, not me. Anyway, he fixed it,
it seems it was related to an invalid .config.

> Regards,
> 
> -- Yasuyuki Kozakai

Regards,
willy
