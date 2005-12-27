From: Grant Coady <grant_lkml@dodo.com.au>
Subject: Re: Linux 2.6.14.5
Date: Tue, 27 Dec 2005 17:51:43 +1100
Message-ID: <roo1r1pmr5fkq9n67osj5vcsas8htos868@4ax.com>
References: <20051227005327.GA21786@kroah.com> <32b1r156pu7much2m94ajva2bmcs4mpcag@4ax.com> <20051227051729.GR15993@alpha.home.local> <3ok1r15khvs8gka6qhhvt3u302mafkkr2r@4ax.com> <20051227054519.GA14609@alpha.home.local> <20051227060714.GA1053@linuxace.com>
Reply-To: gcoady@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <willy@w.ods.org>, gcoady@gmail.com,
	netfilter-devel@lists.netfilter.org, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, torvalds@osdl.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932249AbVL0GvZ@vger.kernel.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20051227060714.GA1053@linuxace.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 26 Dec 2005 22:07:14 -0800, Phil Oester <kernel@linuxace.com> wrote:

>On Tue, Dec 27, 2005 at 06:45:19AM +0100, Willy Tarreau wrote:
>> On Tue, Dec 27, 2005 at 04:42:00PM +1100, Grant Coady wrote:
>> > + iptables -A INPUT -p all --match state --state ESTABLISHED,RELATED -j ACCEPT
>> > iptables: No chain/target/match by that name
>> 
>> So it's not only the NEW state, it's every "--match state".
>
>Odd...works fine here
>
># uname -r
>2.6.14.5
># iptables -nL | grep state
>ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
>DROP       all  --  0.0.0.0/0            0.0.0.0/0           state INVALID 
>logdrop    tcp  --  0.0.0.0/0            0.0.0.0/0           tcp flags:!0x17/0x02 state NEW 
>ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
>DROP       all  --  0.0.0.0/0            0.0.0.0/0           state INVALID 

Oops, my apologies to all, just rebuilt kernel again (third time) 
from scratch, using the working .config from 2.6.14.4 -- I do not 
know how I muffed the .config twice in a row on one box without 
stuffing up the seven other boxen I built/tested 2.6.14.5 on :(

Can copying a working 2.6.15-rc7 .config to 2.6.14.5, then make 
oldconfig do this?

Grant.
