From: KOVACS Krisztian <piglet@sch.bme.hu>
Subject: Re: find_appropriate_src() BUG also exist in 2.4.24
Date: Sun, 4 Apr 2004 18:44:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040404164436.GA17807@sch.bme.hu>
References: <20040403020119.1945.qmail@web41707.mail.yahoo.com> <1080985657.11647.1.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zhi wang <pangy2004@yahoo.com>,
        Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1080985657.11647.1.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Sat, Apr 03, 2004 at 11:47:37AM +0200, Martin Josefsson wrote:
> On Sat, 2004-04-03 at 04:01, zhi wang wrote:
> > Current 2.6 kernel has fixed this bug. It should be used in current 2.4 kernel
> > also.
> 
> The fix is included in 2.4-bk, it will be included in 2.4.26 when that
> is released.

  Martin, I think this is a different problem than the LIST_DELETE-related
bug fixed in -bk (and 2.6.5). Are you sure it is solved?

-- 
 Regards,
  Krisztian KOVACS
