From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] Re: [PATCH] net: netfilter: Remove multiple
 assignment.
Date: Mon, 27 Mar 2017 14:21:53 +0200
Message-ID: <20170327122153.GA25113@salvia>
References: <20170325124946.GA9109@arushi-HP-Pavilion-Notebook>
 <20170327120827.GA15676@salvia>
 <CA+XqjF_4cXL58vnxgKmawuZ4F0ZqvU1KvAtRbJv_r1ArLTpExw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com
To: Arushi Singhal <arushisinghal19971997@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+XqjF_4cXL58vnxgKmawuZ4F0ZqvU1KvAtRbJv_r1ArLTpExw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Mar 27, 2017 at 05:48:41PM +0530, Arushi Singhal wrote:
> On Mon, Mar 27, 2017 at 5:38 PM, Pablo Neira Ayuso <pablo@netfilter.org>
> wrote:
> 
> > On Sat, Mar 25, 2017 at 06:19:47PM +0530, Arushi Singhal wrote:
> > > This patch removes multiple assignments.
> > > Done using coccinelle.
> > > @@
> > > identifier i1,i2;
> > > constant c;
> > > @@
> > > - i1=i2=c;
> > > + i1=c;
> > > + i2=c;
> >
> > You have to explain why this is bad.
> >
> 
> It is against the kernel coding style and we have to avoid multiple
> assignments to make the code more readable.
> This error is found using Checkpatch.pl script.

Then, please place this information in your patch description.

Thanks!
