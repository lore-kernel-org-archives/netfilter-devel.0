From: Patrick Schaaf <bof@bof.de>
Subject: Re: Idea: string replace
Date: Tue, 1 Oct 2002 09:27:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021001072702.GA23302@oknodo.bof.de>
References: <20021001011306.GG16521@noir.cb.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Surda <shurdeek@panorama.sth.ac.at>
Content-Disposition: inline
In-Reply-To: <20021001011306.GG16521@noir.cb.ac.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Peter,

> I have an idea, which is IMHO very suitable for China. Er, no, wanted to say
> something different, suitable for me. How about adding a --replace-with option
> to the string match? Is it difficult?

I assume that you are aware of the reasons why the STRING approach
risks both false positives and false negatives, and I'll spare you
the usual rant.

Regarding the "is it difficult" question, that depends on whether you
want to replace with a string of identical length (piece of cake),
or a string of different length. In the latter case, your new code
has to reallocate the packet buffer to the appropriate new total
size, and it must recalculate TCP sequence numbers (both ways,
permanently, meaning you absolutely need connection tracking).
To get a feel for the complexity, have a look at the FTP connection
tracking and NAT helpers - they are doing just that with the FTP
PORT command in the control connection, when NAT is active.

If you actually venture to implement this, please really look at
what the FTP helpers do, and think hard about how to factor out
the complexity into a generic helper module that can be used both
from the FTP code, and from your new code.

good luck!
  Patrick
