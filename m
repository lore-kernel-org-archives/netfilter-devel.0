From: "Jesse Peng" <jesse@deansoft.com.tw>
Subject: Re: Re[4]: bidirectional CONNMARK?
Date: Fri, 11 Mar 2005 13:03:37 +0800
Message-ID: <001601c525f7$afa67a00$0f01a8c0@jessebidwxa7q3>
References: <20050309174657.A56E.LARK@linux.net.cn>
	<001801c5252e$a6c09750$0f01a8c0@jessebidwxa7q3>
	<20050310144752.C5AB.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: "Wang Jian" <lark@linux.net.cn>, <netfilter-devel@lists.netfilter.org>
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

Dear Jian:
Sorry,as you know,I am at a commercial firm,everything need approving.Please
notice 2 places:
1.in ip_conntrack.h,you need add your bidirection structure for containing
your 2 marks for 1 session.
2.in ip_conntrack_core.c,just adjacent to Henric's patch,you need to add how
you move the expectant's marks to its expected.

----- Original Message -----
From: "Wang Jian" <lark@linux.net.cn>
To: "Jesse Peng" <jesse@deansoft.com.tw>;
<netfilter-devel@lists.netfilter.org>
Sent: Thursday, March 10, 2005 2:49 PM
Subject: Re[4]: bidirectional CONNMARK?


> Hi Jesse Peng,
>
> No problem :) I will write a target based on CONNMARK myself.
>
> On Thu, 10 Mar 2005 13:04:33 +0800, "Jesse Peng" <jesse@deansoft.com.tw>
wrote:
>
> > Dear Jian
> >      I need to get my boss for approving,as you know,it's currently on
> > production use since late 2004.
> >
> >
> > ----- Original Message -----
> > From: "Wang Jian" <lark@linux.net.cn>
> > To: "Henrik Nordstrom" <hno@marasystems.com>
> > Cc: <netfilter-devel@lists.netfilter.org>
> > Sent: Wednesday, March 09, 2005 5:54 PM
> > Subject: Re[2]: bidirectional CONNMARK?
> >
> >
> > > Hi Henrik Nordstrom,
> > >
> > > Below is a test script, which uses mark/mask to do bi-directional
> > > control. I just craft it and haven't test it yet. (Need to compile a
new
> > > iptables in the test bed, later)
> > >
> > > Jesse <jesse@deansoft.com.tw> tells me off-list that he has a
CTDIRMARK
> > > target based on CONNMARK. Looking forward to his code for easier use.
> > >
> > >
