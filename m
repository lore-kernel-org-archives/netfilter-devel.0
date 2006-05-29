From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: Re: [PATCH] set match
Date: Mon, 29 May 2006 09:28:53 +0200
Message-ID: <1148887733.2955.5.camel@scaramouche.combox.de>
References: <1148838123.2516.1.camel@scaramouche.combox.de>
	<Pine.LNX.4.64.0605290030400.11391@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0605290030400.11391@bizon.gios.gov.pl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mo, 2006-05-29 at 00:33 +0200, Krzysztof Oledzki wrote:
> 
> On Sun, 28 May 2006, Torsten Luettgert wrote:
> 

> > here's a simple patch for the set match in pom. It adds the
> > new protoff parameter in the match function of ipt_set.c and
> > changes struct ipt_ip * to void * in the checkentry function
> > of ipt_set.c and ipt_SET.c, so they compile without warnings.
> 
> http://lists.netfilter.org/pipermail/netfilter-devel/2006-March/023808.html
> 
> http://svn.netfilter.org/cgi-bin/viewcvs.cgi?rev=6569&view=rev

Looks like your change was reverted at revision 6592 with
ipset 2.2.9, probably by accident.

Rest assured I wouldn't post a patch which doesn't apply to
the current revision :-)

Regards,
Torsten
