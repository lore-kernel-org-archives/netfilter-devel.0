From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Altering destination ethernet device
Date: Fri, 25 Jun 2004 16:39:47 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406251637550.4846-100000@filer.marasystems.com>
References: <20040625141628.93477.qmail@web13903.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "John A. Sullivan III" <jsullivan@opensourcedevelopmentcorp.com>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040625141628.93477.qmail@web13903.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 25 Jun 2004, Scott MacKay wrote:

> Cool.  I will look at that.  I did see some routing
> type info at http://lartc.org/ (Linux Advanced Routing
> & Traffic Control), but nothing to the degree of
> control I wanted.  I figured since I am already
> grabbing packets in netfilter I would see about
> altering them while I had em :)

See the ROUTE target in iptables for some hints. Does all your need in
terms or (re)programmed routing and much more...

Regards
Henrik
