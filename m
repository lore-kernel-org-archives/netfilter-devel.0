From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Dynamic rule creation and deletion
Date: Thu, 26 Feb 2004 09:10:06 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402260908040.7600-100000@filer.marasystems.com>
References: <1077773683.10637.37.camel@vijay>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jambunathan Kalyanasundaram <k_jambunathan@yahoo.co.uk>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
In-Reply-To: <1077773683.10637.37.camel@vijay>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 Feb 2004, Vijaya Chandra Vupputuri wrote:

> Wouldn't a REDIRECTion to the port on which your proxy listens, be
> sufficient ( which I guess is the suggested way to have transparent
> proxying with squid )?

No, this just makes traffic which was originally destined to the origin 
server redirected to the proxy, it does not allow the proxy to masquerade 
himself as the client when forwarding the request

As said earlier the TPROXY patch is developed for this sepcific purpose, 
allowing fully "transparent" proxy operation assuming so is acceptable by 
your network design.

Regards
Henrik
