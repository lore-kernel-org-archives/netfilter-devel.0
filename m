From: Stephen Hemminger <shemming@brocade.com>
Subject: Re: header conflict introduced by change to
 netfilter_ipv4/ip_tables.h
Date: Thu, 7 Jan 2016 10:30:40 -0800
Message-ID: <20160107103040.649ab878@xeon-e3>
References: <20160106092007.1c5a0c75@xeon-e3>
	<88a455d4b6dc4d4398553e6529d7b94a@HQ1WP-EXMB11.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <88a455d4b6dc4d4398553e6529d7b94a@HQ1WP-EXMB11.corp.brocade.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 7 Jan 2016 07:29:50 +0000
Mikko Rapeli <mikko.rapeli@iki.fi> wrote:

> On Wed, Jan 06, 2016 at 09:20:07AM -0800, Stephen Hemminger wrote:
> > This commit breaks compilation of iproute2 with net-next.
> 
> Ok, linux/if.h and libc net/if.h have overlapping defines, and this is not
> the only one. I saw lots of them in the core dump headers.
> 
> How should we handle them? Another ifndef for IFNAMSIZ into kernel uapi
> headers?
> 
> -Mikko

Probably need to do the same thing that was done previously for these
kind of conflicts.  This makes make linux/if.h change to adapt to net/if.h
being included before it.

Or revert your patch.
