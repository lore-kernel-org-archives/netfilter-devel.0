From: Michal Ludvig <mludvig@suse.cz>
Subject: Re: NAT before IPsec with 2.6
Date: Fri, 23 Jan 2004 15:40:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4011325F.6030308@suse.cz>
References: <Pine.LNX.4.44.0401231521350.13626-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401231521350.13626-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom told me that:
> On Fri, 23 Jan 2004, Michal Ludvig wrote:
> 
>>I.e. the postrouting on the unencrypted packet is really called right 
>>before it gets encrypted. And the encrypted packet then hits the 
>>POSTROUTING again, but it's already a different packet, actually.
> 
> My issue is with packets not destinated for an IPSec tunnel.. from what I 
> read your patch these will hit POSTROUTING twice. But maybe I misread your 
> patch?

Yes, that's true. But how to solve it? The best would be to skip the 
first POSTROUTING if the packet won't be encapsulated. But we can't know 
whether or not it will go to IPsec until we perform NAT on it. So it 
looks like we must skip the second POSTROUTING in the case where the 
packet was encapsulated. But how can we recognise these two situations?
Wild idea - comparing some hashes (src/dst ip/port) before and after the 
first POSTROUTING call?

Michal Ludvig
-- 
SUSE Labs                    mludvig@suse.cz | Cray is the only computer
(+420) 296.545.373        http://www.suse.cz | that runs an endless loop
Personal homepage http://www.logix.cz/michal | in just four hours.
