From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TTL patch buggy?
Date: Thu, 8 Jan 2004 08:14:14 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401080812490.13863-100000@filer.marasystems.com>
References: <20040107221614.GE20346@cannon.eng.us.uu.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   "John A. Sullivan III" <john.sullivan@nexusmgmt.com>,
   <netfilter@lists.netfilter.org>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ramin Dousti <ramin@cannon.eng.us.uu.net>
In-Reply-To: <20040107221614.GE20346@cannon.eng.us.uu.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 7 Jan 2004, Ramin Dousti wrote:

> Absolutely. For a sec I forgot all about the dense mode. Thanks, Henrik.
> However, I still don't see any "danger" about this.

The danger is in if you forget about this and set the TTL on multicast as 
if it was normal traffic. You then allow this multicast traffic to be 
distributed widely outside your network even if the originator had taken 
care to make sure distribution is not allowed far beyond the local 
networks.

Regards
Henrik
