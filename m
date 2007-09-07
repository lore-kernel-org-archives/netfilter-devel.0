From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] High Performance Packet Classification (HPPC) to succeed
 HIPAC
Date: Fri, 07 Sep 2007 12:57:16 +0200
Message-ID: <46E12E8C.3030603@trash.net>
References: <20070907090923.GA31885@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070907090923.GA31885@ekonomika.be>
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

Steven Van Acker wrote:
> Hi,
> 
> I'm a user of nf-HIPAC (http://www.hipac.org) and I've tried to monitor it's
> progress into the main kernel tree. Unfortunately, the work on nf-HIPAC seems to
> have stopped.  The last update of the website is from November 8th 2005, which
> is almost 2 years ago.
> 
> Unless there is some work being done on integrating HIPAC with iptables (or
> xtables), I would like to give this a go.
> 
> The main problem I see with this right now is that the patch is way too big to
> analyze and rework (at least for me). So instead, I would like to reimplement
> everything from scratch and integrate it with iptables from the very start.


We're holding the netfilter workshop next week, and one of the
topics will be a possible merge of nf-hipac. If this doesn't
work out, we'll start looking into alternatives, but until then
I prefer to stay optimistic :)

So lets postpone this discussion for a week.
