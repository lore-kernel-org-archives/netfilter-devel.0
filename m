From: Willy Tarreau <willy@w.ods.org>
Subject: Re: NAT before IPsec with 2.6
Date: Fri, 23 Jan 2004 07:57:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040123065749.GA16708@alpha.home.local>
References: <400E7095.9040709@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michal Ludvig <mludvig@suse.cz>
Content-Disposition: inline
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

Hi,

On Wed, Jan 21, 2004 at 01:29:09PM +0100, Michal Ludvig wrote:
> So I hacked up this simple solution - I understand that it won't be 
> accepted as-is, because now the POSTROUTING chain is reached twice (once 
> from ip_forward and once from ip_output). But anyways - is this a 
> correct approach and should I go this way with some cleanups?

I don't know if it's a correct approach, but I really think that all tables
and chains should apply to a consistent level of encapsulation, whatever it
is. Before, it was easy to process the packet at different levels because it
was sent to one (or even several) interemediate virtual interfaces. To keep
control of what goes in and out, now we should :

  1) re-evaluate all previously evaluated chains when a packet has been
     decapsulated ;
  2) re-inject encapsulated packets into the output & postrouting chains
     (it's a locally generated packet after all, it has no reason to bypass
     output filtering).
  3) keep assigned fwmark between passes so that we can track what each
     packet does.

I believe that 1) & 3) are already done, but I don't know if there's a general
consensus towards or against 2).

Cheers,
Willy
