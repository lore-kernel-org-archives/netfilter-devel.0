From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: the solution to synflood on netfilter
Date: Sat, 27 Dec 2003 01:15:20 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312270100360.9836-100000@filer.marasystems.com>
References: <20031226081752.GB9391@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ?????? <zhengcb@netpower.com.cn>,
   "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031226081752.GB9391@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 26 Dec 2003, Harald Welte wrote:

> I think there is a clear line we really don't want to cross.  Such
> awkward breakage of end-to-end and protocol transparency is just not
> what we think should be deployed on the internet. 

Not to mention what mess such behavior easily could make to modern
standards-track TCP extensions such as TCP Window scaling, PAWS, ECN etc.

Regards
Henrik
