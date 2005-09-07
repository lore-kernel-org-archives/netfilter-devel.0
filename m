From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 2/8]: Add NetBIOS name service helper
Date: Wed, 07 Sep 2005 12:13:10 +0200
Message-ID: <431EBD36.1040503@trash.net>
References: <431DD813.8010309@trash.net>
	<431DDB7C.3010503@trash.net>	<m2slwh617b.fsf@cerbere.dyndns.info>	<20050906.195649.54560179.davem@davemloft.net>	<431E5800.9080406@trash.net>
	<m28xy98akl.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samir Bellabes <sbellabes@mandriva.com>
In-Reply-To: <m28xy98akl.fsf@cerbere.dyndns.info>
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

Samir Bellabes wrote:
> Patrick McHardy <kaber@trash.net> writes:
> 
>>Actually it was deliberate, I don't see a reason why the packet
>>should be dropped, its best effort.
> 
> All conntracks are dropping packets, in that way.
> netbios_ns should do the same, or other conntracks should be patched.

Dropping when NAT fails makes sense because the reply packet
must be handled and the state is required for this. Dropping
when setting up an expectation fails doesn't make any sense to
me, the reply could still make it because for example there
are no rules or it is accepted by the rulesset.

Connection tracking only does tracking, not filtering, and should
only drop packets if necessary for accurate tracking.

Look at the FTP helper for example. It also tracks passive mode
connections, which are in many cases allowed by the ruleset
anyway. By dropping the packet we break what might work otherwise.

So I think changing the other helpers to only drop when really
neccesary also makes sense.
