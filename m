From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Linux 2.6.14.5
Date: Tue, 27 Dec 2005 15:41:05 +0900 (JST)
Message-ID: <200512270641.jBR6f6Zg023683@toshiba.co.jp>
References: <3ok1r15khvs8gka6qhhvt3u302mafkkr2r@4ax.com>
	<20051227054519.GA14609@alpha.home.local>
	<20051227060714.GA1053@linuxace.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: willy@w.ods.org, gregkh@suse.de, gcoady@gmail.com,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	torvalds@osdl.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932243AbVL0GlQ@vger.kernel.org>
To: kernel@linuxace.com
In-Reply-To: <20051227060714.GA1053@linuxace.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Phil Oester <kernel@linuxace.com>
Date: Mon, 26 Dec 2005 22:07:14 -0800

> On Tue, Dec 27, 2005 at 06:45:19AM +0100, Willy Tarreau wrote:
> > On Tue, Dec 27, 2005 at 04:42:00PM +1100, Grant Coady wrote:
> > > + iptables -A INPUT -p all --match state --state ESTABLISHED,RELATED -j ACCEPT
> > > iptables: No chain/target/match by that name
> > 
> > So it's not only the NEW state, it's every "--match state".
> 
> Odd...works fine here

Willy, which version of iptables is ?
And kernel config around netfilter would be helpful.

Regards,

-- Yasuyuki Kozakai
