From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFNL_NFA_NEST
Date: Sat, 24 Mar 2007 15:37:32 +0100
Message-ID: <460537AC.4000509@trash.net>
References: <4600BDBB.8020205@trash.net> <4601B796.5030100@netfilter.org>
	<460261EB.4000402@trash.net> <46028242.4090609@netfilter.org>
	<460284D4.30709@trash.net> <4602B25B.10909@netfilter.org>
	<4602B667.2030304@trash.net> <4603C5AC.1070808@netfilter.org>
	<4603CF78.3030501@trash.net> <46041064.4080806@netfilter.org>
	<46050233.5040603@trash.net> <46050BD4.7080109@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46050BD4.7080109@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Alternatively, we could add support for the nest bit in the receive side
> of genetlink and OR the nest bit in nfnetlink for messages sent to
> userspace.


Well, fine if Thomas doesn't mind.

> Thomas, do you have any suggestion on where to go?


Some context: removal of all the duplicated nfnetlink code is currently
hindered by the NFNL_NFA_NEST bit, which is the highest bit of nfa_type
and is set on nested attributes to allow walking nested attributes
without knowledge of their structure (for endian-conversion). To use
the generic code we need to either stop sending it from userspace (and
wait quite a while because of old libnfnetlink releases) or make the
generic code ignore it.

Your choice :)
