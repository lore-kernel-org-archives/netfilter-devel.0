From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Sun, 22 Aug 2004 22:43:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040822204326.GA25567@sch.bme.hu>
References: <1092407190.2402.120.camel@nienna.balabit> <20040819110646.GJ3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, KOVACS Krisztian <hidden@balabit.hu>,
        Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
        netfilter-devel <netfilter-devel@lists.netfilter.org>,
        jamal <hadi@cyberus.ca>
Content-Disposition: inline
In-Reply-To: <20040819110646.GJ3921@sunbeam.de.gnumonks.org>
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

On Thu, Aug 19, 2004 at 01:06:46PM +0200, Harald Welte wrote:
> >         So, do anyone know of anything which could be used by ct_sync?
> >         (It has to be a semi-reliable, connectionless multicast protocol
> >         with a _very_ low overhead.)
> 
> everything I've seen so far about reliable multicast is inherently
> complex.

  Oops, I've just found TIPC. Does anyone know enough details of TIPC to
judge if its reliable multicast service would be useful for us? I've just
downloaded the IETF draft, and it seems to me that the reliable multicast
service provided by TIPC may be useful (section 2.9 of the draft). Any
ideas?

  The SourceForge URL:

  http://sourceforge.net/projects/tipc/

-- 
 KOVACS Krisztian
