From: Willy Tarreau <willy@w.ods.org>
Subject: Re: NAT before IPsec with 2.6
Date: Sat, 24 Jan 2004 10:27:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040124092721.GA19140@alpha.home.local>
References: <20040124082252.GA19035@alpha.home.local> <Pine.LNX.4.44.0401241015470.32723-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401241015470.32723-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jan 24, 2004 at 10:21:12AM +0100, Henrik Nordstrom wrote:
 
> These hooks have not yet been done, mostly because nobody has contributed
> the code adding these hooks to the new IPSec implementation in a 
> reasonable manner I guess.

OK, that's good news. At first, I thought that people were against this
mode of operation. This is now just a matter of time for anyone of us to
understand how to add the hooks and send a patch ! I wish I add time...

Regards,
Willy
