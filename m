From: Markus Schaber <markus.schaber@student.uni-ulm.de>
Subject: Re: [Fwd: ACCEPT/DROP]
Date: Thu, 2 Jan 2003 00:10:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030102001023.75d8d3da.markus.schaber@student.uni-ulm.de>
References: <Pine.LNX.4.44.0212241649520.27999-100000@el-zoido.localnet>
	<3E099B19.50705@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3E099B19.50705@hipac.org>
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

Thomas Heinz wrote:

> You wrote:
> > This may be true for code, but iptables rules describe sets of
> > packets
> 
> This is true for the basic cases only. In general the matches of a
> rule must be considered to be arbitrary packet action (ACCEPT, DROP,
> CONTINUE) returning functions that may even return different actions
> for the same packet. The only constraint for matches is that they
> should work read-only on the packet content, i.e. not modify it.

That's true, as examples one may see the state matches, or the random
match.


Markus

-- 
Schabi's Flohmarkt: http://www.uni-ulm.de/~s_mschab/flohmarkt/

Der Dienstweg ist die Verbindung der Sackgasse mit dem Holzweg!
[DoLi in unibwm.studium]
