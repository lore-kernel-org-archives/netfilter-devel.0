From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Augmenting conntrack
Date: Wed, 15 Oct 2003 05:27:33 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031015122733.52468.qmail@web13902.mail.yahoo.com>
References: <20031015100925.GA14198@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20031015100925.GA14198@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

aaah, I forgot about the raw table.  I think I tried
using that a bit back but had performance issues.  The
issues probably were unrelated to the raw table, I
would guess.  I will go and try that again first. 
Thanks!

--- Harald Welte <laforge@netfilter.org> wrote:
> On Tue, Oct 14, 2003 at 04:50:26AM -0700, Scott
> MacKay wrote:
> > The only things I can think of which might work
> would
> > be to change the NF_IP_PRI_CONNTRACK value to be
> > higher than MANGLE (ugly, doubt it would work),
> alter
> > the conntrack module to de-mangle what it sees so
> it
> > can establish connection tracking OK (also ugly
> and
> > not sure where I would start), or maybe a
> conntrack
> > helper module (saw amanda did this, was not sure
> if I
> > could specify a fairly wide criterea).  
> 
> or put your queue rule into PREROUTING of the 'raw'
> table (see
> patch-o-matic).


__________________________________
Do you Yahoo!?
The New Yahoo! Shopping - with improved product search
http://shopping.yahoo.com
