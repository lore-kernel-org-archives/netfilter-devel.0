From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Packet Fragementation
Date: Wed, 31 Mar 2004 15:09:25 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403311457230.21410-100000@filer.marasystems.com>
References: <20040331123439.14349.qmail@web13909.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040331123439.14349.qmail@web13909.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 31 Mar 2004, Scott MacKay wrote:

> Basically, incoming packets will be in a mangled
> 
> --- Henrik Nordstrom <hno@marasystems.com> wrote:
> > On Wed, 31 Mar 2004, Scott MacKay wrote:
> 
> > > Then, as an option, is there any way to make a
> > packet
> > > re-enter the conntrack after mangle in PREROUTING?
> > 
> > 
> > What you mean?
>
> state, so conntrack likely will not make any useful
> associations (data-aware type associations), though it
> can provide the service of tying back together
> fragments.  I need to de-mangle, but am limited to
> mangle/PREROUTING (to get the de-fragmented data, the
> same data I would be mangling in the sender's
> mangle/POSTROUTING).


there is plenty of space inbetween defragmenting and conntrack..

defragmentation runs at a separate hook at 
priority NF_IP_PRI_CONNTRACK_DEFRAG (-400) while conntrack runs at 
NF_IP_PRI_CONNTRACK (-200). Anything you do between there will see 
defragmented packets before conntrack sees them. This applies to both 
NF_IP_PRE_ROUTING (input) and NF_IP_LOCAL_OUT (output).

In iptables you have the "raw" table which runs at NF_IP_PRI_RAW 
(-200). If you are writing your own netfilter module for the 
mangling/demangle then any priority -399 to -201 will place your module 
between defragmentation and connection tracking.

Then in NF_IP_POST_ROUTING there is two conntrack hooks running at the
very last prioritites, one which confirms sessions (makes the conntrack
"official"), immediately followed by the refragmenter. The first is not
involved in connection tracking as such, it only confirms the session
related to the packet in connection tracking as a valid session.

Regards
Henrik
