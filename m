From: Martin Wilck <Martin.Wilck@Fujitsu-Siemens.com>
Subject: Re: ip_conntrack_hash() problem
Date: 05 Sep 2002 20:24:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1031250277.9785.175.camel@biker.pdb.fsc.net>
References: <1031210342.9785.159.camel@biker.pdb.fsc.net>
	<20020905115208.4D0A02C064@lists.samba.org>
	<20020905135440.A10805@wotan.suse.de>  <20020905195547.A21899@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
   Harald
	Welte <laforge@gnumonks.org>,
   Netfilter Mailing List <netfilter-devel@lists.netfilter.org>,
   Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020905195547.A21899@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Am Don, 2002-09-05 um 19.55 schrieb Patrick Schaaf:
> As a short time fix, seeing that it's mostly even hash bucket counts
> that give a problem, I would still propose just making the bucket count
> the nearest odd number, i.e. basically htable_size |= 1 in the startup code.
> 
> I don't expect any user to notice such a miniscule change.

Well then, as most people seem to think this is the way to go, let's do
it, and hope that Rusty's patch will be ready for prime-time soon.

Martin

-- 
Martin Wilck                Phone: +49 5251 8 15113
Fujitsu Siemens Computers   Fax:   +49 5251 8 20409
Heinz-Nixdorf-Ring 1	    mailto:Martin.Wilck@Fujitsu-Siemens.com
D-33106 Paderborn           http://www.fujitsu-siemens.com/primergy
