From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT before IPsec with 2.6
Date: Fri, 23 Jan 2004 13:31:37 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401231329250.12080-100000@filer.marasystems.com>
References: <400E7095.9040709@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michal Ludvig <mludvig@suse.cz>
In-Reply-To: <400E7095.9040709@suse.cz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 21 Jan 2004, Michal Ludvig wrote:

> So I hacked up this simple solution - I understand that it won't be 
> accepted as-is, because now the POSTROUTING chain is reached twice (once 
> from ip_forward and once from ip_output). But anyways - is this a 
> correct approach and should I go this way with some cleanups?

The ip_forward call should be moved to just before where the packets gets
encapsulated when using IPSec. When using IPSec this is the conceptual 
POSTROUTING point in the stack for the plain packets.

Other than that I see no direct problems.

Regards
Henrik
