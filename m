From: "Andrew Hall" <andrew.hall@bluereef.com.au>
Subject: Re: Multiple Address specification or match
Date: Thu, 30 Sep 2004 18:46:36 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <001d01c4a6c9$fec61c10$2201010a@bluereef.local>
References: <018201c4a6ab$a1ecb6c0$2201010a@bluereef.local>
	<415BAAF0.6030907@rediffmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Swapnil Nagle" <swapsn@rediffmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Yes you're right, I meant 'or'd not 'anded' together.

----- Original Message -----
From: "Swapnil Nagle" <swapsn@rediffmail.com>
To: "Temp02" <temp02@bluereef.com.au>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Thursday, September 30, 2004 4:42 PM
Subject: Re: Multiple Address specification or match


>
> >How difficult would it be to extend netfilter/iptables to allow multiple
> >source/destination address pairs (with negation) 'anded' together, as
in -s
> >192.168.0.0/24 -s 10.0.0.0/8 -s ! 230.22.22.0/24. Or a match to do this
same
> >thing?
> >
> >
> How can the source address be "anded" ?
> The source address cannot be both 192.168.0.1 and 10.0.0.1.
>
> -- Swapnil
>
