From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 14:57:01 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401271449400.17979-100000@filer.marasystems.com>
References: <20040127132725.GA14685@openoffice.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, Willy Tarreau <willy@w.ods.org>,
   Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Valentijn Sessink <valentyn+netfilter-users@nospam.openoffice.nl>
In-Reply-To: <20040127132725.GA14685@openoffice.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Jan 2004, Valentijn Sessink wrote:

> On output, however, things are not so transparant. A packet hits OUTPUT,
> then gets encrypted. A totally different packet hits POSTROUTING. This makes
> no sense.

And there the required hooks needs to be inserted in the IPSec 
implementation to call

a) POSTROUTING before the final decision that this packet is to go via 
IPSec. Note that this may need to allow reroute of the packet including 
IPSec policy. Because of this some changes may be needed in the IPSec 
implementation for this to be complete. 

b) After encrypting OUTPUT needs to be called on the encrypted packet 
before the packet leaves IPSec and continues the normal path leading to 
POSTROUTING.

> There's no symmetric behaviour now.

We all know that, and is why this discussion exists in order to find out 
how it should be.

> And from an "input" perspective, I think a decapsulated packet that has
> a locally ending payload should hit INPUT again. Same with output: a
> locally generated packet hits output, then should hit OUTPUT again if it
> was really destined for the outside world.

To this we all agree from what I can tell.

Regards
Henrik
