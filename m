From: Ramin Dousti <ramin@cannon.eng.us.uu.net>
Subject: Re: TTL patch buggy?
Date: Wed, 7 Jan 2004 15:36:24 -0500
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <20040107203624.GA20346@cannon.eng.us.uu.net>
References: <Pine.LNX.4.44.0401071709030.4717-100000@filer.marasystems.com> <1073502275.16972.10.camel@jasiiitosh.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Henrik Nordstrom <hno@marasystems.com>, netfilter@lists.netfilter.org,
   Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Content-Disposition: inline
In-Reply-To: <1073502275.16972.10.camel@jasiiitosh.nexusmgmt.com>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 07, 2004 at 02:04:36PM -0500, John A. Sullivan III wrote:

> 
> Thank you very much but could you please explain this a bit more.

The whole TTL concept is meant to deal with the routing loops. Just
imagine what happens if there is a routing loop between your gateway
and the ISP's upstream router. The packets would be bouncing back and
forth forever (until your gateway is rebooted) and the throughput
of your bandwidth would drop to +-zerro.

Now if you anticipate no routing loop (which is extremely unlikely
in the current architecture of how the ISP's do business) you should
be fine. However, these routing loops could happen when people start
mixing the TTL-increments with MIRROR:

http://www.netfilter.org/security/2001-08-22-mirror.html

Ramin
