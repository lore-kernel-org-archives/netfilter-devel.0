From: James Morris <jmorris@intercode.com.au>
Subject: Re: Making ip_queue l3 independent
Date: Mon, 25 Aug 2003 01:04:45 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0308250101200.21951-100000@excalibur.intercode.com.au>
References: <20030824090106.GA10987@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: coreteam@netfilter.org,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030824090106.GA10987@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 24 Aug 2003, Harald Welte wrote:

> > It would be nice to maintain binary compatibility with current libipq, if 
> > possible.
> 
> Are you talking about userspace API compatibility to libipq, or binary
> compatiblity on the netlink socket?

Well, libipq is only provided as a static library currently, so the apps 
will need to be relinked if the netlink binary API changes.


- James
-- 
James Morris
<jmorris@intercode.com.au>
