From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: iptables as a state machine
Date: Fri, 01 Oct 2004 13:33:52 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096662832.23645.4.camel@localhost.localdomain>
References: <20040930193955.6fa24afc.davem@davemloft.net>
	<61687.63.170.215.71.1096602469.squirrel@www.osdl.org>
	<20040930210127.0ac9623c.davem@davemloft.net>
	<415D1437.6030503@hipac.org>
	<20041001124608.6a6b374c.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Thomas Heinz <creatix@hipac.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20041001124608.6a6b374c.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2004-10-01 at 12:46 -0700, David S. Miller wrote:
> On Fri, 01 Oct 2004 10:24:23 +0200
> Thomas Heinz <creatix@hipac.org> wrote:
> 
> > Your statement about the algorithmic approach of nf-hipac
> > is wrong.
> 
> Thanks for the correction.
> 
> > This approach was already considered very early in history
> > of packet classification. Even more complex matchings as
> > context free grammars have been used. Nonetheless, even
> > regular expressions have been found to not being able to
> > cope with high performance demands of todays rule bases.
> 
> Any pointers to papers on this topic?

Current state described here:

http://www.netfilter.org/documentation/conferences/nf-workshop-2004-summary.html#AEN525
