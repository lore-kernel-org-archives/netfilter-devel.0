From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: More on ip_conntrack problems
Date: Wed, 10 Jul 2002 12:25:39 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207101225.39773@henrik.marasystems.com>
References: <1026285021.14566.80.camel@trent.nin>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: alex <alex@bennee.com>,
	Netfilter Development Mailing List <netfilter-devel@lists.samba.org>
In-Reply-To: <1026285021.14566.80.camel@trent.nin>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 10 July 2002 09.10, alex wrote:
> I've seen numerous references to percieved problems with default
> timeouts and potential DoS attacks on ip_conntrack but I'm starting
> to think is possible to ip_conntrack just to miss connection
> closures.

It can.. see the archives. Posted a relatively detailed description on 
when conntrack will miss connection closures some weeks 
ago..<http://lists.samba.org/pipermail/netfilter-devel/2002-June/004906.html> 
Quite likely to happen if you have clients on unreliable connections.

Most people running larger conntrack setups probably won't notice 
unless they are under attack as the frequency this happens in normal 
traffic is very low, but if you have a small conntrack table and 
relatively many rapid connections then you may experience problems as 
each forgotten connection occupies a conntrack slot for a 
considerable amount of time..

To tell if this is your problem you need to do what Patrick Schaaf suggested. 
If you see that your conntrack box thinks there is many more 
CONNECTED TCP connections than there is ESTABLISHED connections on your 
server then you are bitten by this lost connection closures.

If you see that there is no big difference then your problem is simply
that your conntrack table is too small for the traffic you are seeing.

In any event, you most likely need to increase the conntrack hash 
table if you haven't already.. see the FAQ/Howto documents..

Regards
Henrik Nordström
MARA Systems AB, Sweden
