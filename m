From: Patrick McHardy <kaber@trash.net>
Subject: Re: early_drop() not working correctly?
Date: Fri, 07 Jul 2006 06:07:53 +0200
Message-ID: <44ADDE19.2030503@trash.net>
References: <44AD1D10.6000208@netboxblue.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Menno Smits <menno@netboxblue.com>
In-Reply-To: <44AD1D10.6000208@netboxblue.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Menno Smits wrote:
> Hi list,
> 
> At one customer site we have a situation where a netfilter box sees half
>  of some connections due to asymmetric routing. This causes lots of
> ESTABLISHED but unreplied connections to fill the conntrack table with
> long (5 day) timeouts. Eventually the table completely fills up. The
> "nf_conntrack: table full, dropping packet" message is reported, packets
>  are dropped and the customer starts complaining.
> 
> According to discussions with Patrick McHardy off list and my own
> examinations of the code, early_drop() should free up some of the
> conntrack table when the table is full by removing unreplied
> connections. In practice, this doesn't actually happen.
> 
> I've experimented with a similar setup in the office and I can
> consistently replicate the problem. I'm happy to describe my test setup
> if anyone is interested (it's a little complicated).

I suggest adding some debugging printks to early_drop that dump the
other members of the hash chain and their flag values (epecially
IPS_ASSURED). Or simply to unreplied(). That should exlain what's
going on.
