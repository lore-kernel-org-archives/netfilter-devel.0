From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Linux 2.6.14.5
Date: Tue, 27 Dec 2005 16:12:56 +0900 (JST)
Message-ID: <200512270712.jBR7CvUv016455@toshiba.co.jp>
References: <20051227060714.GA1053@linuxace.com>
	<200512270641.jBR6f6vt024777@toshiba.co.jp>
	<20051227065844.GA14828@alpha.home.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, gcoady@gmail.com,
	yasuyuki.kozakai@toshiba.co.jp, gregkh@suse.de,
	linux-kernel@vger.kernel.org, torvalds@osdl.org,
	kernel@linuxace.com, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: willy@w.ods.org
In-Reply-To: <20051227065844.GA14828@alpha.home.local>
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


From: Willy Tarreau <willy@w.ods.org>

> On Tue, Dec 27, 2005 at 03:41:05PM +0900, Yasuyuki KOZAKAI wrote:
> > From: Phil Oester <kernel@linuxace.com>
> > Date: Mon, 26 Dec 2005 22:07:14 -0800
> > 
> > > On Tue, Dec 27, 2005 at 06:45:19AM +0100, Willy Tarreau wrote:
> > > > On Tue, Dec 27, 2005 at 04:42:00PM +1100, Grant Coady wrote:
> > > > > + iptables -A INPUT -p all --match state --state ESTABLISHED,RELATED -j ACCEPT
> > > > > iptables: No chain/target/match by that name
> > > > 
> > > > So it's not only the NEW state, it's every "--match state".
> > > 
> > > Odd...works fine here
> > 
> > Willy, which version of iptables is ?
> > And kernel config around netfilter would be helpful.
> 
> Hey, it's Grant who has the problem, not me. Anyway, he fixed it,
> it seems it was related to an invalid .config.

Sorry about this, and thanks for report.

-- Yasuyuki Kozakai
