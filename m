From: "Jesse Peng" <jesse@deansoft.com.tw>
Subject: Re: Re[2]: bidirectional CONNMARK?
Date: Fri, 11 Mar 2005 13:08:31 +0800
Message-ID: <001c01c525f8$5e807080$0f01a8c0@jessebidwxa7q3>
References: <20050309124806.A55C.LARK@linux.net.cn><Pine.LNX.4.61.0503091019020.6780@filer.marasystems.com>
	<20050309174657.A56E.LARK@linux.net.cn>
	<001801c5252e$a6c09750$0f01a8c0@jessebidwxa7q3>
	<Pine.LNX.4.61.0503101056360.26065@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Henrik Nordstrom" <hno@marasystems.com>
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


----- Original Message -----
From: "Henrik Nordstrom" <hno@marasystems.com>
To: "Jesse Peng" <jesse@deansoft.com.tw>
Cc: "Wang Jian" <lark@linux.net.cn>; <netfilter-devel@lists.netfilter.org>
Sent: Thursday, March 10, 2005 5:59 PM
Subject: Re: Re[2]: bidirectional CONNMARK?


> On Thu, 10 Mar 2005, Jesse Peng wrote:
>
> >>> Then you need to structure the use of CONNMARK differently, and
> > depending
> >>> on the direction set different marks.
> >
> > This doesn't work for a single session.Say,if you want packets in
original
> > dir be classified as 0x01 mark,
> > but packets in reply dir be classifid as 0x02 mark.But as CTDIRMARK
> > applied,things can be easily done.
>
> What I meant here is to not use CONNMARK to direcly specify the nfmark of
> the packets, but the class of the session and from this derive what the
> mark should be.
>
> Or another method, as Wang Jian already mentioned is to mask the CONNMARK
> when restoring it into the packet, allowing you to for example specify the
> nfmark 0x01 in one direction and 0x0200 in the other. There is 32 bits to
> play with.
>
As things getting complicated,you don't want your whole design plan fooled
by the mask.
But I'd admit I never come out any idea concerning the mask,you win...hmm..

> Regards
> Henrik
