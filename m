From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Aren't these connections ESTABILISHED? (2nd take)
Date: Mon, 3 Oct 2005 10:30:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510031025270.22605@filer.marasystems.com>
References: <dhmn38$hsk$1@sea.gmane.org> <200510011907.27026.rob0@gmx.co.uk>
	<Pine.LNX.4.61.0510020410200.21519@filer.marasystems.com>
	<dhnoqq$bq8$1@sea.gmane.org>
	<Pine.LNX.4.61.0510021142470.6283@filer.marasystems.com>
	<Pine.LNX.4.58.0510021534200.25897@blackhole.kfki.hu>
	<Pine.LNX.4.61.0510021622210.9126@filer.marasystems.com>
	<Pine.LNX.4.58.0510022155370.26361@blackhole.kfki.hu>
	<Pine.LNX.4.58.0510022306040.26492@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Robert Nichols <rnicholsNOSPAM@comcast.net>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0510022306040.26492@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2 Oct 2005, Jozsef Kadlecsik wrote:

> Hmmm, I must correct myself: the conntrack entry might get timed out, but
> then seeing the pure ACKs it picks up the connection again. Still:
>
>> However how would conntrack loose an (established) connection?

One case where the timeouts allows the above quite easily even if 
conntrack is running all the time is a half-closed connection. Here 
conntrack has entered FIN_WAIT with only a 2 minutes timeout.

Regards
Henrik
