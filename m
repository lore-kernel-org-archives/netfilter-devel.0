From: Stephen Lee <mukansai@emailplus.org>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Fri, 05 Dec 2003 22:25:53 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031205222541.3427.MUKANSAI@emailplus.org>
References: <20031205045020.4C0E.MUKANSAI@emailplus.org> <3FCF9497.3030708@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Stephen Lee <mukansai@emailplus.org>,
   "Feldman, Scott" <scott.feldman@intel.com>,
   Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
   linux-kernel@vger.kernel.org, "David S. Miller" <davem@redhat.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <3FCF9497.3030708@pobox.com>
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

Okay, I reproduced it with tg3 on 2.6.0-test11 as well, by turning on
TSO with ethtool.  So it does seem to be an incompatibility between TSO
& conntrack.

"David S. Miller" <davem@redhat.com> wrote:
> This workaround explains everything.  The TSO packets have to be
> "un-TSO'd" in order for netfilter to look at the packet and parse
> the contents.  This means copying all the data around, allocating
> several networking buffers, etc.

But, if netfilter needs to see all the contents in order to function,
shouldn't TSO break other parts of netfilter as well?  Why is only
conntrack affected?

Jeff Garzik <jgarzik@pobox.com> wrote:
> Regardless, the problem is identified -- when TSO+conntrack is present,
> we "TSO" net traffic then "un-TSO" it.

This "un-TSO"ing more or less defeats the purpose of TSO, right?  

> It's simply better to not use TSO at all, for this case.

If that is the case, I suppose so.

Thanks,
Stephen
