From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT before IPsec with 2.6
Date: Fri, 23 Jan 2004 15:24:19 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401231521350.13626-100000@filer.marasystems.com>
References: <40112243.2060401@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michal Ludvig <mludvig@suse.cz>
In-Reply-To: <40112243.2060401@suse.cz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 23 Jan 2004, Michal Ludvig wrote:

> I.e. the postrouting on the unencrypted packet is really called right 
> before it gets encrypted. And the encrypted packet then hits the 
> POSTROUTING again, but it's already a different packet, actually.

My issue is with packets not destinated for an IPSec tunnel.. from what I 
read your patch these will hit POSTROUTING twice. But maybe I misread your 
patch?

Regards
Henrik
