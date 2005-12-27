From: Phil Oester <kernel@linuxace.com>
Subject: Re: Linux 2.6.14.5
Date: Mon, 26 Dec 2005 22:07:14 -0800
Message-ID: <20051227060714.GA1053@linuxace.com>
References: <20051227005327.GA21786@kroah.com>
	<32b1r156pu7much2m94ajva2bmcs4mpcag@4ax.com>
	<20051227051729.GR15993@alpha.home.local>
	<3ok1r15khvs8gka6qhhvt3u302mafkkr2r@4ax.com>
	<20051227054519.GA14609@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <gregkh@suse.de>, gcoady@gmail.com,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, torvalds@osdl.org, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
Content-Disposition: inline
In-Reply-To: <20051227054519.GA14609@alpha.home.local>
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

On Tue, Dec 27, 2005 at 06:45:19AM +0100, Willy Tarreau wrote:
> On Tue, Dec 27, 2005 at 04:42:00PM +1100, Grant Coady wrote:
> > + iptables -A INPUT -p all --match state --state ESTABLISHED,RELATED -j ACCEPT
> > iptables: No chain/target/match by that name
> 
> So it's not only the NEW state, it's every "--match state".

Odd...works fine here

# uname -r
2.6.14.5
# iptables -nL | grep state
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
DROP       all  --  0.0.0.0/0            0.0.0.0/0           state INVALID 
logdrop    tcp  --  0.0.0.0/0            0.0.0.0/0           tcp flags:!0x17/0x02 state NEW 
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
DROP       all  --  0.0.0.0/0            0.0.0.0/0           state INVALID 

Phil
