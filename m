From: Patrick Schaaf <bof@bof.de>
Subject: Re: Brute force printk routines for looking at netfilter structures
Date: Wed, 18 Dec 2002 00:07:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021217230706.GB25448@oknodo.bof.de>
References: <000001c2a609$30f256e0$0100a8c0@zultys.com> <20021217203737.GA25448@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ranjeet Shetye <ranjeet.shetye@zultys.com>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20021217203737.GA25448@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > signed int nf_debug_indent = 0;
> 
> Why signed? Anyway, this will fall on its face on SMP systems.
> Cure: use atomic_t.

Ahem. Given the application, a per-cpu nf_debug_indent would be
the proper cure, together with preventing preemption whenever
nf_debug_indent is above 0. You can then also printk the CPU
number along with the rest :-)

best regards
  Patrick
