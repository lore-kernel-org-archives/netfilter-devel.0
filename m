From: Martin Wilck <Martin.Wilck@Fujitsu-Siemens.com>
Subject: Re: ip_conntrack_hash() problem
Date: 05 Sep 2002 09:19:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1031210342.9785.159.camel@biker.pdb.fsc.net>
References: <20020905044436.0772A2C0DF@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <ak@suse.de>, Harald Welte <laforge@gnumonks.org>,
   Netfilter
	Mailing List <netfilter-devel@lists.netfilter.org>,
   Linux Kernel mailing list
	 <linux-kernel@vger.kernel.org>,
   Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20020905044436.0772A2C0DF@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Am Don, 2002-09-05 um 02.39 schrieb Rusty Russell:

> This work is already done:
> http://www.kernel.org/pub/linux/kernel/people/rusty/patches/Netfilter/conntrack_hashing.patch.gz

Well, beautiful.
Will this go into the main line kernel any time soon?
(I'd be for that).

If there's still need for discussion regarding this patch, as the thread
suggests, I'd propose to go for an intermediate, less intrusive fix like
mine first.

Martin

-- 
Martin Wilck                Phone: +49 5251 8 15113
Fujitsu Siemens Computers   Fax:   +49 5251 8 20409
Heinz-Nixdorf-Ring 1	    mailto:Martin.Wilck@Fujitsu-Siemens.com
D-33106 Paderborn           http://www.fujitsu-siemens.com/primergy
